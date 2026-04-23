#ifndef CONTEST
#define CONTEST

#include <string>
#include <vector>
#include <queue>

class User {
private:
    
public:
    std::string username;
    int role;
    int fd;

    User(std::string _username, int _role, int _fd);

};

class Group {
private:
    

public:
    int group_id;
    User* coder;
    User* navigator;
    float score = 0;
    Group(User* first, User* second, int _group_id);
};



class Contest {
private:
    std::vector<Group*> groups;
    std::vector<std::string> usernames;
    std::queue<User*> unmatched_coders;
    std::queue<User*> unmatched_navigators;
    int current_group_id = 0;

    std::vector<std::string> questions;
    
    public:
    
    std::vector<float> scores;
    std::vector<std::string> question_ids;
    int current_question = 0;
    int total_questions = 0;

    Contest();
    int initialize_user(const std::string username, int role, int fd);
    int get_teammate_fd(int group_id, int role);
    std::string get_question();
    void give_score(int group_id, float score);
    std::string generate_scoreboard();
};;



#endif