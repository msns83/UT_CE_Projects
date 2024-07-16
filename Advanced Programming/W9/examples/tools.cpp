#include "tools.hpp"

#include <iostream>
#include <sstream>
#include <string>
#include <vector>

#include "../utils/utilities.hpp"

using namespace std;

string showAlert(string message, string redirect) {
    string body = "<!DOCTYPE html><html><head><title>Message</title><script>window.onload = function () {\n";
    body += "alert(\"" + message + "\");\n";
    body += "window.location.replace(\"" + redirect + "\");};\n</script></head><body></body></html>";
    return body;
}

vector<string> split(string text, char separator) {
    stringstream stream(text);
    string tempText;
    vector<string> result;
    while (getline(stream, tempText, separator))
        result.push_back(tempText);

    return result;
}

string showTable(vector<string> unorganized, vector<string> titles, string link) {
    string body = utils::readFile("template/theme.html");

    vector<vector<string>> list;
    if (unorganized[0] != "Empty")
        for (auto& item : unorganized)
            list.push_back(split(item, ','));

    if (list.size() == 0)
        body += "<h1>Empty list</h1></div></body></html>";
    else {
        body += "<div class=\"table-container\"><table><thead><tr>";
        for (auto& title : titles)
            body += "<th>" + title + "</th>";
        body += "</tr></thead><tbody> ";
        for (auto& item : list) {
            body += "<tr>";
            for (int i = 0; i < list[0].size(); i++)
                body += "<td><a href= \"" + link + item[0] + "\">" + item[i] + "</a></td>";
            body += "</tr>";
        }
        body += "</tbody></table></div></div></body></html>";
    }

    return body;
}