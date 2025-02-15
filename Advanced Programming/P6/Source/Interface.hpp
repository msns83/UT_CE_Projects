#ifndef INTERFACE
#define INTERFACE

#include <vector>
#include <string>

class Interface
{
public:
    Interface(int argc, char *argv[], std::vector<std::string> commandNames);
    std::vector<int> getFilters();
    std::vector<std::vector<int>> getFiltersProp();
    std::vector<std::vector<std::string>> getFilePaths();
    void takeFilePaths();

private:
    std::vector<int> generateViewfromText(char *phrase);
    std::vector<int> filterNumber;
    std::vector<std::vector<int>> filterView;
    std::vector<std::vector<std::string>> filePaths;
};

#endif