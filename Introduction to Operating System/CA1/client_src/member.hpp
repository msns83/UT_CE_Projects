#ifndef MEMBER
#define MEMBER

#include <string>
#include <vector>
#include "../data_types.hpp"

class Member {
    private:
        int role = -1; // 1:coder, 2:navigator
        std::string username;
        int group_id = -1;
        
    public:
        char current_code[8192] = "";

        Member(const std::string& _username, const std::string& _role);
        Request generate_request(const std::string command);
        void set_group_id(int id);
        char* add_code(const char* code);
        char* set_code(const char* code);
    };

#endif

