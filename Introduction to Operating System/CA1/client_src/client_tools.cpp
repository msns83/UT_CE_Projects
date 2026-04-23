#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <cstring>
#include <cstdio>
#include <cstdlib>
#include "client_tools.hpp"
#include <string>
using namespace std;

int check_args(int argc, string port_str, string role_str) {
    if (argc < 4) {
        const char* error_msg = "Usage: ./client <username> <port> <role>\n";
        write(STDERR_FILENO, error_msg, strlen(error_msg));
        return -1;
    }

    int port = atoi(port_str.c_str());
    if (port <= 0 || port > 65535) {
        const char* error_msg = "Invalid port number\n";
        write(STDERR_FILENO, error_msg, strlen(error_msg));
        return -1;
    }

    if (role_str != "Coder" && role_str != "Navigator") {
        const char* error_msg = "Invalid role\n";
        write(STDERR_FILENO, error_msg, strlen(error_msg));
        return -1;
    }
    

    return port;
}

int create_server_socket(int port){

    int client_fd = socket(AF_INET, SOCK_STREAM, 0);
    if (client_fd == -1) {
        const char* error_msg = "Socket creation failed\n";
        write(STDERR_FILENO, error_msg, strlen(error_msg));
        return 1;
    }

    sockaddr_in server_addr{};
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(port);

    if (inet_pton(AF_INET, "127.0.0.1", &server_addr.sin_addr) <= 0) {
        const char* error_msg = "Invalid address or address not supported\n";
        write(STDERR_FILENO, error_msg, strlen(error_msg));
        close(client_fd);
        return -1;
    }

    if (connect(client_fd, (sockaddr*)&server_addr, sizeof(server_addr)) == -1) {
        const char* error_msg = "Connection to the server failed\n";
        write(STDERR_FILENO, error_msg, strlen(error_msg));
        close(client_fd);
        return -1;
    }

    const char* success_msg = "Connected to the server\n";
    write(STDOUT_FILENO, success_msg, strlen(success_msg));

    return client_fd;
}