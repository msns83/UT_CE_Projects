#include <vector>
#include <string>
#include <iostream>
#include <iostream>
#include <sstream>
#include "playlist.hpp"
using namespace std;

int Playlist ::countSongs()
{
    return songs.size();
}

void Playlist ::addSong(Song *song)
{
    songs.push_back(song);
}

void Playlist ::deleteSong(Song *selectedSong)
{
    for (int i = 0; i < songs.size(); i++)
        if (songs[i] == selectedSong)
            songs.erase(songs.begin() + i, songs.begin() + i + 1);
}

Song *Playlist ::createSong(std::vector<std::string> &props, std::string _artist)
{
    int id = (songs.size() == 0) ? 1 : (songs[songs.size() - 1]->getId()) + 1;
    songs.push_back(new Song(id, props[0], props[1], props[2], props[3], props[4], props[5], _artist));

    return songs[songs.size() - 1];
}

string Playlist ::getSongNames()
{
    string names;
    for (int i = 0; i < ((int)songs.size()) - 1; i++)
        names += songs[i]->getName() + ", ";

    if (((int)songs.size()) != 0)
        names += songs[((int)songs.size()) - 1]->getName();

    return names;
}

Playlist Playlist ::searchSong(vector<string> &props)
{
    vector<Song *> review = songs;
    vector<Song *> result = songs;
    Playlist foundedSongs("foundedSongs");

    if (props[0] != "")
        searchName(review, result, props[0]);

    if (props[1] != "")
        searchArtist(review, result, props[1]);

    if (props[2] != "")
        searchTag(review, result, props[2]);

    for (auto &song : result)
        foundedSongs.addSong(song);

    return foundedSongs;
}

int Playlist::findMostPopular(vector<Song *> &review)
{
    int largest = 0;
    int answer = -1;
    for (int i = 0; i < review.size(); i++)
        if (review[largest]->getLikes() <= review[i]->getLikes())
        {
            if (review[largest]->getLikes() == review[i]->getLikes())
                largest = (review[largest]->getId() < review[i]->getId()) ? largest : i;
            else
                largest = i;
            answer = largest;
        }

    return answer;
}

void Playlist::searchName(vector<Song *> &review, vector<Song *> &result, string searchValue)
{
    result.clear();
    for (auto &song : review)
        if (song->getName().find(searchValue) != std::string::npos)
            result.push_back(song);
    review = result;
}

Playlist Playlist::getmostLiked(int numberOfItems, Playlist confilictPlaylist)
{
    vector<Song *> review = songs;
    Playlist result("most Liked");

    for (int i = 0; i < review.size(); i++)
        if (review[i]->getLikes() == 0)
            review.erase(review.begin() + i, review.begin() + i);

    while (result.countSongs() < numberOfItems && 0 < review.size())
    {
        int largest = findMostPopular(review);
        if (largest != -1)
        {
            if (!confilictPlaylist.contain(review[largest]))
                result.addSong(review[largest]);

            review.erase(review.begin() + largest, review.begin() + largest + 1);
        }
    }
    return result;
}

void Playlist::searchArtist(vector<Song *> &review, vector<Song *> &result, string searchValue)
{
    result.clear();
    for (auto &song : review)
        if (song->getArtist().find(searchValue) != std::string::npos)
            result.push_back(song);
    review = result;
}

void Playlist::searchTag(vector<Song *> &review, vector<Song *> &result, string searchValue)
{
    result.clear();
    for (auto &song : review)
        if (song->containTag(searchValue))
            result.push_back(song);
}

vector<string> Playlist ::getSongsListShort()
{
    vector<string> result;
    for (auto &song : songs)
        result.push_back(song->getDetailsShort());

    return result;
}

vector<string> Playlist ::getSongsListLong()
{
    vector<string> result;
    for (auto &song : songs)
        result.push_back(song->getDetailsLong());

    return result;
}

vector<string> Playlist ::getSongsListLikes()
{
    vector<string> result;

    result.push_back("ID, Name, Artist, Likes");
    for (auto &song : songs)
        result.push_back(song->getDetailsShort() + ", " + to_string(song->getLikes()));

    return result;
}

vector<string> Playlist ::getSongsList(TypeOfList format)
{
    vector<string> result;
    if (songs.size() == 0)
        throw RESPONSES[1];

    if (format == SHORT_FORMAT)
        result = getSongsListShort();
    else if (format == LONG_FORMAT)
        result = getSongsListLong();
    else if (format == WITH_LIKES)
        result = getSongsListLikes();

    return result;
}

bool Playlist::contain(Song *song)
{
    for (auto &item : songs)
        if (item == song)
            return true;

    return false;
}

string addZeroBehind(int number)
{
    if (number < 10)
        return ("0" + to_string(number));

    return to_string(number);
}

Song *Playlist ::findSongById(string id)
{
    int index;
    try
    {
        index = stoi(id);
    }
    catch (...)
    {
        throw RESPONSES[3];
    }

    if (to_string(index) != id)
        throw RESPONSES[3];

    for (int i = 0; i < songs.size(); i++)
        if (songs[i]->getId() == stoi(id))
            return songs[i];

    throw RESPONSES[2];

    return NULL;
}

string Playlist::getTotalDuration()
{
    int totalDuration = 0;
    for (auto &song : songs)
        totalDuration += ((song->getDuration())[0] * 3600) + ((song->getDuration())[1] * 60) + (song->getDuration())[2];

    return (addZeroBehind(totalDuration / 3600) + ":" + addZeroBehind((totalDuration % 3600) / 60) + ":" + addZeroBehind((totalDuration % 3600) % 60));
}

string Song ::getDetailsShort()
{
    return (to_string(id) + ", " + name + ", " + artist);
}

string Song ::getDetailsLong()
{

    string formatedTags;

    for (int i = 0; i < ((int)tags.size()) - 1; i++)
        formatedTags += (tags[i] + ";");

    if (((int)tags.size()) != 0)
        formatedTags += tags[((int)tags.size()) - 1];

    return (getDetailsShort() + ", " + to_string(year) + ", " + album + ", " + formatedTags + ", " + addZeroBehind(duration[0]) + ":" + addZeroBehind(duration[1]) + ":" + addZeroBehind(duration[2]));
}

bool Song::containTag(string _tag)
{
    for (auto &tag : tags)
        if (tag == _tag)
            return true;

    return false;
}

void Song::like()
{
    likes++;
}

Song::Song(int _id, string _name, string _format, string _year, string _album, string _tags, string _duration, string _artist)
{
    id = _id;
    name = _name;
    format = _format;
    artist = _artist;
    album = _album;
    setYear(_year);
    setTags(_tags);
    setDuration(_duration);
}

void Song::setYear(string _year)
{
    try
    {
        year = stoi(_year);
        if (to_string(year) != _year)
            throw RESPONSES[3];
    }
    catch (...)
    {
        year = 0;
        throw RESPONSES[3];
    }
}

void Song::setTags(string _tags)
{
    stringstream tagLine(_tags);
    string tag;
    while (getline(tagLine, tag, ';'))
        tags.push_back(tag);
}

void Song::setDuration(string _duration)
{
    stringstream durationLine(_duration);
    try
    {
        for (int i = 0; i < 3; i++)
            duration.push_back(validateTime(durationLine));
    }
    catch (...)
    {
        duration.clear();
        throw RESPONSES[3];
    }
}

int Song::validateTime(stringstream &durationLine)
{
    string time;
    getline(durationLine, time, ':');
    int convertedTime = stoi(time);
    string testTime = (convertedTime < 10) ? "0" + to_string(convertedTime) : to_string(convertedTime);
    if (time.size() != 2 || testTime != time)
        throw RESPONSES[3];
    return convertedTime;
}