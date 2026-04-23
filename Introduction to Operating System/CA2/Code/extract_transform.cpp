#include <bits/stdc++.h>
#include <unistd.h>
#include <sys/wait.h>
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

double parse_price(const string &s) {
    string num;

    for (char c : s)
      if (isdigit(c) || c == '.')
        num.push_back(c);

    return num.empty() ? 0.0 : stod(num);
}

double parse_number(const string &s) {
  string num;
  for (char c : s) {
    if (isdigit(c)) 
      num.push_back(c);
    else if (c == '%')
      num.clear();
    else if (!num.empty())
      break;
  }
      
  return num.empty() ? 0 : stod(num);
}

void do_transformation(int read_fd) {
  dup2(read_fd, STDIN_FILENO);
  close(read_fd);

  unordered_map<string,int> rev = {
    {"Overwhelmingly Positive",7}, {"Very Positive",6},
    {"Positive",5}, {"Mostly Positive",4},
    {"Mixed",3}, {"Mostly Negative",2},
    {"Overwhelmingly Negative",1}
  };

  string header;
  if (!getline(cin, header)) 
    exit(1);

  string line;
  while (getline(cin, line)) {
    if (line.empty()) 
      continue;

    auto row_data = parse_csv(line);
    double disc_val = parse_price(row_data[2]);
    double orig_val = parse_price(row_data[1]) ;
        
    cout << '"' << row_data[0] << '"' << ',' << orig_val
          << ',' << ((orig_val - disc_val > 0) ? ((orig_val - disc_val)/orig_val)*100 : 1)
          << ',' << parse_number(row_data[8])
          << ',' << parse_number(row_data[7])
          << ',' << rev[row_data[6]]
          << ',' << rev[row_data[5]] << '\n';
    
  }
  
  exit(0);
}

int main(int argc, char** argv) {

  if (argc != 2) {
    cerr << "Enter csv file name\n";
    return 1;
  }

  string file_path = argv[1];

  int ex2tr_pipe[2];
  if (pipe(ex2tr_pipe) < 0) { 
    perror("pipe ex2tr faild"); 
    return 1; 
  }

  pid_t pid = fork();

  if (pid < 0) { 
    perror("fork"); 
    return 1; 
  }

  if (pid == 0) {
    close(ex2tr_pipe[1]);
    do_transformation(ex2tr_pipe[0]);
  } else {
    close(ex2tr_pipe[0]);
    dup2(ex2tr_pipe[1], STDOUT_FILENO);
    close(ex2tr_pipe[1]);

    ifstream file_data(file_path);
    if (!file_data) {
      cerr << "Can not open " << file_path << "\n";
      return 1;
    }

    string line;
    while (getline(file_data, line)) {
      cout << line << "\n";
    }
    cout.flush();

    close(STDOUT_FILENO);
    wait(nullptr);
  }

  return 0;
}