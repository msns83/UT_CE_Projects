#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int check_braces(char *str) {
  int stack_count = 0;
  
  for (int i = 0; str[i] != '\0'; i++) {
    if (str[i] == '{') {
      stack_count++;
    } else if (str[i] == '}') {
      stack_count--;
      if (stack_count < 0) {
        return 0;
      }
    }
  }
  
  return stack_count == 0; 
}

int main(int argc, char *argv[]) {
  if (argc != 2) {
    printf(1, "Usage: %s string\n", argv[0]);
    exit();
  }
  
  int result = check_braces(argv[1]);
  
  int fd = open("result.txt", O_CREATE | O_WRONLY);
  if (fd < 0) {
    printf(1, "Error: Cannot open result.txt\n");
    exit();
  }
  
  if (result) {
    write(fd, "Right\n", 6);
  } else {
    write(fd, "Wrong\n", 6);
  }
  
  close(fd);
  exit();
}