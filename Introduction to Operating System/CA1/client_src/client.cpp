#include <unistd.h>
#include <cstring>
#include <iostream>
#include <sys/select.h>
#include <algorithm> 
#include <sys/socket.h>
#include <netinet/in.h>
#include "client_tools.hpp"
#include "../data_types.hpp"

#include "member.hpp"
using namespace std;

int create_broadcast_listener() {
    int udpSock = socket(AF_INET, SOCK_DGRAM, 0);
    if (udpSock < 0) {
        write(STDERR_FILENO, "socket creation failed\n", 23);
        return -1;
    }

    int reuse = 1;
    if (setsockopt(udpSock, SOL_SOCKET, SO_REUSEADDR, &reuse, sizeof(reuse)) < 0) {
        write(STDERR_FILENO, "setsockopt SO_REUSEADDR failed\n", 31);
        close(udpSock);
        return -1;
    }

    sockaddr_in clientAddr{};
    memset(&clientAddr, 0, sizeof(clientAddr));
    clientAddr.sin_family = AF_INET;
    clientAddr.sin_port = htons(9010);
    clientAddr.sin_addr.s_addr = INADDR_ANY;

    if (bind(udpSock, (sockaddr *)&clientAddr, sizeof(clientAddr)) < 0) {
        write(STDERR_FILENO, "bind broadcast failed\n", 22);
        close(udpSock);
        return -1;
    }

    return udpSock;
}

int main(int argc, char* argv[]) {
    int port = check_args(argc, argv[2], argv[3]);
    if (port == -1) return 1;

    int client_fd = create_server_socket(port);
    if (client_fd == -1) return 1;

    Member *member = new Member(argv[1], argv[3]);

    Request req = member->generate_request("join");
    Response res;

    write(client_fd, &req, sizeof(Request));
    write(STDOUT_FILENO, "Looking for a team-mate...\n", 27);

    read(client_fd, &res, sizeof(Response));

    write(STDOUT_FILENO, res.answer, strlen(res.answer));
    write(STDOUT_FILENO, "\n", 1);

    if (res.status == -1) {
        close(client_fd);
        delete member;
        return 1;
    } else if (res.status == -2) {
        read(client_fd, &res, sizeof(Response));
        write(STDOUT_FILENO, res.answer, strlen(res.answer));
        write(STDOUT_FILENO, "\n", 1);
    }

    member->set_group_id(res.status);

    int udpSock = create_broadcast_listener();
    if (udpSock == -1) {
        close(client_fd);
        delete member;
        return 1;
    }

    write(STDOUT_FILENO, "\nEnter Command: ", 15);

    fd_set readfds;
    while (true) {
        FD_ZERO(&readfds);
        FD_SET(STDIN_FILENO, &readfds);
        FD_SET(client_fd, &readfds);
        FD_SET(udpSock, &readfds);
        int max_fd = std::max({STDIN_FILENO, client_fd, udpSock}) + 1;

        int activity = select(max_fd, &readfds, nullptr, nullptr, nullptr);
        if (activity < 0) {
            write(STDERR_FILENO, "Select faild.\n", 14);
            break;
        }

        if (FD_ISSET(udpSock, &readfds)) {
            Notification notif{};
            int bytes_received = recvfrom(udpSock, &notif, sizeof(Notification), 0, nullptr, nullptr);

            if (bytes_received > 0) {

                if (notif.type == 1) {
                    member->set_code(notif.text);
                    write(STDOUT_FILENO, "\033[31m", 5); 
                    write(STDOUT_FILENO, "\n!! New Question !!\n", 20);
                    write(STDOUT_FILENO, notif.text, strlen(notif.text));
                    write(STDOUT_FILENO, "\033[0m", 4);

                    write(STDOUT_FILENO, "\nShared Code:\n", 15);
                    write(STDOUT_FILENO, "\033[32m", 5);
                    write(STDOUT_FILENO, notif.text, strlen(notif.text));
                    write(STDOUT_FILENO, "\033[0m", 4);
                    write(STDOUT_FILENO, "\n\nEnter rest of command: ", 24);
                } else if (notif.type == 2) {

                    write(STDOUT_FILENO, "\033[34m", 5); 
                    write(STDOUT_FILENO, "\n\n", 2);
                    write(STDOUT_FILENO, notif.text, strlen(notif.text));
                    write(STDOUT_FILENO, "\033[0m", 4);

                }
                
            }
        }

        if (FD_ISSET(client_fd, &readfds)) {
            Response res{};
            int bytes_read = read(client_fd, &res, sizeof(Response));
            if (bytes_read <= 0) {
                write(STDERR_FILENO, "Server disconnected\n", 21);
                break;
            }

            if (strcmp(res.answer, "chat") == 0) {
                Message msg{};
                read(client_fd, &msg, sizeof(Message));
                write(STDOUT_FILENO, "\n\nNew Message:\n", 15);
                write(STDOUT_FILENO, "\033[33m", 5); 
                write(STDOUT_FILENO, msg.body, strlen(msg.body));
                write(STDOUT_FILENO, "\033[0m", 4); 
                write(STDOUT_FILENO, "\nEnter rest of command: ", 24);
            } else if (strcmp(res.answer, "share") == 0){
                Message code{};
                read(client_fd, &code, sizeof(Message));
                member->set_code(code.body);
                write(STDOUT_FILENO, "\n\nShared Code:\n", 15);
                write(STDOUT_FILENO, "\033[32m", 5);
                write(STDOUT_FILENO, code.body, strlen(code.body));
                write(STDOUT_FILENO, "\033[0m", 4);
                write(STDOUT_FILENO, "\nEnter rest of command: ", 24);
            }
            
            
        }

        
        if (FD_ISSET(STDIN_FILENO, &readfds)) {
            char input_buffer[4096];
            memset(input_buffer, 0, sizeof(input_buffer));
            int bytes_input = read(STDIN_FILENO, input_buffer, sizeof(input_buffer) - 1);
            if (bytes_input <= 0) continue;

            if (strncmp(input_buffer, "\\exit", 5) == 0) {
                write(STDOUT_FILENO, "Exiting...\n", 11);
                break;
            } else if (strncmp(input_buffer, "\\chat", 5) == 0) {
                write(STDOUT_FILENO, "Enter your message: \n", 21);
                memset(input_buffer, 0, sizeof(input_buffer));
                ssize_t msg_bytes = read(STDIN_FILENO, input_buffer, sizeof(input_buffer) - 1);
                if (msg_bytes <= 0) continue;

                Request chatReq = member->generate_request("chat");
                write(client_fd, &chatReq, sizeof(Request));

                Message message{};
                strcpy(message.body, input_buffer);
                write(client_fd, &message, sizeof(Message));

                write(STDOUT_FILENO, "Message sent.\n", 14);
            } else if (strncmp(input_buffer, "\\code", 5)== 0) {
                write(STDOUT_FILENO, "Enter one line code: \n", 23);
                memset(input_buffer, 0, sizeof(input_buffer));
                int code_bytes = read(STDIN_FILENO, input_buffer, sizeof(input_buffer) - 1);
                if (code_bytes <= 0) continue;

                char *current_code = member->add_code(input_buffer);

                write(STDOUT_FILENO, "\nCurrent code:\n", 15);
                write(STDOUT_FILENO, "\033[32m", 5);
                write(STDOUT_FILENO, current_code, strlen(current_code));
                write(STDOUT_FILENO, "\033[0m", 4);
                
            }else if(strncmp(input_buffer, "\\share", 6) == 0){
                Request req{};
                Message code{};
                req = member->generate_request("share");
                strcpy(code.body, member->current_code);
                write(client_fd, &req, sizeof(Request));
                write(client_fd, &code, sizeof(Message));
                write(STDOUT_FILENO, "Code shared.\n", 13);

            } else if(strncmp(input_buffer, "\\submit", 7) == 0){
                Request req{};
                req = member->generate_request("submit");
                write(client_fd, &req, sizeof(Request));
                Message code{};
                strcpy(code.body, member->current_code);
                write(client_fd, &code, sizeof(Message));
                write(STDOUT_FILENO, "Code submitted.\n", 16);

            } else {
                write(STDOUT_FILENO, "Invalid command\n", 16);
            }


            write(STDOUT_FILENO, "\nEnter Command: ", 15);
        }



    }

    close(client_fd);
    delete member;
    return 0;
}