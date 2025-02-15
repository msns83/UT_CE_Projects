#include <iostream>
#include <string>

#include "../Logic/app.hpp"
#include "../server/server.hpp"
#include "properties.hpp"

int main(int argc, char** argv) {
    try {
        int port = argc > 1 ? std::stoi(argv[1]) : 5000;
        Server server(port);
        App sputify;

        mapServerPaths(server, &sputify);
        std::cout << "Server running on port: " << port << std::endl;
        server.run();
    }
    catch (const std::invalid_argument& e) {
        std::cerr << e.what() << std::endl;
    }
    catch (const Server::Exception& e) {
        std::cerr << e.getMessage() << std::endl;
    }
    return 0;
}