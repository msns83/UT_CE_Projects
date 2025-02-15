#ifndef PLAYLIST
#define PLAYLIST

#include <vector>
#include <string>
#include "properties.hpp"

class Song
{
public:
    Song(int _id, std::string _name, std::string _path, std::string _year, std::string _album, std::string _tags, std::string _duration, std::string _artist);

    std::string getArtist() { return artist; }
    std::string getName() { return name; }
    int getId() { return id; }
    int getLikes() { return likes; }
    std::vector<int> getDuration() { return duration; }
    void like();
    std::string getFileName() {return format;}

    std::string getDetailsShort();
    std::string getDetailsLong();

    bool containTag(std::string _tag);

private:
    void setYear(std::string _year);
    void setTags(std::string _tags);
    void setDuration(std::string _duration);
    int validateTime(std::stringstream &durationLine);
    int id;
    int year;
    std::string format;
    std::string name;
    std::string album;
    std::vector<std::string> tags;
    std::vector<int> duration;
    std::string artist;
    int likes = 0;
};

class Playlist
{
public:
    Playlist(std::string _name) : name(_name){};
    std::string getName() { return name; }
    std::string getTotalDuration();
    std::string getSongNames();
    std::vector<std::string> getSongsList(TypeOfList format);
    int countSongs();
    void addSong(Song *song);
    bool contain(Song *song);
    Song *createSong(std::vector<std::string> &props, std::string _artist);
    Song *findSongById(std::string id);
    Playlist searchSong(std::vector<std::string> &props);
    void deleteSong(Song *selectedSong);
    Playlist getmostLiked(int numberOfItems, Playlist confilictPlaylisy);

private:
    void searchName(std::vector<Song *> &review, std::vector<Song *> &result, std::string searchValue);
    void searchArtist(std::vector<Song *> &review, std::vector<Song *> &result, std::string searchValue);
    void searchTag(std::vector<Song *> &review, std::vector<Song *> &result, std::string searchValue);
    int findMostPopular(std::vector<Song *> &review);
    std::vector<std::string> getSongsListShort();
    std::vector<std::string> getSongsListLong();
    std::vector<std::string> getSongsListLikes();

    std::string name;
    std::vector<Song *> songs;
};

#endif