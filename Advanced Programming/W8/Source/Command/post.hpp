#ifndef POST
#define POST

#include <vector>
#include <string>
#include "../user.hpp"
#include "../properties.hpp"
#include "command.hpp"

class Post : public Command
{
public:
    Post(std::vector<std::string> &command, UserList &users, Status &state, User *&currentUser, Playlist &songs);

private:
    void signUp(UserList &users, std::vector<std::string> &command, Status &state, User *&currentUser);
    void login(UserList &users, std::vector<std::string> &command, Status &state, User *&currentUser);
    void logout(std::vector<std::string> &command, Status &state, User *&currentUser);
    void createPlaylist(User *&currentUser, std::vector<std::string> &command);
    void createSong(User *&currentUser, std::vector<std::string> &command, Playlist &songs);
    void changeFollow(std::vector<std::string> &command, User *&currentUser, UserList &users);
    void like(std::vector<std::string> &command, User *&currentUser, Playlist &songs);
};

#endif