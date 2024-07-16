#ifndef INTERFACE
#define INTERFACE

#include <vector>
#include <string>

class Interface
{
public:
    Interface();
    std::vector<std::vector<std::string>> getCommands();
    void showOutput(std::vector<std::string> output);

private:
    std::vector<std::vector<std::string>> commands;
    void takeValues(std::stringstream &commandLine, std::vector<std::string> &commandProps);
};

#endif