#include <iostream>
#include <string>

#include "properties.hpp"
#include "handlers.hpp"
#include "logging.hpp"
using namespace std ;

void mapServerPaths(Server& server, App* app) {
    server.setNotFoundErrPage("static/404.html");
    server.get(urls[0], new MainPageHandler("template/home.html",app) );

    server.get(urls[1], new ShowSignupPage("template/signup.html",app));
    server.post(urls[2], new SignupHandler(app));

    server.get(urls[3], new ShowLoginPage("template/login.html",app));
    server.post(urls[4], new LoginHandler(app));

    server.post(urls[5], new LogoutHandler(app));

    server.get(urls[6], new UserListHandler("template/theme.html", app) );
    server.get(urls[7], new UserHandler("template/theme.html", app) );

    server.post(urls[8], new FollowHandler(app) );
    server.post(urls[9], new UnFollowHandler(app) );

    server.get(urls[10], new ShowPage("static/createPlaylist.html") );
    server.post(urls[11], new CreatePlaylistHandler(app) );

    server.get(urls[12], new ShowPlaylistsHandler("template/theme.html", app) );
    server.get(urls[13], new PlaylistHandler("template/theme.html", app) );

    server.get(urls[14], new ShowPage("static/upload_form.html"));
    server.post(urls[15], new UploadHandler(app));
    
    server.get(urls[16], new ArtistSongsHandler(app));
    
    server.get(urls[17], new SongPageHandler(app));

    server.get(urls[18], new SearchHandler(app));
    server.post(urls[19], new SearchHandler(app));

    server.post(urls[20], new AddToPlaylistHandler(app));
    server.post(urls[21], new DeletePlaylistHandler(app));
    server.post(urls[22], new deleteSongHandler(app));
    server.get(urls[23], new PopularsHandler(app));

    server.get(urls[24], new ShowImage("static/music.png"));
    server.get(urls[25], new ShowMusic(app));
}