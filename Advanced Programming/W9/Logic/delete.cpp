#include <vector>
#include <string>
#include "delete.hpp"
using namespace std;

Delete ::Delete(vector<string> &command, UserList &users, Status &state, User *&currentUser, Playlist &songs)
{
    if (command[1] == COMMANDS[0])
    {
        if (state == ARTIST)
            deleteSong(command, users, currentUser, songs);
        else
            response.push_back(RESPONSES[4]);
    }
    else if (command[1] == COMMANDS[3])
    {
        if (state == NORMAL)
            deletePlaylist(command, currentUser);
        else
            response.push_back(RESPONSES[4]);
    }
    else
        response.push_back(RESPONSES[2]);
}

void Delete::deletePlaylist(std::vector<std::string> &command, User *&currentUser)
{
    try
    {
        vector props = extractProps({"name"}, {}, command);
        ((Normal*)currentUser)->deletePlaylist(props[0]);
        response.push_back(RESPONSES[0]);
    }
    catch (const string &result)
    {
        response.push_back(result);
    }
}

void Delete ::deleteSong(std::vector<std::string> &command, UserList &users, User *&currentUser, Playlist &songs)
{
    try
    {
        vector props = extractProps({"id"}, {}, command);
        Song *founded = songs.findSongById(props[0]);
        ((Artist *)currentUser)->deleteSong(founded);
        users.deleteSongGlobaly(founded);
        songs.deleteSong(founded);
        delete founded;
        response.push_back(RESPONSES[0]);
    }
    catch (const string &result)
    {
        response.push_back(result);
    }
}