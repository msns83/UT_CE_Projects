#ifndef USER
#define USER

#include <vector>
#include <string>
#include "playlist.hpp"
#include "properties.hpp"

class User
{
public:
    std::string getUsername();
    std::string getPassword();
    int getId();
    Status getMode();
    virtual std::string getDetailsShort() = 0;
    virtual std::string getDetailsLong();
    void follow(User *selectedUser);
    void unfollow(User *selectedUser);

protected:
    int id;
    std::string username;
    std::string password;
    std::string mode;
    std::vector<User *> followings;
    std::vector<User *> followers;

private:
    std::string makeFollowList(std::vector<User *> &list, std::string initialText);
    void removeFollower(User *selectedUser);
};

class Normal : public User
{
public:
    Normal(int _id, std::vector<std::string> props);
    void addPlaylist(std::string name);
    void addSongToPlaylist(std::string playlistName, Song *song);
    std::vector<std::string> showPlaylists();
    std::vector<std::string> showPlaylist(std::string name);
    void deleteSongFromPlaylists(Song *song);
    void deletePlaylist(std::string playlistName);
    void like(Song *song);
    Playlist getliked() { return liked; }

    virtual std::string getDetailsShort();
    virtual std::string getDetailsLong();

private:
    std::vector<std::string> sortPlaylistByName(std::vector<std::string> &playlistsInfo);
    std::vector<Playlist> playlists;
    Playlist liked;
};

class Artist : public User
{
public:
    Artist(int _id, std::vector<std::string> props);
    void addSong(Song *song);
    void deleteSong(Song *song);
    std::vector<std::string> getSongs();

    virtual std::string getDetailsShort();
    virtual std::string getDetailsLong();

private:
    Playlist songs;
};

class UserList
{
public:
    UserList(){};
    User *searchForUser(std::string id);
    void deleteSongGlobaly(Song *song);
    std::vector<std::string> createUsersListFormat();
    User *checkLogin(std::vector<std::string> &props);
    User *createUser(std::vector<std::string> &props);

private:
    std::vector<User *> users;
};

#endif