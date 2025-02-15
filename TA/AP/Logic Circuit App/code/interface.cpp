#include <iostream>
#include <string>
#include <vector>
#include <sstream>

#include "interface.hpp"
using namespace std;

void Interface::read_inputs()
{
    string one_line_command;

    while (getline(cin, one_line_command))
        list_of_commands.push_back(split_command(one_line_command));
}

vector<string> Interface::split_command(string one_line_command)
{
    istringstream command_stream(one_line_command);
    vector<string> splitted_command;
    string word;

    while (command_stream >> word)
        splitted_command.push_back(word);

    return splitted_command;
}

void Interface::print_results(std::vector<std::string> *results_list)
{
    for (auto result : *results_list)
        cout << result << endl;
}
