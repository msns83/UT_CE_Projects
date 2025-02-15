#include <vector>
#include <string>
#include <iostream>
#include "get.hpp"
#include "../properties.hpp"
using namespace std;

Get ::Get(vector<string> &command, Playlist &songs, Status &state, UserList &users, User *&currentUser)
{
    if (command[1] == COMMANDS[1])
    {
        if (state != OUT)
            getSongInfo(command, songs);
        else
            response.push_back(RESPONSES[4]);
    }
    else if (command[1] == COMMANDS[2])
    {
        if (state != OUT)
            getUserInfo(command, users);
        else
            response.push_back(RESPONSES[4]);
    }
    else if (command[1] == COMMANDS[3])
    {
        if (state == NORMAL)
            showPlaylists(users, command);
        else
            response.push_back(RESPONSES[4]);
    }
    else if (command[1] == COMMANDS[4])
    {
        if (state == NORMAL)
            searchSong(command, songs);
        else
            response.push_back(RESPONSES[4]);
    }
    else if (command[1] == COMMANDS[5])
    {
        if (state == ARTIST)
            registerSong(command, currentUser);
        else
            response.push_back(RESPONSES[4]);
    }
    else if (command[1] == COMMANDS[13])
    {
        if (state == NORMAL)
            generateRecomends(command, songs, currentUser);
        else
            response.push_back(RESPONSES[4]);
    }
    else if (command[1] == COMMANDS[14])
    {
        if (state == NORMAL)
            showLiked(command, currentUser);
        else
            response.push_back(RESPONSES[4]);
    }
    else
        response.push_back(RESPONSES[2]);
}

void Get::generateRecomends(std::vector<std::string> &command, Playlist &songs, User *&currentUser)
{
    try
    {
        vector<string> props = extractProps({}, {}, command);
        Playlist popularList = songs.getmostLiked(5, ((Normal *)currentUser)->getliked());
        response = popularList.getSongsList(WITH_LIKES);
    }
    catch (const string &e)
    {
        response.push_back(e);
    }
}

void Get:: showLiked(std::vector<std::string> &command, User *&currentUser){
    try
    {
        vector<string> props = extractProps({}, {}, command);
        response = ((Normal*)currentUser)->getliked().getSongsList(SHORT_FORMAT);
    }
    catch (const string &e)
    {
        response.push_back(e);
    }
}

void Get ::registerSong(std::vector<std::string> &command, User *&currentUser)
{
    try
    {
        vector<string> props = extractProps({}, {}, command);
        response = ((Artist *)currentUser)->getSongs();
    }
    catch (const string &e)
    {
        response.push_back(e);
    }
}

void Get::searchSong(std::vector<std::string> &command, Playlist &songs)
{
    try
    {
        vector<string> props = extractProps({}, {"name", "artist", "tag"}, command);
        response = songs.searchSong(props).getSongsList(SHORT_FORMAT);
    }
    catch (const string &e)
    {
        response.push_back(e);
    }
}

void Get::showPlaylists(UserList &users, std::vector<std::string> &command)
{
    try
    {
        vector<string> props = extractProps({"id"}, {"name"}, command);

        Normal *founded = dynamic_cast<Normal *>(users.searchForUser(props[0]));
        if (founded == NULL)
            throw RESPONSES[3];

        if (props[1] == "")
            response = founded->showPlaylists();
        else
            response = founded->showPlaylist(props[1]);
    }
    catch (const string &e)
    {
        response.push_back(e);
    }
}

void Get::getSongInfo(vector<string> &command, Playlist &songs)
{
    try
    {
        vector<string> props = extractProps({}, {"id"}, command);

        if (props[0] == "")
            response = songs.getSongsList(SHORT_FORMAT);
        else
        {
            Song *founded = songs.findSongById(props[0]);
            response.push_back("ID, Name, Artist, Year, Album, Tags, Duration");
            response.push_back(founded->getDetailsLong());
        }
    }
    catch (const string &error)
    {
        response.push_back(error);
    }
}

void Get::getUserInfo(vector<string> &command, UserList &users)
{
    try
    {
        vector<string> props = extractProps({}, {"id"}, command);

        if (props[0] == "")
            response = users.createUsersListFormat();
        else
        {
            User *founded = users.searchForUser(props[0]);
            response.push_back(founded->getDetailsLong());
        }
    }
    catch (const string &error)
    {
        response.push_back(error);
    }
}