#include "app.hpp"

#include <string>
#include <vector>

#include "./delete.hpp"
#include "./get.hpp"
#include "./post.hpp"
#include "./put.hpp"
using namespace std;

void App ::process(vector<string> command) {
    if (command[0] == COMMAND_TYPE[0]) {
        Post postCommand(command, users, state, currentUser, songs);
        response = postCommand.giveResponse();
    }
    else if (command[0] == COMMAND_TYPE[1]) {
        Get getCommand(command, songs, state, users, currentUser);
        response = getCommand.giveResponse();
    }
    else if (command[0] == COMMAND_TYPE[2]) {
        Put putCommand(command, currentUser, state, songs);
        response = putCommand.giveResponse();
    }
    else if (command[0] == COMMAND_TYPE[3]) {
        Delete deleteCommand(command, users, state, currentUser, songs);
        response = deleteCommand.giveResponse();
    }
    else {
        response = {RESPONSES[3]};
    }
}

string App::getId() {
    return to_string(currentUser->getId());
}

string App::getUsername() {
    return currentUser->getUsername();
}

string App::getStatus() {
    if (state == NORMAL)
        return "user";
    if (state == ARTIST)
        return "artist";

    return "out";
}