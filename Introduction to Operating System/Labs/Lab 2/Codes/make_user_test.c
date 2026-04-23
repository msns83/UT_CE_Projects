#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{

  int ret;
  printf(1, "Creating users...\n");
  
  ret = make_user(1, "password1");
  printf(1, "Create user 1: %s\n", ret == 0 ? "SUCCESS" : "FAILED");
  
  ret = make_user(2, "password2");
  printf(1, "Create user 2: %s\n", ret == 0 ? "SUCCESS" : "FAILED");
  
  ret = make_user(1, "password3");
  printf(1, "Create duplicate user: %s (expected to fail)\n", ret == 0 ? "SUCCESS" : "FAILED");
  
  printf(1, "\nTesting login...\n");
  
  ret = login(1, "password1");
  printf(1, "Login user 1: %s\n", ret == 0 ? "SUCCESS" : "FAILED");
  
  ret = login(2, "password2");
  printf(1, "Login while logged in: %s (expected to fail)\n", ret == 0 ? "SUCCESS" : "FAILED");
  
  printf(1, "\nGetting system call log for current user...\n");
  get_log();
  
  printf(1, "\nTesting logout...\n");
  ret = logout();
  printf(1, "Logout: %s\n", ret == 0 ? "SUCCESS" : "FAILED");

  ret = login(2, "wrong_password");
  printf(1, "Login with wrong password: %s (expected to fail)\n", ret == 0 ? "SUCCESS" : "FAILED");
  
  ret = login(2, "password2");
  printf(1, "Login user 2: %s\n", ret == 0 ? "SUCCESS" : "FAILED");

  printf(1, "\nGetting system call log for user 2...\n");
  get_log();

  ret = logout();
  printf(1, "\nLogout: %s\n", ret == 0 ? "SUCCESS" : "FAILED");
  
  printf(1, "\nGetting global system call log...\n");
  get_log();
  

  ret = login(1, "password1");
  get_log();

  printf(1, "\nUser management test complete.\n");
  exit();
}