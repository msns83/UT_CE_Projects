#ifndef DELETE
#define DELETE

#include <vector>
#include <string>
#include "../user.hpp"
#include "../playlist.hpp"
#include "command.hpp"

class Delete : public Command
{
public:
    Delete(std::vector<std::string> &command, UserList &users, Status &state, User *&currentUser, Playlist &songs);

private:
    void deleteSong(std::vector<std::string> &command, UserList &users, User *&currentUser, Playlist &songs);
    void deletePlaylist(std::vector<std::string> &command, User *&currentUser);
};

#endif