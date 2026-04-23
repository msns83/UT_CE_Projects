#include <bits/stdc++.h>
#include <unistd.h>
using namespace std;

vector<string> parse_csv(const string &line) {
    vector<string> res; 
    string cur; 
    bool is_text = false;
  
    for (char c : line) {
      if (c == '"') 
        is_text = !is_text;
      else if (c == ',' && !is_text) {
        res.push_back(cur);
        cur.clear();
      } else {
        cur.push_back(c);
      }
    }
  
    res.push_back(cur);
    return res;
}

int main(int argc, char** argv) {

    int temp_index = 1;
    int in_fds_num = stoi(argv[temp_index++]);
    vector<int> in_fds(in_fds_num);
    for (int i = 0; i < in_fds_num; i++)
        in_fds[i] = stoi(argv[temp_index++]);

    vector<pair<double,string>> records;
    char buf[32000];

    for (int fd : in_fds) {
        string string_data;

        while (true) {
            ssize_t r = read(fd, buf, sizeof(buf));
            if (r <= 0) break;
            string_data.append(buf, r);
        }
        close(fd);

        istringstream is(string_data);
        string line;

        while (getline(is, line)) {
            if (line.empty())
                continue;

            auto raw_data = parse_csv(line);
            
            double score = stod(raw_data[0]);
            string title = raw_data[1];

            records.emplace_back(score, title);
        }
    }

    sort(records.begin(), records.end(), [](auto &a, auto &b){ return a.first > b.first; });

    ofstream out("GameRanking.csv");
    out << "Title,Score\n" << fixed << setprecision(6);

    for (auto &game_item : records)
        out << game_item.second << "," << game_item.first << "\n";
    
    return 0;
}
