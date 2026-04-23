#include <bits/stdc++.h>
#include <unistd.h>
#include <poll.h>
using namespace std;

struct Game {
    string title;
    double orig, disc;
    double allCnt, recCnt ;
    double allScore, recScore;
};

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

    int out_fds_num = stoi(argv[temp_index++]);
    vector<int> out_fds(out_fds_num);
    for (int i = 0; i < out_fds_num; i++)
        out_fds[i] = stoi(argv[temp_index++]);


    vector<string> raw_data(in_fds_num);
    vector<pollfd> poll_fds(in_fds_num);

    for (int i = 0; i < in_fds_num; i++) {
        poll_fds[i].fd = in_fds[i];
        poll_fds[i].events = POLLIN | POLLHUP;
        poll_fds[i].revents = 0;
    }

    int remaining = in_fds_num;
    char buf[32000];
    while (remaining > 0) {

        int req_fd = poll(poll_fds.data(), in_fds_num, -1);
        if (req_fd < 0) { 
            perror("poll"); 
            break; 
        }

        for (int i = 0; i < in_fds_num; i++) {
            if (poll_fds[i].fd < 0) 
                continue;

            if (poll_fds[i].revents & POLLIN) {
                ssize_t r = read(poll_fds[i].fd, buf, sizeof(buf));
                if (r > 0)
                    raw_data[i].append(buf, r);
            }

            if (poll_fds[i].revents & (POLLHUP | POLLERR)) {
                close(poll_fds[i].fd);
                poll_fds[i].fd = -1;
                remaining--;
            }
            poll_fds[i].revents = 0;
        }
    }

    vector<Game> data;
    for (auto &chunk : raw_data) {
        istringstream is(chunk);
        string line;
        while (getline(is, line)) {
            if (line.empty()) 
                continue;
            auto f = parse_csv(line);

            Game game_item;
            game_item.title = f[0];
            game_item.orig = stod(f[1]);
            game_item.disc = stod(f[2]);
            game_item.allCnt = stod(f[3]);
            game_item.recCnt = stod(f[4]);
            game_item.allScore = stod(f[5]);
            game_item.recScore = stod(f[6]);
            data.push_back(game_item);
        }
    }

    struct minimax { 
        double mn, mx; 
    };
    
    array<minimax, 6> statics;

    for (int i = 0; i < 6; i++) {
        statics[i].mn = 1e300;
        statics[i].mx = -1e300;
    }

    for (const auto &game_item : data) {
        statics[0].mn = min(statics[0].mn, game_item.orig);
        statics[0].mx = max(statics[0].mx, game_item.orig);

        statics[1].mn = min(statics[1].mn, game_item.disc);
        statics[1].mx = max(statics[1].mx, game_item.disc);

        statics[2].mn = min(statics[2].mn, game_item.allCnt);
        statics[2].mx = max(statics[2].mx, game_item.allCnt);

        statics[3].mn = min(statics[3].mn, game_item.recCnt);
        statics[3].mx = max(statics[3].mx, game_item.recCnt);

        statics[4].mn = min(statics[4].mn, game_item.allScore);
        statics[4].mx = max(statics[4].mx, game_item.allScore);

        statics[5].mn = min(statics[5].mn, game_item.recScore);
        statics[5].mx = max(statics[5].mx, game_item.recScore);
    }

    int N = data.size();
    int base = N / out_fds_num;
    int rem = N % out_fds_num ;
    int pos = 0;

    for (int i = 0; i < out_fds_num; i++) {
        ostringstream os;
        
        for (int j = 0; j < 6; j++)
            os << statics[j].mn << ',' << statics[j].mx << (j+1<6 ? ',' : '\n');

        int items_count = base + (i < rem);

        for (int k = 0; k < items_count; k++) {
            auto &game_item = data[pos++];
            os << '"' << game_item.title << '"' << ',' << game_item.orig
               << ',' << game_item.disc << ',' << game_item.allCnt
               << ',' << game_item.recCnt << ',' << game_item.allScore
               << ',' << game_item.recScore << '\n';
        }
        string out = os.str();

        write(out_fds[i], out.c_str(), out.size());
        close(out_fds[i]);
    }

    return 0;
}