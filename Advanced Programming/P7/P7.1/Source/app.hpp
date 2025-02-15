#ifndef APP
#define APP

#include <vector>
#include <string>
#include "user.hpp"
#include "properties.hpp"
#include "playlist.hpp"

class App
{
public:
    App() : songs("all songs") {};
    std::vector<std::string> process(std::vector<std::string> command);

private:
    Status state = OUT;
    UserList users;
    Playlist songs;
    User *currentUser;
};

#endif