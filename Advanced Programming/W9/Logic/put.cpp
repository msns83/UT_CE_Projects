#include <vector>
#include <string>
#include "put.hpp"
using namespace std;

Put ::Put(vector<string> &command, User *&currentUser, Status &state, Playlist &songs)
{
    if (command[1] == COMMANDS[9])
    {
        if (state == NORMAL)
            addSongToPlaylist(currentUser, command, songs);
        else
            response.push_back(RESPONSES[4]);
    }
    else
        response.push_back(RESPONSES[2]);
}

void Put ::addSongToPlaylist(User *&currentUser, vector<string> &command, Playlist &songs)
{
    try
    {
        vector<string> props = extractProps({"name", "id"}, {}, command);
        ((Normal *)currentUser)->addSongToPlaylist(props[0], songs.findSongById(props[1]));
        response.push_back(RESPONSES[0]);
    }
    catch (const string &result)
    {
        response.push_back(result);
    }
}