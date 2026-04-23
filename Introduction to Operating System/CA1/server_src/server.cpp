#include <unistd.h>
#include "server_tools.hpp"
#include "contest.hpp"
#include <sys/timerfd.h>  
#include <cstring>        
#include <sys/select.h>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <vector>
#include <algorithm>
#include <iostream>
#include <sys/socket.h>
#include "../data_types.hpp"
#include <netinet/in.h>

using namespace std;

int main(int argc, char* argv[]) {

    int port = check_args(argc, argv);
    if (port == -1)
        return 1;
    
    int server_fd = create_server(port);
    if (server_fd == -1)
        return 1;

    Contest *contest = new Contest();
    
    vector<int> client_fds;
    fd_set read_fds;

    sockaddr_in broadcastAddr;
    int udpSock = create_broadcast_socket(broadcastAddr);
    if (udpSock == -1) {
        close(server_fd);
        return 1;
    }

    int timer_fd = timerfd_create(CLOCK_MONOTONIC, TFD_NONBLOCK);
    if (timer_fd == -1) {
        write(STDERR_FILENO, "timer-create failed\n", 21);
        return 1;
    }
    
    bool isTimerActive = false;

    while (true) {
        FD_ZERO(&read_fds);
        FD_SET(server_fd, &read_fds);
        FD_SET(STDIN_FILENO, &read_fds);

        if (isTimerActive)
            FD_SET(timer_fd, &read_fds);

        int max_fd = max(server_fd, STDIN_FILENO);
        if (isTimerActive)
            max_fd = max(max_fd, timer_fd);
        
        for (int client_fd : client_fds) {
            FD_SET(client_fd, &read_fds);
            if (client_fd > max_fd)
                max_fd = client_fd;
        }
        
        int activity = select(max_fd + 1, &read_fds, NULL, NULL, NULL);
        if (activity < 0) {
            write(STDERR_FILENO, "select failed\n", 14);
            break;
        }

        
        if (FD_ISSET(STDIN_FILENO, &read_fds)) {
            char buffer[256];
            memset(buffer, 0, sizeof(buffer));
            read(STDIN_FILENO, buffer, sizeof(buffer) - 1);

            if (strncmp(buffer, "start", 5) == 0) {

                if (!isTimerActive) {
                    
                    struct itimerspec timer_spec;
                    memset(&timer_spec, 0, sizeof(timer_spec));
                    timer_spec.it_value.tv_sec = 60;

                    if (timerfd_settime(timer_fd, 0, &timer_spec, NULL) == -1) {
                        write(STDERR_FILENO, "Failed to set timer.\n", 22);
                        return 1;
                    } else {
                        isTimerActive = true;
                        string log = "Question " + to_string(contest->current_question + 1) + " is running...\n" ;
                        write(STDOUT_FILENO, log.c_str(), log.size());

                        Notification notif{} ;
                        strcpy(notif.text, contest->get_question().c_str());
                        notif.type = 1;
                        broadcast_message(udpSock, broadcastAddr, notif);
                    }

                } else {
                    write(STDOUT_FILENO, "Timer already running.\n", 24);
                }
            } else if(strncmp(buffer, "exit", 4) == 0){
                break;
            }
        }

        
        if (isTimerActive && FD_ISSET(timer_fd, &read_fds)) {
            uint64_t expirations;
            if (read(timer_fd, &expirations, sizeof(expirations)) != sizeof(expirations)) {
                write(STDERR_FILENO, "Failed to read timerfd.\n", 24);
            } else {

                write(STDOUT_FILENO, "Time up\n", 8);
                Notification notif{} ;
                string socreboard = contest->generate_scoreboard();
                strcpy(notif.text, socreboard.c_str());
                notif.type = 2;
                broadcast_message(udpSock, broadcastAddr, notif);

                contest->current_question++;

                if (contest->current_question < contest->total_questions) {
                    
                    Notification notif{} ;
                    strcpy(notif.text, contest->get_question().c_str());
                    notif.type = 1;
                    broadcast_message(udpSock, broadcastAddr, notif);

                    struct itimerspec timer_spec;
                    memset(&timer_spec, 0, sizeof(timer_spec));
                    timer_spec.it_value.tv_sec = 60;
                    if (timerfd_settime(timer_fd, 0, &timer_spec, NULL) == -1) {
                        write(STDERR_FILENO, "Failed to reset timer.\n", 24);
                    }

                    string log = "Question " + to_string(contest->current_question + 1) + " is running...\n" ;
                    write(STDOUT_FILENO, log.c_str(), log.size());

                } else {
                    isTimerActive = false;
                    contest->current_question = 0;
                    write(STDOUT_FILENO, "Contest is over !\n", 19);
                }
            }
        }

        

        if (!check_server(server_fd, read_fds, client_fds))
            continue;

        int time_val = 0;
        if (isTimerActive) {
            struct itimerspec curr_spec;
            if (timerfd_gettime(timer_fd, &curr_spec) == 0) {
                time_val = curr_spec.it_value.tv_sec;
            }
        }

        check_clients(read_fds, client_fds, contest, time_val);
    }

    close(timer_fd);
    close(server_fd);
    return 0;
}