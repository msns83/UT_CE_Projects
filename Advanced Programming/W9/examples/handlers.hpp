#ifndef HANDLERS
#define HANDLERS

#include <cstdlib>
#include <iostream>

#include "../Logic/app.hpp"
#include "../server/server.hpp"

class UploadHandler : public RequestHandler {
public:
    UploadHandler(App* _app) { app = _app; }
    Response* callback(Request* req);
};

class FollowHandler : public RequestHandler {
public:
    FollowHandler(App* _app) { app = _app; }
    Response* callback(Request* req);
};

class UnFollowHandler : public RequestHandler {
public:
    UnFollowHandler(App* _app) { app = _app; }
    Response* callback(Request* req);
};

class UserListHandler : public RequestHandler {
public:
    UserListHandler(std::string address, App* _app) : pageAddress(address) { app = _app; }
    Response* callback(Request* req);

private:
    std::string pageAddress;
};

class UserHandler : public RequestHandler {
public:
    UserHandler(std::string address, App* _app) : pageAddress(address) { app = _app; }
    Response* callback(Request* req);

private:
    std::string pageAddress;
};

class PlaylistHandler : public RequestHandler {
public:
    PlaylistHandler(std::string address, App* _app) : pageAddress(address) { app = _app; }
    Response* callback(Request* req);

private:
    std::string pageAddress;
};

class ShowPlaylistsHandler : public RequestHandler {
public:
    ShowPlaylistsHandler(std::string address, App* _app) : pageAddress(address) { app = _app; }
    Response* callback(Request* req);

private:
    std::string pageAddress;
};

class AddToPlaylistHandler : public RequestHandler {
public:
    AddToPlaylistHandler(App* _app) { app = _app; }
    Response* callback(Request* req);
};

class DeletePlaylistHandler : public RequestHandler {
public:
    DeletePlaylistHandler(App* _app) { app = _app; }
    Response* callback(Request* req);
};

class deleteSongHandler : public RequestHandler {
public:
    deleteSongHandler(App* _app) { app = _app; }
    Response* callback(Request* req);
};

class PopularsHandler : public RequestHandler {
public:
    PopularsHandler(App* _app) { app = _app; }
    Response* callback(Request* req);
};

class CreatePlaylistHandler : public RequestHandler {
public:
    CreatePlaylistHandler(App* _app) { app = _app; }
    Response* callback(Request* req);
};

class MainPageHandler : public TemplateHandler {
public:
    MainPageHandler(std::string filePath, App* _app) : TemplateHandler(filePath) { app = _app; };
    std::map<std::string, std::string> handle(Request* req);
};

class SongPageHandler : public RequestHandler {
public:
    SongPageHandler(App* _app) { app = _app; };
    Response* callback(Request* req);
};

class SearchHandler : public RequestHandler {
public:
    SearchHandler(App* _app) { app = _app; };
    Response* callback(Request* req);
};

class ShowMusic : public RequestHandler {
public:
    ShowMusic(App* _app) {app = _app;}
    Response* callback(Request* req);
};

class ArtistSongsHandler : public RequestHandler {
public:
    ArtistSongsHandler(App* _app) {app = _app;}
    Response* callback(Request* req);
};

#endif