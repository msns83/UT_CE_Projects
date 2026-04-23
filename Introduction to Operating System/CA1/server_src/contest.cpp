#include "contest.hpp"
#include <string>
#include <algorithm>
#include "../data_types.hpp"
#include "server_tools.hpp"

using namespace std;

User:: User(string _username, int _role, int _fd){
    username = _username;
    role = _role;
    fd = _fd;
}

Group:: Group(User* first, User* second, int _group_id){
    if (first->role == 1) {
        coder = first;
        navigator = second;
    } else {
        coder = second;
        navigator = first;
    }
    
    group_id = _group_id;
}

Contest:: Contest() {
    questions.push_back("def add_numbers(a, b):\n");
    question_ids.push_back("add_numbers");
    scores.push_back(1);

    questions.push_back("def reverse_string(s):\n");
    question_ids.push_back("reverse_string");
    scores.push_back(3);

    questions.push_back("def is_palindrome(s):\n");
    question_ids.push_back("is_palindrome");
    scores.push_back(5);

    total_questions = questions.size();
}

int Contest::initialize_user(const string username, int role, int fd) {

    if (find(usernames.begin(), usernames.end(), username) != usernames.end())
        return -1;

    usernames.push_back(username);
    User *user = new User(username, role, fd);
    User *team_mate ;

    if (role == 1) {
        if (!unmatched_navigators.empty()){
            team_mate = unmatched_navigators.front();
            unmatched_navigators.pop();
            notify_special("matched", to_string(current_group_id), team_mate->fd);
        } else {
            unmatched_coders.push(user);
            return -2;
        }
    } else if (role == 2) {
        if (!unmatched_coders.empty()){
            team_mate = unmatched_coders.front();
            unmatched_coders.pop();
            notify_special("matched", to_string(current_group_id), team_mate->fd);
        } else {
            unmatched_navigators.push(user);
            return -2;
        }
    }
    
    groups.push_back(new Group(user, team_mate, current_group_id));


    return current_group_id++;
    
}

int Contest::get_teammate_fd(int group_id, int role) {
    if (role == 1) {
        return groups[group_id]->navigator->fd;
    } else {
        return groups[group_id]->coder->fd;
    }
}

string Contest::get_question() {
    return questions[current_question];
}

void Contest::give_score(int group_id, float score) {
    groups[group_id]->score += score;
}

string Contest::generate_scoreboard() {
    string scoreboard = "Scoreboard\n";
    for (int i = 0; i < groups.size(); i++)
        scoreboard += "Team " + to_string(i) + " : " + to_string(groups[i]->score) + "\n";
    return scoreboard;
}
