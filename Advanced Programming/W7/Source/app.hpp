#ifndef APP
#define APP

#include <vector>
#include <string>
#include "filter.hpp"
#include "photo.hpp"

class App
{
public:
    App(std::vector<int> filterNums, std::vector<std::vector<int>> filterview, std::vector<std::vector<std::string>> filePaths);
    void applyFilters();

private:
    void findFilterFromNumber(std::vector<int> &filterNums, std::vector<std::vector<int>> &filterview, int i);
    std::vector<Filter *> filters;
    std::vector<Photo *> photos;
};

#endif