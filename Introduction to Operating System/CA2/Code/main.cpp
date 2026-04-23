#include <bits/stdc++.h>
#include <unistd.h>
#include <sys/wait.h>
#include <dirent.h>
using namespace std;

int main(int argc, char** argv) {

    if (argc != 2) {
        cerr << "Enter num of calculation nodes\n" ;
        return 1;
    }

    int cal_nodes_num = stoi(argv[1]);

    vector<string> files_name;
    DIR* directory = opendir("assets");
    while (auto *item = readdir(directory)) {
        string file_name = item->d_name;
        if (file_name.size()>4 && file_name.substr(file_name.size()-4) == ".csv")
            files_name.push_back("assets/"+file_name);
    }
    closedir(directory);
    int files_num = files_name.size();

    vector<array<int,2>> ext2ld_pipes(files_num);
    for (auto &pipe_item: ext2ld_pipes) 
        pipe(pipe_item.data());

    for (int i = 0; i < files_num; i++) {
        pid_t pid = fork();
        if (pid<0) { 
            perror("fork"); 
            exit(1); 
        }
        if (pid==0) {
            for (int j=0; j<files_num; j++){
                if (j!=i) { 
                    close(ext2ld_pipes[j][0]);
                    close(ext2ld_pipes[j][1]);
                }
            }
            
            dup2(ext2ld_pipes[i][1], STDOUT_FILENO);
            close(ext2ld_pipes[i][1]);
            execlp("./extract_transform", "extract_transform", files_name[i].c_str(), nullptr);
            perror("extract or transform node failed"); 
            exit(1);
        }
    }

    for (auto &pipe_item: ext2ld_pipes) 
        close(pipe_item[1]);

    vector<array<int,2>> ld2cal_pipes(cal_nodes_num);
    for (auto &pipe_item: ld2cal_pipes)
        pipe(pipe_item.data());

    vector<array<int,2>> cal2out_pipes(cal_nodes_num);
    for (auto &pipe_item: cal2out_pipes)
        pipe(pipe_item.data());

    {
        pid_t pid = fork();
        if (pid==0) {
            vector<string> fd_args;

            fd_args.push_back(to_string(files_num));
            for (auto &pipe_item: ext2ld_pipes) 
                fd_args.push_back(to_string(pipe_item[0]));

            fd_args.push_back(to_string(cal_nodes_num));
            for (auto &pipe_item: ld2cal_pipes) 
                fd_args.push_back(to_string(pipe_item[1]));

            vector<char*> ld_argv;
            ld_argv.push_back((char*)"./load");
            for (auto &s:fd_args) 
                ld_argv.push_back((char*)s.c_str());
            ld_argv.push_back(nullptr);

            execvp("./load", ld_argv.data());
            perror("load node faild"); 
            exit(1);
        }
    }
    
    for (auto &pipe_item: ext2ld_pipes) 
        close(pipe_item[0]);
    for (auto &pipe_item: ld2cal_pipes)
        close(pipe_item[1]);

    for (int i = 0; i < cal_nodes_num; i++) {
        pid_t pid = fork();
        if (pid==0) {
            dup2(ld2cal_pipes[i][0], STDIN_FILENO);
            dup2(cal2out_pipes[i][1], STDOUT_FILENO);

            for (auto &pipe_item: ld2cal_pipes) {
                close(pipe_item[0]);
                close(pipe_item[1]);
            }

            for (auto &pipe_item: cal2out_pipes) {
                close(pipe_item[0]);
                close(pipe_item[1]);
            }

            execlp("./calculation", "calculation", nullptr);
            perror("calculation node faild"); exit(1);
        }
    }

    for (auto &pipe_item: ld2cal_pipes) {
        close(pipe_item[0]);
        close(pipe_item[1]);
    }

    for (auto &pipe_item: cal2out_pipes)
        close(pipe_item[1]);

    {
        pid_t pid = fork();
        if (pid == 0) {
            vector<string> fd_args;

            fd_args.push_back(to_string(cal_nodes_num));
            for (auto &pipe_item: cal2out_pipes)
                fd_args.push_back(to_string(pipe_item[0]));

            vector<char*> output_argv;
            output_argv.push_back((char*)"./output");
            for (auto &s:fd_args)
                output_argv.push_back((char*)s.c_str());
            output_argv.push_back(nullptr);

            execvp("./output", output_argv.data());
            perror("output node faild"); exit(1);
        }
    }

    for (auto &pipe_item: cal2out_pipes)
        close(pipe_item[0]);

    while (wait(nullptr) > 0);

    return 0;
}