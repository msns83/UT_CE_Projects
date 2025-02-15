#ifndef INTERFACE
#define INTERFACE

#include <vector>
#include <string>

class Interface
{
public:
    void read_inputs();
    std::vector<std::vector<std::string>> *get_commands() { return &list_of_commands; }
    void print_results(std::vector<std::string>* results_list);

private:
    std::vector<std::vector<std::string>> list_of_commands;
    std::vector<std::string> split_command(std::string one_line_command);
};

#endif