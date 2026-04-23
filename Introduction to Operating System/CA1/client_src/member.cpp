#include <string>
#include <vector>
#include <cstring>
#include "member.hpp"
#include "../data_types.hpp"
using namespace std;

Member:: Member(const string& _username, const string& _role) {
    if (_role == "Coder") {
        this->role = 1;
    } else if (_role == "Navigator"){
        this->role = 2;
    }
    
    this->username= _username;
}

Request Member:: generate_request(const string command) {
    Request req{};
    strcpy(req.command, command.c_str());
    req.group_id = group_id;
    req.role = role;
    strcpy(req.username, username.c_str());
    return req;
}

void Member:: set_group_id(int id) {
    group_id = id;
}

char* Member:: add_code(const char* code) {
    strcat(current_code, code);
    return current_code;
}

char* Member:: set_code(const char* code) {
    strcpy(current_code, code);
    return current_code;
}
