#include "./app.hpp"
#include "./properties.hpp"
#include <vector>
#include <string>
using namespace std;

App ::App(vector<int> filterNums, vector<vector<int>> filterview, vector<vector<string>> filePaths)
{
    for (int i = 0; i < filterNums.size(); i++)
        findFilterFromNumber(filterNums, filterview, i);

    for (auto &filePath : filePaths)
        photos.push_back(new Photo(filePath[0], filePath[1]));
}

void App::findFilterFromNumber(vector<int> &filterNums, vector<vector<int>> &filterview, int i)
{
    if (filterNums[i] <= KERNEL_FILTER_COUNT - 1)
        filters.push_back(new KernelFilter(filterNums[i], filterview[i]));
    else if (filterNums[i] == KERNEL_FILTER_COUNT)
        filters.push_back(new InvertFilter(filterview[i]));
    else if (filterNums[i] == KERNEL_FILTER_COUNT + 1)
        filters.push_back(new GarayscaleFilter(filterview[i]));
}

void App::applyFilters()
{
    for (Photo *photo : photos)
    {
        for (Filter *filter : filters)
            photo->applyFilter(filter);
        photo->save();
        delete photo;
    }
}