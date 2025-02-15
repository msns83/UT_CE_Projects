#include <vector>
#include <string>
#include <iostream>
#include "post.hpp"
#include "./user.hpp"
#include "./properties.hpp"
using namespace std;

Post ::Post(vector<string> &command, UserList &users, Status &state, User *&currentUser, Playlist &songs)
{
    if (command[1] == COMMANDS[6])
    {
        if (state == OUT)
            signUp(users, command, state, currentUser);
        else
            response.push_back(RESPONSES[4]);
    }
    else if (command[1] == COMMANDS[7])
    {
        if (state == OUT)
            login(users, command, state, currentUser);
        else
            response.push_back(RESPONSES[4]);
    }
    else if (command[1] == COMMANDS[8])
    {
        if (state != OUT)
            logout(command, state, currentUser);
        else
            response.push_back(RESPONSES[4]);
    }
    else if (command[1] == COMMANDS[3])
    {
        if (state == NORMAL)
            createPlaylist(currentUser, command);
        else
            response.push_back(RESPONSES[4]);
    }
    else if (command[1] == COMMANDS[0])
    {
        if (state == ARTIST)
            createSong(currentUser, command, songs);
        else
            response.push_back(RESPONSES[4]);
    }
    else if (command[1] == COMMANDS[10] || command[1] == COMMANDS[11])
    {
        if (state != OUT)
            changeFollow(command, currentUser, users);
        else
            response.push_back(RESPONSES[4]);
    }
    else if (command[1] == COMMANDS[12])
    {
        if (state == NORMAL)
            like(command, currentUser, songs);
        else
            response.push_back(RESPONSES[4]);
    }
    else
        response.push_back(RESPONSES[2]);
}

void Post::like(vector<string> &command, User *&currentUser, Playlist &songs)
{
    try
    {
        vector props = extractProps({"id"}, {}, command);
        ((Normal *)currentUser)->like(songs.findSongById(props[0]));
        response.push_back(RESPONSES[0]);
    }
    catch (const string &result)
    {
        response.push_back(result);
    }
}

void Post::changeFollow(std::vector<std::string> &command, User *&currentUser, UserList &users)
{
    try
    {
        vector props = extractProps({"id"}, {}, command);

        if (command[1] == COMMANDS[10])
            currentUser->follow(users.searchForUser(props[0]));
        else
            currentUser->unfollow(users.searchForUser(props[0]));

        response.push_back(RESPONSES[0]);
    }
    catch (const string &result)
    {
        response.push_back(result);
    }
}

void Post::createSong(User *&currentUser, vector<string> &command, Playlist &songs)
{
    try
    {
        vector props = extractProps({"title", "format", "year", "album", "tags", "duration"}, {}, command);
        ((Artist *)currentUser)->addSong(songs.createSong(props, currentUser->getUsername()));
        response.push_back(RESPONSES[0]);
    }
    catch (const string &result)
    {
        response.push_back(result);
    }
}

void Post ::createPlaylist(User *&currentUser, vector<string> &command)
{
    try
    {
        vector props = extractProps({"name"}, {}, command);
        ((Normal *)currentUser)->addPlaylist(props[0]);
        response.push_back(RESPONSES[0]);
    }
    catch (const string &result)
    {
        response.push_back(result);
    }
}

void Post ::logout(vector<string> &command, Status &state, User *&currentUser)
{
    try
    {
        extractProps({}, {}, command);
        state = OUT;
        currentUser = NULL;
        response.push_back(RESPONSES[0]);
    }
    catch (const string &result)
    {
        response.push_back(result);
    }
}

void Post::login(UserList &users, vector<string> &command, Status &state, User *&currentUser)
{
    try
    {
        vector<string> props = extractProps({"username", "password"}, {}, command);
        currentUser = users.checkLogin(props);
        state = currentUser->getMode();
        response.push_back(RESPONSES[0]);
    }
    catch (const string &result)
    {
        response.push_back(result);
    }
}

void Post ::signUp(UserList &users, vector<string> &command, Status &state, User *&currentUser)
{
    try
    {
        vector<string> props = extractProps({"username", "password", "mode"}, {}, command);
        currentUser = users.createUser(props);
        state = currentUser->getMode();
        response.push_back(RESPONSES[0]);
    }
    catch (const string &result)
    {
        response.push_back(result);
    }
}