#ifndef SERVER_HPP_INCLUDE
#define SERVER_HPP_INCLUDE

#include <exception>
#include <string>
#include <vector>

#include "../utils/include.hpp"
#include "../utils/request.hpp"
#include "../utils/response.hpp"
#include "../utils/template_parser.hpp"
#include "route.hpp"
#include "../Logic/app.hpp"

#ifdef _WIN32
typedef unsigned SOCKET;
#else
typedef int SOCKET;
#endif

class TemplateParser;

class RequestHandler {
public:
    virtual ~RequestHandler();
    virtual Response* callback(Request* req) = 0;
protected:
    App* app ;
};

class ShowFile : public RequestHandler {
    std::string filePath;
    std::string fileType;

public:
    ShowFile(std::string filePath, std::string fileType);
    Response* callback(Request* req);
};

class ShowPage : public ShowFile {
public:
    ShowPage(std::string _filePath);
};

class ShowImage : public ShowFile {
public:
    ShowImage(std::string _filePath);
};

class TemplateHandler : public RequestHandler {
    std::string filePath;
    TemplateParser* parser;

public:
    TemplateHandler(std::string _filePath);
    Response* callback(Request* req);
    virtual std::map<std::string, std::string> handle(Request* req);
};

class Server {
public:
    Server(int port = 5000);
    ~Server();
    void run();
    void get(std::string path, RequestHandler* handler);
    void post(std::string path, RequestHandler* handler);
    void setNotFoundErrPage(std::string);

    class Exception : public std::exception {
    public:
        Exception() {}
        Exception(const std::string);
        std::string getMessage() const;

    private:
        std::string message;
    };

private:
    SOCKET sc;
    int port;
    std::vector<Route*> routes;
    RequestHandler* notFoundHandler;
};

#endif // SERVER_HPP_INCLUDE
