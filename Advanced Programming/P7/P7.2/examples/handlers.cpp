#include "handlers.hpp"

#include <iostream>
#include <sstream>

#include "../Logic/app.hpp"
#include "../utils/utilities.hpp"
#include "tools.hpp"
using namespace std;

Response* UploadHandler::callback(Request* req) {
    Response* res = new Response;
    if (app->getStatus() == "out")
        return Response::redirect("/login");

    string duration = req->getBodyParam("hours") + ":" + req->getBodyParam("minutes") + ":" + req->getBodyParam("seconds");
    app->process({"POST", "music", "title", req->getBodyParam("title"), "format", req->getBodyParam("fileName"), "year", req->getBodyParam("year"), "album", req->getBodyParam("album"), "tags", req->getBodyParam("tags"), "duration", duration});
    if (app->getResult()[0] == "OK") {
        utils::writeToFile(req->getBodyParam("file"), "./files/musics/" + req->getBodyParam("fileName"));
        return Response::redirect("/");
    }

    res->setHeader("Content-Type", "text/html");
    res->setBody(showAlert("You filled something wrong, try agian!", "shareSong"));
    return res;
}

map<string, string> MainPageHandler::handle(Request* req) {
    map<string, string> context;
    context["status"] = app->getStatus();
    return context;
}

Response* SongPageHandler::callback(Request* req) {
    Response* res = new Response;
    if (app->getStatus() == "out")
        return Response::redirect("/login");

    app->process({"GET", "musics", "id", req->getQueryParam("id")});
    if (app->getResult().size() == 1)
        return Response::redirect("/");

    string body = utils::readFile("template/theme.html");
    body += "<div class=\"container\"><audio controls><source src=\"songs?id=" + req->getQueryParam("id") + "\"></audio></div><br>";
    body += "<div class=\"container\"><p>ID, Name, Artist, Year, Album, Tags, Duration</p><br><p>" + app->getResult()[0] + "</p></div><br>";
    if (app->getStatus() == "user")
        body += "<div class=\"container\"><form action=\"/addToPlaylist\" method=\"post\"><input type=\"hidden\" name=\"id\" value=\"" + req->getQueryParam("id") + "\"><label for=\"playlist\">Playlist name</label><input type=\"text\" name=\"playlist\" required><button type=\"submit\">add to playlist</button></form></div><br>";
    if (app->getStatus() == "artist" && (" " + app->getUsername()) == split(app->getResult()[0], ',')[2])
        body += "<div class=\"container\"><form action=\"/deleteSong\" method=\"post\"><input type=\"hidden\" name=\"id\" value=\"" + req->getQueryParam("id") + "\"><button type=\"submit\">delete Song</button></form></div><br>";
    body += "</div></body></html>";

    res->setBody(body);
    res->setHeader("Content-Type", "text/html");
    return res;
}

Response* UserListHandler::callback(Request* req) {
    Response* res = new Response;
    if (app->getStatus() == "out")
        return Response::redirect("/login");

    app->process({"GET", "users"});
    res->setBody(showTable(app->getResult(), {"ID", "Mode", "Username", "Playlists_number/Songs_number"}, "user?id="));
    res->setHeader("Content-Type", "text/html");
    return res;
}

Response* ShowPlaylistsHandler::callback(Request* req) {
    Response* res = new Response;
    if (app->getStatus() == "out")
        return Response::redirect("/login");

    app->process({"GET", "playlist", "id", app->getId()});
    res->setBody(showTable(app->getResult(), {"Playlist name", "Songs number", "Duration"}, "playlist?name="));
    res->setHeader("Content-Type", "text/html");
    return res;
}

Response* PlaylistHandler::callback(Request* req) {
    Response* res = new Response;
    if (app->getStatus() == "out")
        return Response::redirect("/login");

    app->process({"GET", "playlist", "id", app->getId(), "name", req->getQueryParam("name")});
    string body = showTable(app->getResult(), {"ID", "Name", "Artist"}, "song?id=");
    string deleteButton = "<div class=\"container\"><form action=\"/deletePlaylist\" method=\"post\"><input type=\"hidden\" name=\"playlist\" value=\"" + req->getQueryParam("name") + "\"><button action=\"submit\">delete</button></form></div><br>";
    body.insert(body.find("<div class=\"main-content\">") + 26, deleteButton);
    res->setBody(body);
    res->setHeader("Content-Type", "text/html");
    return res;
}

Response* AddToPlaylistHandler::callback(Request* req) {
    Response* res = new Response;
    if (app->getStatus() != "user")
        return Response::redirect("/login");

    app->process({"PUT", "add_playlist", "name", req->getBodyParam("playlist"), "id", req->getBodyParam("id")});
    if (app->getResult()[0] == "OK")
        return Response::redirect("/");

    res->setBody(showAlert("playlist name doesn't exist", "song?id=" + req->getBodyParam("id")));
    res->setHeader("Content-Type", "text/html");
    return res;
}

Response* DeletePlaylistHandler::callback(Request* req) {
    Response* res = new Response;
    if (app->getStatus() != "user")
        return Response::redirect("/login");

    app->process({"DELETE", "playlist", "name", req->getBodyParam("playlist")});
    if (app->getResult()[0] == "OK")
        return Response::redirect("/");

    res->setBody(showAlert("something is wrong", "/"));
    res->setHeader("Content-Type", "text/html");
    return res;
}

Response* deleteSongHandler::callback(Request* req) {
    Response* res = new Response;
    if (app->getStatus() != "artist")
        return Response::redirect("/login");

    app->process({"DELETE", "music", "id", req->getBodyParam("id")});
    if (app->getResult()[0] == "OK")
        return Response::redirect("/");

    res->setBody(showAlert("something is wrong", "/song?id=" + req->getBodyParam("id")));
    res->setHeader("Content-Type", "text/html");
    return res;
}

Response* PopularsHandler::callback(Request* req) {
    Response* res = new Response;
    if (app->getStatus() != "user")
        return Response::redirect("/login");

    app->process({"GET", "recommendations"});
    string body = showTable(app->getResult(), {"ID", "Name", "Artist", "Likes"}, "song?id=");
    res->setBody(body);
    res->setHeader("Content-Type", "text/html");
    return res;
}

Response* SearchHandler::callback(Request* req) {
    Response* res = new Response;
    if (app->getStatus() == "out")
        return Response::redirect("/login");

    app->process({"GET", "search_music", "name", req->getBodyParam("name"), "artist", req->getBodyParam("artist"), "tag", req->getBodyParam("tag")});
    string body = showTable(app->getResult(), {"ID", "Name", "Artist"}, "song?id=");

    string form = "<div class=\"container\"><form action=\"/search\" method=\"post\">";
    form += "<label for=\"name\">Name</label><input name=\"name\" type=\"text\"><br>";
    form += "<label for=\"artist\">Artist</label><input name=\"artist\" type=\"text\"><br>";
    form += "<label for=\"tag\" placeholder=\"just one Tag\">Tag</label><input name=\"tag\" type=\"text\"><br>";
    form += "<button type=\"submit\">submit</button></form></div>";
    body.insert(body.find("<div class=\"main-content\">") + 26, form);

    res->setBody(body);
    res->setHeader("Content-Type", "text/html");
    return res;
}

Response* UserHandler::callback(Request* req) {
    Response* res = new Response;
    if (app->getStatus() == "out")
        return Response::redirect("/login");

    app->process({"GET", "users", "id", req->getQueryParam("id")});
    if (app->getResult()[0] == "Not Found")
        return Response::redirect("/");

    string body = utils::readFile(pageAddress);
    body += "<div class=\"container\" >";
    body += "<p>" + app->getResult()[0] + "</p><br>";
    body += "<form action=\"/follow\" method=\"post\"><input type=\"hidden\" id=\"id\" name=\"id\" value=\"" + req->getQueryParam("id") + "\">" + "<button type=\"submit\">Follow</button></form><br>";
    body += "<form action=\"/unfollow\" method=\"post\"><input type=\"hidden\" id=\"id\" name=\"id\" value=\"" + req->getQueryParam("id") + "\">" + "<button type=\"submit\">Unfollow</button></form>";
    body += "</div></div></body></html>";
    
    res->setBody(body);
    res->setHeader("Content-Type", "text/html");
    return res;
}

Response* CreatePlaylistHandler::callback(Request* req) {
    Response* res = new Response;
    if (app->getStatus() == "out")
        return Response::redirect("/login");

    app->process({"POST", "playlist", "name", req->getBodyParam("name")});
    if (app->getResult()[0] == "OK")
        return Response::redirect("/");

    res->setHeader("Content-Type", "text/html");
    res->setBody(showAlert("you have a playlist with this name!", "createPlaylist"));

    return res;
}

Response* FollowHandler::callback(Request* req) {
    Response* res = new Response;
    if (app->getStatus() == "out")
        return Response::redirect("/login");

    app->process({"POST", "follow", "id", req->getBodyParam("id")});
    if (app->getResult()[0] == "OK")
        return Response::redirect("/");

    res->setHeader("Content-Type", "text/html");
    res->setBody(showAlert("you are following your self or you follow this person before!", "user?id=" + req->getBodyParam("id")));
    return res;
}

Response* UnFollowHandler::callback(Request* req) {
    Response* res = new Response;
    if (app->getStatus() == "out")
        return Response::redirect("/login");

    app->process({"POST", "unfollow", "id", req->getBodyParam("id")});
    if (app->getResult()[0] == "OK")
        return Response::redirect("/");

    res->setHeader("Content-Type", "text/html");
    res->setBody(showAlert("you are unfollowing yourself or you do not follow this person until now!", "user?id=" + req->getBodyParam("id")));
    return res;
}

Response* ShowMusic::callback(Request* req) {
    Response* res = new Response;
    if (app->getStatus() == "out")
        return Response::redirect("/");

    app->process({"GET", "musics", "id", req->getQueryParam("id")});
    if (app->getResult().size() == 1)
        return Response::redirect("/");

    string filename = app->getResult()[1];
    res->setHeader("Content-Type", "audio/mpeg");
    res->setBody(utils::readFile("./files/musics/" + filename));
    return res;
}

Response* ArtistSongsHandler::callback(Request* req) {
    Response* res = new Response;
    if (app->getStatus() != "artist")
        return Response::redirect("/login");

    app->process({"GET", "registered_musics"});
    res->setBody(showTable(app->getResult(), {"ID", "Name", "Artist", "Year", "Album", "Tags", "Duration"}, "song?id="));
    res->setHeader("Content-Type", "text/html");
    return res;
}