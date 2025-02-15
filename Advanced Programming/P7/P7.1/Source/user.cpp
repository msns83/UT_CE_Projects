#include <vector>
#include <string>
#include <iostream>
#include "user.hpp"
#include "properties.hpp"
using namespace std;

Artist::Artist(int _id, vector<string> props) : songs("songs")
{
    id = _id;
    username = props[0];
    password = props[1];
    mode = props[2];
}

void Artist::deleteSong(Song *song)
{
    try
    {
        songs.findSongById(to_string(song->getId()));
    }
    catch (const string &error)
    {
        if (error == RESPONSES[2])
            throw RESPONSES[4];
        else
            throw;
    }
    songs.deleteSong(song);
}

vector<string> Artist ::getSongs()
{
    return songs.getSongsList(LONG_FORMAT);
}

int searchInList(vector<User *> &list, User *wanted)
{
    for (int j = 0; j < list.size(); j++)
        if (list[j] == wanted)
            return j;

    return -1;
}

void User::follow(User *selectedUser)
{
    if (selectedUser == this || searchInList(followings, selectedUser) != -1)
        throw RESPONSES[3];

    followings.push_back(selectedUser);
    selectedUser->followers.push_back(this);
}

void User::unfollow(User *selectedUser)
{
    int index = searchInList(followings, selectedUser);
    if (index == -1)
        throw RESPONSES[3];

    followings[index]->removeFollower(this);
    followings.erase(followings.begin() + index, followings.begin() + index + 1);
}

void Normal::deletePlaylist(std::string playlistName)
{
    for (int i = 0; i < playlists.size(); i++)
        if (playlists[i].getName() == playlistName)
        {
            playlists.erase(playlists.begin() + i, playlists.begin() + i + 1);
            return;
        }

    throw RESPONSES[2];
}

void User::removeFollower(User *selectedUser)
{
    int index = searchInList(followers, selectedUser);
    followers.erase(followers.begin() + index, followers.begin() + index + 1);
}

void Normal ::deleteSongFromPlaylists(Song *song)
{
    for (auto &playlist : playlists)
        playlist.deleteSong(song);
}

string User::getUsername()
{
    return username;
}

string User ::getPassword()
{
    return password;
}

int User ::getId()
{
    return id;
}

string Normal::getDetailsShort()
{
    return (to_string(id) + ", " + mode + ", " + username + ", " + to_string(playlists.size()));
}

string Artist::getDetailsShort()
{
    return (to_string(id) + ", " + mode + ", " + username + ", " + to_string(songs.countSongs()));
}

string User::getDetailsLong()
{
    string followingsText = makeFollowList(followings, "Followings: ");
    string followersText = makeFollowList(followers, "Followers: ");

    return ("ID: " + to_string(id) + "\n" + "Mode: " + mode + "\n" + "Username: " + username + "\n" + followingsText + "\n" + followersText + "\n");
}

string Normal::getDetailsLong()
{
    string songsdetails;

    songsdetails = "Playlists: ";
    for (int i = 0; i < ((int)playlists.size()) - 1; i++)
        songsdetails += playlists[i].getName() + ", ";

    if (((int)playlists.size()) != 0)
        songsdetails += playlists[((int)playlists.size()) - 1].getName();

    return (User::getDetailsLong() + songsdetails);
}

string Artist::getDetailsLong()
{
    string songsdetails;
    songsdetails = "Songs: ";
    songsdetails += songs.getSongNames();

    return (User::getDetailsLong() + songsdetails);
}

string User::makeFollowList(vector<User *> &list, string initialText)
{
    for (int i = 0; i < ((int)list.size()) - 1; i++)
        initialText += list[i]->username + ", ";

    if (list.size() != 0)
        initialText += list[list.size() - 1]->username;

    return initialText;
}

Normal::Normal(int _id, vector<string> props) : liked("liked")
{
    id = _id;
    username = props[0];
    password = props[1];
    mode = props[2];
}

Status User ::getMode()
{
    return ((mode == "artist") ? ARTIST : NORMAL);
}

void Normal::addPlaylist(string name)
{

    for (int i = 0; i < playlists.size(); i++)
        if (playlists[i].getName() == name)
            throw RESPONSES[3];

    playlists.push_back(Playlist(name));
}

void Normal ::addSongToPlaylist(std::string playlistName, Song *song)
{
    bool playlistFounded = false;
    for (int i = 0; i < playlists.size(); i++)
        if (playlists[i].getName() == playlistName)
        {
            playlists[i].addSong(song);
            playlistFounded = true;
        }

    if (!playlistFounded)
        throw RESPONSES[2];
}

int compareString(string s1, string s2)
{
    if (s1.size() == 0)
        return 1;
    if (s2.size() == 0)
        return 2;

    if (s1[0] < s2[0])
        return 1;
    else if (s2[0] < s1[0])
        return 2;
    else if (s1[0] == s2[0])
        return compareString(s1.erase(0, 1), s2.erase(0, 1));

    return 1;
}

vector<string> Normal::showPlaylists()
{
    if (playlists.size() == 0)
        throw RESPONSES[1];

    vector<string> playlistsInfo;
    vector<string> result;

    for (auto &playlist : playlists)
    {
        string info = playlist.getName() + ", " + to_string(playlist.countSongs()) + ", " + playlist.getTotalDuration();
        playlistsInfo.push_back(info);
    }

    playlistsInfo = sortPlaylistByName(playlistsInfo);
    result.push_back("Playlist_name, Songs_number, Duration");
    for (auto &item : playlistsInfo)
        result.push_back(item);

    return result;
}

vector<string> Normal::sortPlaylistByName(vector<string> &playlistsInfo)
{
    vector<string> sortedInfo;
    int size = playlistsInfo.size();
    for (int i = 0; i < size; i++)
    {
        int smallest = 0;
        for (int j = 1; j < playlistsInfo.size(); j++)
            if (compareString(playlistsInfo[j], playlistsInfo[smallest]) == 1)
                smallest = j;
        sortedInfo.push_back(playlistsInfo[smallest]);
        playlistsInfo.erase(playlistsInfo.begin() + smallest, playlistsInfo.begin() + smallest + 1);
    }

    return sortedInfo;
}

void Artist ::addSong(Song *song)
{
    songs.addSong(song);
}

vector<string> Normal::showPlaylist(string name)
{
    for (auto &playlist : playlists)
        if (playlist.getName() == name)
            return playlist.getSongsList(SHORT_FORMAT);

    throw RESPONSES[2];

    return {};
}

void Normal::like(Song *song)
{
    if (liked.contain(song))
        throw RESPONSES[3];

    liked.addSong(song);
    song->like();
}

User *UserList ::searchForUser(string id)
{
    int index;
    try
    {
        index = stoi(id);
    }
    catch (const exception &e)
    {
        throw RESPONSES[3];
    }

    if (to_string(index) != id)
        throw RESPONSES[3];

    for (int i = 0; i < users.size(); i++)
        if (users[i]->getId() == index)
            return users[i];

    throw RESPONSES[2];

    return NULL;
}

void UserList::deleteSongGlobaly(Song *song)
{
    for (auto &user : users)
        if (user->getMode() == NORMAL)
            ((Normal *)user)->deleteSongFromPlaylists(song);
}

vector<string> UserList::createUsersListFormat()
{
    vector<string> result;
    if (users.size() == 0)
        result.push_back(RESPONSES[1]);
    else
    {
        result.push_back("ID, Mode, Username, Playlists_number/Songs_number");
        for (auto &user : users)
            result.push_back(user->getDetailsShort());
    }

    return result;
}

User *UserList::checkLogin(vector<string> &props)
{
    bool usernameFounded = false;
    for (auto &user : users)
        if (user->getUsername() == props[0])
        {
            usernameFounded = true;
            if (user->getPassword() != props[1])
                throw RESPONSES[4];
            return user;
        }

    if (!usernameFounded)
        throw RESPONSES[2];

    return NULL;
}

User *UserList::createUser(std::vector<std::string> &props)
{
    for (int i = 0; i < users.size(); i++)
        if (users[i]->getUsername() == props[0])
            throw RESPONSES[3];

    if (props[2] != "artist" && props[2] != "user")
        throw RESPONSES[3];

    if (props[2] == "user")
        users.push_back(new Normal(users.size() + 1, props));
    else
        users.push_back(new Artist(users.size() + 1, props));

    return users[users.size() - 1];
}