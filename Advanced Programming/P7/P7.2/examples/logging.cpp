#include "logging.hpp"

#include <iostream>
#include <sstream>

#include "../Logic/app.hpp"
#include "../utils/utilities.hpp"
#include "tools.hpp"
using namespace std;

map<string, string> ShowSignupPage::handle(Request* req) {
    map<string, string> context;
    context["result"] = (app->getStatus() != "out") ? "Permission Denied" : app->getResult()[0];
    return context;
}

map<string, string> ShowLoginPage::handle(Request* req) {
    map<string, string> context;
    context["result"] = (app->getStatus() != "out") ? "Permission Denied" : app->getResult()[0];
    return context;
}

Response* LoginHandler::callback(Request* req) {
    Response* res = new Response;
    if (app->getStatus() != "out")
        return Response::redirect("/");

    app->process({"POST", "login", "username", req->getBodyParam("username"), "password", req->getBodyParam("password")});
    if (app->getResult()[0] == "OK") {
        res->setSessionId(app->getId());
        res = Response::redirect("/");
    }
    else
        res = Response::redirect("/login");

    return res;
}

Response* LogoutHandler::callback(Request* req) {
    Response* res = Response::redirect("/login");
    if (app->getStatus() == "out")
        return Response::redirect("/");

    app->process({"POST", "logout"});

    if (app->getResult()[0] == "OK")
        res->setSessionId("SID");
    else
        app->setResult("OK");

    return res;
}

Response* SignupHandler::callback(Request* req) {
    Response* res = new Response;
    if (app->getStatus() != "out")
        return Response::redirect("/");

    app->process({"POST", "signup", "username", req->getBodyParam("username"), "password", req->getBodyParam("password"), "mode", req->getBodyParam("mode")});
    if (app->getResult()[0] == "OK") {
        res = Response::redirect("/");
        res->setSessionId(app->getId());
    }
    else
        res = Response::redirect("/signup");

    return res;
}
