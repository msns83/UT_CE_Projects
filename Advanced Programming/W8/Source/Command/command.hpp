#ifndef COMMAND
#define COMMAND

#include <vector>
#include <string>
#include "../properties.hpp"

class Command
{
public:
    std::vector<std::string> giveResponse();

protected:
    std::vector<std::string> extractProps(std::vector<std::string> requiredProps, std::vector<std::string> optionalProps, std::vector<std::string> &propsValue);
    void findRequiredProps(std::vector<std::string> requiredProps, std::vector<std::string> &propsValue, std::vector<std::string> &organizedValue);
    void findOptionalProps(std::vector<std::string> optionalProps, std::vector<std::string> &propsValue, std::vector<std::string> &organizedValue, int requiredCounts);
    std::vector<std::string> response;
};

#endif