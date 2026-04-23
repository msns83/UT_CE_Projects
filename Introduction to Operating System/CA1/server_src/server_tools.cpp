#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>
#include <cstring>
#include <sys/select.h>
#include <vector>
#include <algorithm>
#include <arpa/inet.h>
#include "server_tools.hpp"
#include "../data_types.hpp"
#include "contest.hpp"
using namespace std;

#define MAX_CLIENTS 30
#define BUFFER_SIZE 1024

int check_args(int argc, char* argv[]) {
    if (argc < 2) {
        const char* usage_msg = "Usage: ./server <port>\n";
        write(STDERR_FILENO, usage_msg, strlen(usage_msg));
        return -1;
    }

    int port = atoi(argv[1]);
    if (port <= 0 || port > 65535) {
        const char* error_msg = "Invalid port number. Please provide a port between 1 and 65535.\n";
        write(STDERR_FILENO, error_msg, strlen(error_msg));
        return -1;
    }

    return port;
}

int create_server(int port) {
    int server_fd = socket(AF_INET, SOCK_STREAM, 0);
    if (server_fd == -1) {
        const char* error_msg = "Socket creation failed\n";
        write(STDERR_FILENO, error_msg, strlen(error_msg));
        return -1;
    }

    sockaddr_in server_addr{};
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = INADDR_ANY;
    server_addr.sin_port = htons(port);

    if (bind(server_fd, (sockaddr*)&server_addr, sizeof(server_addr)) == -1) {
        const char* error_msg = "Bind failed\n";
        write(STDERR_FILENO, error_msg, strlen(error_msg));
        close(server_fd);
        return -1;
    }

    if (listen(server_fd, 20) == -1) {
        const char* error_msg = "Listen failed\n";
        write(STDERR_FILENO, error_msg, strlen(error_msg));
        close(server_fd);
        return -1;
    }

    char listening_msg[60];
    sprintf(listening_msg, "Server is listening on port %d...\n", port);
    write(STDOUT_FILENO, listening_msg, strlen(listening_msg));

    return server_fd;
}

int create_broadcast_socket(sockaddr_in &broadcastAddr) {
    int udpSock = socket(AF_INET, SOCK_DGRAM, 0);
    if (udpSock < 0) {
        const char* error_msg = "Socket creation failed\n";
        write(STDERR_FILENO, error_msg, strlen(error_msg));
        return -1;
    }

    int opt = 1;
    if (setsockopt(udpSock, SOL_SOCKET, SO_BROADCAST, &opt, sizeof(opt)) < 0) {
        const char* error_msg = "setsockopt (SO_BROADCAST) failed\n";
        write(STDERR_FILENO, error_msg, strlen(error_msg));
        close(udpSock);
        return -1;
    }

    memset(&broadcastAddr, 0, sizeof(broadcastAddr));
    broadcastAddr.sin_family = AF_INET;
    broadcastAddr.sin_port = htons(9010);
    broadcastAddr.sin_addr.s_addr = inet_addr("255.255.255.255");

    return udpSock;
}

bool check_server(int server_fd, fd_set &read_fds, vector<int> &client_fds) {
    if (FD_ISSET(server_fd, &read_fds)) {
        sockaddr_in client_addr{};
        socklen_t client_len = sizeof(client_addr);
        int new_client_fd = accept(server_fd, (sockaddr*)&client_addr, &client_len);

        if (new_client_fd < 0) {
            const char* error_msg = "Accept failed\n";
            write(STDERR_FILENO, error_msg, strlen(error_msg));
            return false;
        }

        if (client_fds.size() < MAX_CLIENTS) {
            client_fds.push_back(new_client_fd);
            const char* new_client_msg = "New client connected\n";
            write(STDOUT_FILENO, new_client_msg, strlen(new_client_msg));
        } else {
            const char* full_msg = "Too many clients connected\n";
            write(STDERR_FILENO, full_msg, strlen(full_msg));
            close(new_client_fd);
        }
    }

    return true;
}


void check_clients(fd_set &read_fds, vector<int> &client_fds, Contest *contest, int current_time) {
    for (auto it = client_fds.begin(); it != client_fds.end();) {
        int client_fd = *it;

        if (FD_ISSET(client_fd, &read_fds)) {
            if (!process_req(client_fd, contest, current_time)) {
                it = client_fds.erase(it);
                continue;
            }
        }
        ++it;
    }
}

bool process_req(int client_fd, Contest *contest, int current_time) {
    Request req{};
    Response res{};
    int bytes_read = read(client_fd, &req, sizeof(Request));

    if (bytes_read <= 0) {
        const char* disconnect_msg = "Client disconnected\n";
        write(STDOUT_FILENO, disconnect_msg, strlen(disconnect_msg));
        close(client_fd);
        return false;
    }

    if (strcmp(req.command, "join") == 0) {
        int status = contest->initialize_user(req.username, req.role, client_fd);
        res.status = status;
        if (status == -1) {
            strcpy(res.answer, "Username already taken");
            write(client_fd, &res, sizeof(Response));
            close(client_fd);
            return false;
        } else if (status == -2) {
            strcpy(res.answer, "Currently there is no team-mate for you, Please wait...");
        } else {
            char answer[1024];
            sprintf(answer, "you matched with another user, Team %d", res.status); 
            strcpy(res.answer, answer);
        }
        write(client_fd, &res, sizeof(Response));
    } else if (strcmp(req.command, "chat") == 0) {
        int forward_fd = contest->get_teammate_fd(req.group_id, req.role);
        Message msg{};
        read(client_fd, &msg, sizeof(Message));

        Response res{};
        strcpy(res.answer, "chat");
        write(forward_fd, &res, sizeof(Response));
        write(forward_fd, &msg, sizeof(Message));
        
    } else if(strcmp(req.command, "share") == 0){
        int forward_fd = contest->get_teammate_fd(req.group_id, req.role);
        Message code{};
        read(client_fd, &code, sizeof(Message));

        Response res{};
        strcpy(res.answer, "share");
        write(forward_fd, &res, sizeof(Response));
        write(forward_fd, &code, sizeof(Message));
    } else if(strcmp(req.command, "submit") == 0){
        Message code{};
        read(client_fd, &code, sizeof(Message));
        if (submit_code(contest->question_ids[contest->current_question], code.body)){
            float score = contest->scores[contest->current_question];
            
            if (30 <= current_time) {
                score += score*0.5;
            } else if (15 <= current_time && current_time < 30) {
                score += score*0.2;
            }
            
            contest->give_score(req.group_id, score);
        }

    }

    return true;
}

bool submit_code(const string &problem_id, const string &code) {
    int evalSock = socket(AF_INET, SOCK_STREAM, 0);
    if (evalSock < 0) {
        const char* error_msg = "eval socket creation failed\n";
        write(STDERR_FILENO, error_msg, strlen(error_msg));
        return false;
    }
    
    sockaddr_in evalAddr{};
    evalAddr.sin_family = AF_INET;
    evalAddr.sin_port = htons(65432);
    if (inet_pton(AF_INET, "127.0.0.1", &evalAddr.sin_addr) <= 0) {
        const char* error_msg = "inet_pton failed\n";
        write(STDERR_FILENO, error_msg, strlen(error_msg));
        close(evalSock);
        return false;
    }
    
    if (connect(evalSock, (sockaddr*)&evalAddr, sizeof(evalAddr)) < 0) {
        const char* error_msg = "connect failed\n";
        write(STDERR_FILENO, error_msg, strlen(error_msg));
        close(evalSock);
        return false;
    }
    
    string message = problem_id + "\n" + code;
    if (send(evalSock, message.c_str(), message.size(), 0) == -1) {
        const char* error_msg = "send failed\n";
        write(STDERR_FILENO, error_msg, strlen(error_msg));
        close(evalSock);
        return false;
    }
    
    char buffer[1024];
    memset(buffer, 0, sizeof(buffer));
    int bytes = recv(evalSock, buffer, sizeof(buffer) - 1, 0);
    if (bytes > 0) {
        if (strncmp(buffer, "PASS", 4) == 0)
            return true;
        
        close(evalSock);
        return false;
    } else {
        const char* error_msg = "recv failed\n";
        write(STDERR_FILENO, error_msg, strlen(error_msg));
    }
    
    close(evalSock);
    return false;
}

void notify_special(string type, string status, int fd){
    Response res{};

    if (type == "matched")
    {
        res.status = stoi(status) ;
        char answer[1024];
        sprintf(answer, "you matched with another user, Team %d", res.status); 
        strcpy(res.answer, answer);
    }
    

    write(fd, &res, sizeof(Response));
}

void broadcast_message(int udpSock, sockaddr_in &broadcastAddr, Notification notif) {

    int sent_bytes = sendto(udpSock, &notif, sizeof(Notification), 0, (sockaddr *)&broadcastAddr, sizeof(broadcastAddr));
    if (sent_bytes != sizeof(Notification)) {
        const char* error_msg = "Failed to send broadcast message\n";
        write(STDERR_FILENO, error_msg, strlen(error_msg));
    } else {
        write(STDOUT_FILENO, "Broadcast message sent.\n", 24);
    }

}
