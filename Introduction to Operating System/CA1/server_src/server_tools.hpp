#ifndef SERVER_TOOLS
#define SERVER_TOOLS

#include <vector>
#include <sys/select.h>
#include "contest.hpp"
#include <string>
#include <netinet/in.h>
#include "../data_types.hpp"

int create_server(int port);
bool check_server(int server_fd, fd_set &read_fds, std::vector<int> &client_sockets);
void check_clients(fd_set &read_fds, std::vector<int> &client_sockets, Contest *contest, int current_time);
bool process_req(int client_fd, Contest *contest, int current_time);
int check_args(int argc, char* argv[]);
void notify_special(std::string type, std::string status, int fd);
int create_broadcast_socket(sockaddr_in &broadcastAddr);
void broadcast_message(int udpSock, sockaddr_in &broadcastAddr, Notification notif);
bool submit_code(const std::string &problem_id, const std::string &code);

#endif