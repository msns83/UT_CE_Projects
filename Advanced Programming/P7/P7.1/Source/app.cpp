#include <string>
#include <vector>
#include "app.hpp"
#include "./Command/post.hpp"
#include "./Command/put.hpp"
#include "./Command/get.hpp"
#include "./Command/delete.hpp"
using namespace std;

vector<string> App ::process(vector<string> command)
{
    if (command[0] == COMMAND_TYPE[0])
    {
        Post postCommand(command, users, state, currentUser, songs);
        return postCommand.giveResponse();
    }
    else if (command[0] == COMMAND_TYPE[1])
    {
        Get getCommand(command, songs, state, users, currentUser);
        return getCommand.giveResponse();
    }
    else if (command[0] == COMMAND_TYPE[2])
    {
        Put putCommand(command, currentUser, state, songs);
        return putCommand.giveResponse();
    }
    else if (command[0] == COMMAND_TYPE[3])
    {
        Delete deleteCommand(command, users, state, currentUser, songs);
        return deleteCommand.giveResponse();
    }

    return {RESPONSES[3]};
}