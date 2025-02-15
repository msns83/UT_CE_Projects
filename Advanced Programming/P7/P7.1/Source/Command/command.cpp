#include <vector>
#include <string>
#include "command.hpp"
using namespace std;

vector<string> Command ::extractProps(vector<string> requiredProps, vector<string> optionalProps, vector<string> &propsValue)
{
    vector<string> organizedValue;
    if (propsValue.size() % 2 != 0 || propsValue.size() < (2 + (2 * requiredProps.size())))
        throw RESPONSES[3];

    findRequiredProps(requiredProps, propsValue, organizedValue);
    if (organizedValue.size() != requiredProps.size())
        throw RESPONSES[3];

    for (int j = 0; j < optionalProps.size(); j++)
        organizedValue.push_back("");
    findOptionalProps(optionalProps, propsValue, organizedValue, requiredProps.size());

    return organizedValue;
}

void Command::findRequiredProps(vector<string> requiredProps, vector<string> &propsValue, vector<string> &organizedValue)
{
    for (int j = 0; j < requiredProps.size(); j++)
        for (int i = 2; i < propsValue.size(); i += 2)
            if (requiredProps[j] == propsValue[i])
            {
                organizedValue.push_back(propsValue[i + 1]);
                propsValue.erase(propsValue.begin() + i, propsValue.begin() + i + 2);
                break;
            }
}

void Command ::findOptionalProps(vector<string> optionalProps, vector<string> &propsValue, vector<string> &organizedValue, int requiredCounts)
{
    for (int i = 2; i < propsValue.size(); i += 2)
    {
        bool wrongProp = true;
        for (int j = 0; j < optionalProps.size(); j++)
            if (propsValue[i] == optionalProps[j])
            {
                organizedValue[requiredCounts + j] = propsValue[i + 1];
                wrongProp = false;
            }
        if (wrongProp)
            throw RESPONSES[3];
    }
}

vector<string> Command ::giveResponse()
{
    return response;
}