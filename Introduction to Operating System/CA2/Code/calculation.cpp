#include <bits/stdc++.h>
using namespace std;

struct Game {
  string title;
  double orig, disc;
  double allCnt, recCnt;
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

int main(){

  string raw_data, line;
  char buf[32000];

  while(true){
    int read_size = read(STDIN_FILENO, buf, sizeof(buf));
    if(read_size <= 0)
      break;
    raw_data.append(buf, read_size);
  }

  istringstream is(raw_data);
  getline(is,line);

  auto statics_data = parse_csv(line);
  array<pair<double,double>,6> statics;

  for(int i=0 ; i < 6; i++){
    statics[i].first  = stod(statics_data[2*i]);
    statics[i].second = stod(statics_data[2*i+1]);
  }

  vector<Game> data_item;
  while(getline(is,line)){
    if(line.empty()) 
      continue;

    auto string_data = parse_csv(line);

    Game game_item;
    game_item.title = string_data[0];
    game_item.orig = stod(string_data[1]);
    game_item.disc = stod(string_data[2]);
    game_item.allCnt = stod(string_data[3]);
    game_item.recCnt = stod(string_data[4]);
    game_item.allScore = stod(string_data[5]);
    game_item.recScore = stod(string_data[6]);
    data_item.push_back(game_item);
  }

  cout << fixed << setprecision(6);

  for(auto &game_item:data_item){
    array<double,6> vals = {
      game_item.orig, game_item.disc,
      game_item.allCnt, game_item.recCnt,
      game_item.allScore, game_item.recScore
    };

    for(int i = 0 ; i < 6 ; i++){
      auto [mn,mx] = statics[i];
      vals[i] = (mx>mn ? ((vals[i]-mn)/(mx-mn))+1 : 1.0);
    }

    double score = (10.0*vals[1]*vals[2]*vals[3]*vals[4]*vals[5])/ vals[0];
    cout << score << ',' << '"' << game_item.title << '"' << '\n';
  }
  
  return 0;
}