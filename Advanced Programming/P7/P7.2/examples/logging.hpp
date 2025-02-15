#ifndef LOGGING
#define LOGGING

#include "../Logic/app.hpp"
#include "../server/server.hpp"

class LoginHandler : public RequestHandler {
public:
    LoginHandler(App* _app) { app = _app; }
    Response* callback(Request* req);
};

class ShowLoginPage : public TemplateHandler {
public:
    ShowLoginPage(std::string filePath, App* _app) : TemplateHandler(filePath) { app = _app; }
    std::map<std::string, std::string> handle(Request* req);
};

class SignupHandler : public RequestHandler {
public:
    SignupHandler(App* _app) { app = _app; }
    Response* callback(Request* req);
};

class ShowSignupPage : public TemplateHandler {
public:
    ShowSignupPage(std::string filePath, App* _app) : TemplateHandler(filePath) { app = _app; }
    std::map<std::string, std::string> handle(Request* req);
};

class LogoutHandler : public RequestHandler {
public:
    LogoutHandler(App* _app) { app = _app; }
    Response* callback(Request* req);
};

#endif
