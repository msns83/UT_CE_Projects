#include "interface.hpp"
#include <iostream>
#include <sstream>
#include <string>
using namespace std;

Interface ::Interface()
{
    string tempString;

    while (getline(cin, tempString))
    {
        vector<string> commandProps;
        stringstream commandLine(tempString);

        commandLine >> tempString;
        commandProps.push_back(tempString);

        commandLine >> tempString;
        commandProps.push_back(tempString);

        commandLine >> tempString;

        takeValues(commandLine, commandProps);

        commands.push_back(commandProps);
    }
}

void Interface::takeValues(stringstream &commandLine, vector<string> &commandProps)
{
    string tempString;
    while (commandLine >> tempString)
    {
        if (tempString[0] == '<')
        {
            tempString.erase(tempString.begin(), tempString.begin() + 1);
            if (tempString[tempString.size() - 1] == '>')
                tempString.pop_back();
            else
            {
                string restOfPhrase;
                getline(commandLine, restOfPhrase, '>');
                tempString += restOfPhrase;
            }
        }
        commandProps.push_back(tempString);
    }
}

vector<vector<string>> Interface ::getCommands()
{
    return commands;
}

void Interface ::showOutput(vector<string> output)
{
    for (auto &item : output)
        cout << item << endl;
}