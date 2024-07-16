#include "Interface.hpp"
#include <iostream>
#include <string>
#include <vector>
using namespace std;

const char COMMAND_IDENTIFIER = '-';

Interface ::Interface(int argc, char *argv[], vector<string> commandNames)
{
    for (int i = 1; i < argc; i++)
        for (int j = 0; j < commandNames.size(); j++)
            if (argv[i] == commandNames[j])
            {
                filterNumber.push_back(j);
                if (i != argc - 1 && argv[i + 1][0] != COMMAND_IDENTIFIER)
                    filterView.push_back(generateViewfromText(argv[i + 1]));
                else
                    filterView.push_back({-1, -1, -1, -1});
                break;
            }
}

vector<int> Interface::getFilters()
{
    return filterNumber;
}

vector<vector<int>> Interface::getFiltersProp()
{
    return filterView;
}

void Interface ::takeFilePaths()
{
    string inputFilePath;
    string outputFilePath;
    while (cin >> inputFilePath)
    {
        cin >> outputFilePath;
        filePaths.push_back({inputFilePath, outputFilePath});
    }
}

vector<vector<string>> Interface ::getFilePaths()
{
    return filePaths;
}

vector<int> Interface ::generateViewfromText(char *phrase)
{
    int j = 0;
    vector<int> view;
    for (int i = 0; i < 4; i++)
    {
        string number = "";
        while (phrase[j] != ':' && phrase[j] != '\0')
        {
            number = number + phrase[j];
            j++;
        }

        view.push_back(stoi(number));
        j++;
    }
    return view;
}
