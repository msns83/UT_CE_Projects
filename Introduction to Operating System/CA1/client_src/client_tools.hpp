#ifndef CLIENT_TOOLS
#define CLIENT_TOOLS

#include <string>

int check_args(int argc, std::string port_str, std::string role_str);
int create_server_socket(int port);

#endif