#ifndef PROPS
#define PROPS

#include <string>
#include <vector>

#include "../Logic/app.hpp"
#include "../server/server.hpp"

void mapServerPaths(Server& server, App* app);

const std::vector<std::string> urls = {"/",
                                       "/signup",
                                       "/signup",
                                       "/login",
                                       "/login",
                                       "/logout",
                                       "/usersList",
                                       "/user",
                                       "/follow",
                                       "/unfollow",
                                       "/createPlaylist",
                                       "/createPlaylist",
                                       "/playlists",
                                       "/playlist",
                                       "/shareSong",
                                       "/shareSong",
                                       "/artistSongs",
                                       "/song",
                                       "/search",
                                       "/search",
                                       "/addToPlaylist",
                                       "/deletePlaylist",
                                       "/deleteSong",
                                       "/recomendations",
                                       "/music.png",
                                       "/songs"};

#endif