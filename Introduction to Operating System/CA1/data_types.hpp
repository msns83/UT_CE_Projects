#ifndef DATA_TYPES
#define DATA_TYPES

struct Submission {
    char team_name[50];
    char problem_id[20];
    char code[2000];
};

struct Message {
    char body[4096];
};

struct Request {
    char command[32];
    int group_id;
    int role; // 1:coder, 2:navigator
    char username[64];
};

struct Response {
    char answer[1024];
    int status;
};

struct Notification{
    int type ; // 1: question , 2:score table
    char text[4096];
};





#endif