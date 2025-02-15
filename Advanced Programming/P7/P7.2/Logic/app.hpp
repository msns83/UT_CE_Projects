#ifndef APP
#define APP

#include <string>
#include <vector>

#include "playlist.hpp"
#include "properties.hpp"
#include "user.hpp"

class App {
public:
    App() : songs("all songs"){};
    std::string getId();
    std::string getStatus();
    std::string getUsername();
    void process(std::vector<std::string> command);
    std::vector<std::string> getResult() { return response; }
    void setResult(std::string result) { response = {result} ; }

private:
    Status state = OUT;
    UserList users;
    Playlist songs;
    User* currentUser;
    std::vector<std::string> response = {"OK"};
};

#endif