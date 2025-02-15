#include <iostream>
#include <string>
#include <vector>
#include "interface.hpp"
#include "app.hpp"
using namespace std;

int main()
{
    Interface terminal;
    App sputify;

    for (auto &command : terminal.getCommands())
        terminal.showOutput(sputify.process(command));

    return 0;
}