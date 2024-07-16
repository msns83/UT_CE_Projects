#ifndef TOOLS
#define TOOLS

#include <string>
#include <vector>

std::string showAlert(std::string message, std::string redirect);
std::string showTable(std::vector<std::string> unorganized, std::vector<std::string> titles, std::string link);
std::vector<std::string> split(std::string text, char separator);

#endif