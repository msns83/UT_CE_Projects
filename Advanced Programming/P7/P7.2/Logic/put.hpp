#ifndef PUT
#define PUT

#include <vector>
#include <string>
#include "./user.hpp"
#include "command.hpp"

class Put : public Command
{
public:
    Put(std::vector<std::string> &command, User *&currentUser, Status &state, Playlist &songs);

private:
    void addSongToPlaylist(User *&currentUser, std::vector<std::string> &command, Playlist &songs);
};

#endif