#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"
#include "syscall.h"

struct user users[MAX_USERS];
struct syscall_log syscall_logs[MAX_USERS][MAX_LOG_ENTRIES];
int log_indices[MAX_USERS]; // Tracks the current position in each users log
int global_log[MAX_LOG_ENTRIES]; // For when no user is logged in
int global_log_index = 0;
struct spinlock user_lock;

void
userinit_extra(void)
{
  initlock(&user_lock, "user");
  
  for(int i = 0; i < MAX_USERS; i++) {
    users[i].valid = 0;
    log_indices[i] = 0;
  }
}

int
find_user(int user_id)
{
  for(int i = 0; i < MAX_USERS; i++) {
    if(users[i].valid && users[i].user_id == user_id)
      return i;
  }
  return -1;
}

int
make_user(int user_id, const char* password)
{
  int i;
  
  acquire(&user_lock);

  if(find_user(user_id) >= 0) {
    release(&user_lock);
    return -1;
  }

  for(i = 0; i < MAX_USERS; i++) {
    if(users[i].valid == 0)
      break;
  }
  
  if(i == MAX_USERS) {
    release(&user_lock);
    return -1;
  }
  
  users[i].user_id = user_id;
  strncpy(users[i].password, password, MAX_PASSWORD_LEN-1);
  users[i].password[MAX_PASSWORD_LEN-1] = '\0';
  users[i].valid = 1;
  log_indices[i] = 0;
  
  release(&user_lock);
  return 0;
}

int
login_user(int user_id, const char* password)
{
  struct proc *p = myproc();
  int user_index;
  
  acquire(&user_lock);
  
  user_index = find_user(user_id);
  if(user_index < 0) {
    release(&user_lock);
    return -1;
  }

  if(strncmp(users[user_index].password, password, MAX_PASSWORD_LEN) != 0) {
    release(&user_lock);
    return -1;
  }
  
  if(p->logged_in_user != -1) {
    release(&user_lock);
    return -1;
  }

  p->logged_in_user = user_id;
  
  release(&user_lock);
  return 0;
}

int
logout_user(void)
{
  struct proc *p = myproc();
  
  acquire(&user_lock);
  
  // Check if a user is logged in
  if(p->logged_in_user == -1) {
    release(&user_lock);
    return -1;
  }

  int user_index = find_user(p->logged_in_user);
  if(user_index >= 0) {
    syscall_logs[user_index][log_indices[user_index]].syscall_num = SYS_logout;
    syscall_logs[user_index][log_indices[user_index]].pid = 1;
    log_indices[user_index] = (log_indices[user_index] + 1) % MAX_LOG_ENTRIES;
  }
  
  p->logged_in_user = -1;
  
  release(&user_lock);
  return 0;
}

void
log_syscall(int num)
{
  struct proc *p = myproc();
  int user_index;
  
  acquire(&user_lock);
  
  if(p->logged_in_user != -1) {
    user_index = find_user(p->logged_in_user);
    if(user_index >= 0) {
      syscall_logs[user_index][log_indices[user_index]].syscall_num = num;
      syscall_logs[user_index][log_indices[user_index]].pid = 1;
      log_indices[user_index] = (log_indices[user_index] + 1) % MAX_LOG_ENTRIES;
    }
  }

  global_log[global_log_index] = num;
  global_log_index = (global_log_index + 1) % MAX_LOG_ENTRIES;
  
  release(&user_lock);
}

int
get_log(void)
{
  struct proc *p = myproc();
  int user_index;
  int i;
  
  acquire(&user_lock);
  
  if(p->logged_in_user != -1) {

    user_index = find_user(p->logged_in_user);
    if(user_index >= 0) {
      cprintf("System call log for user %d:\n", p->logged_in_user);
      for(i = 0; i < MAX_LOG_ENTRIES; i++) {
        int idx = (log_indices[user_index] - i - 1 + MAX_LOG_ENTRIES) % MAX_LOG_ENTRIES;
        if(syscall_logs[user_index][idx].syscall_num != 0) {
          cprintf("SysCall: %d\n", syscall_logs[user_index][idx].syscall_num);
        }
      }
    }
  } else {

    cprintf("Global system call log:\n");
    for(i = 0; i < MAX_LOG_ENTRIES; i++) {
      int idx = (global_log_index - i - 1 + MAX_LOG_ENTRIES) % MAX_LOG_ENTRIES;
      if(global_log[idx] != 0) {
        cprintf("SysCall: %d\n", global_log[idx]);
      }
    }
  }
  
  release(&user_lock);
  return 0;
}


int
sys_make_user(void)
{
  int user_id;
  char *password;

  if(argint(0, &user_id) < 0)
    return -1;
  if(argstr(1, &password) < 0)
    return -1;
  
  return make_user(user_id, password);
}

int
sys_login(void)
{
  int user_id;
  char *password;

  if(argint(0, &user_id) < 0)
    return -1;
  if(argstr(1, &password) < 0)
    return -1;
  
  return login_user(user_id, password);
}

int
sys_logout(void)
{
  return logout_user();
}

int
sys_get_log(void)
{
  return get_log();
}