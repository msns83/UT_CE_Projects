#ifndef PROPERTIES
#define PROPERTIES

#include <vector>
#include <string>

const std::vector<std::string> RESPONSES = {"OK", "Empty", "Not Found", "Bad Request", "Permission Denied"};
const std::vector<std::string> COMMAND_TYPE = {"POST", "GET", "PUT", "DELETE"};
const std::vector<std::string> COMMANDS = {"music", "musics", "users", "playlist", "search_music",
                                           "registered_musics", "signup", "login", "logout",
                                           "add_playlist", "follow", "unfollow", "like", "recommendations",
                                           "likes"};

enum Status
{
    NORMAL,
    ARTIST,
    OUT
};

enum TypeOfList
{
    SHORT_FORMAT,
    LONG_FORMAT,
    WITH_LIKES,
};

#endif