#ifndef GET
#define GET

#include <vector>
#include <string>
#include "../playlist.hpp"
#include "../properties.hpp"
#include "../user.hpp"
#include "command.hpp"

class Get : public Command
{
public:
    Get(std::vector<std::string> &command, Playlist &songs, Status &state, UserList &users, User *&currentUser);

private:
    void generateRecomends(std::vector<std::string> &command, Playlist &songs, User *&currentUser);
    void getSongInfo(std::vector<std::string> &command, Playlist &songs);
    void showPlaylists(UserList &users, std::vector<std::string> &command);
    void searchSong(std::vector<std::string> &command, Playlist &songs);
    void registerSong(std::vector<std::string> &command, User *&currentUser);
    void getUserInfo(std::vector<std::string> &command, UserList &users);
    void showLiked(std::vector<std::string> &command, User *&currentUser);
};

#endif