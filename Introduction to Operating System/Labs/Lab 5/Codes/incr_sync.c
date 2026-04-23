#include "types.h"
#include "stat.h"
#include "user.h"
#include "shm.h"

#define ID     1
#define NITER  1000
#define PGSIZE          4096 

int
main(void) {
  if(monitor_init(ID, PGSIZE, 0) < 0){
    printf(1, "monitor_init failed\n");
    exit();
  }
  if(fork() == 0){
    for(int i = 0; i < NITER; i++){
      monitor_increase_all(ID);
    }
    exit();
  }
  for(int i = 0; i < NITER; i++){
    monitor_increase_all(ID);
  }
  wait();

  int buf[PGSIZE/sizeof(int)];
  if(monitor_read(ID, buf) < 0){
    printf(1, "monitor_read failed\n");
    exit();
  }
  printf(1, "sync   final = %d (expected %d)\n", buf[0], 2*NITER);
  monitor_close(ID);
  exit();
}