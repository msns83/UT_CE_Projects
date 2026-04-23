#include "types.h"
#include "stat.h"
#include "user.h"

#define ID     1
#define NITER  1000

int
main(void) {
  int *p = (int*)open_shared_mem(ID);
  if(p == (int*)-1){
    printf(1, "open_shared_mem failed\n");
    exit();
  }
  *p = 0;
  if(fork() == 0){
    for(int i = 0; i < NITER; i++){
      *p = *p + 1;      
    }
    exit();
  }
  for(int i = 0; i < NITER; i++){
    *p = *p + 1;
  }
  wait();
  printf(1,"nosync final = %d (expected %d)\n", *p, 2*NITER);
  close_shared_mem(ID);
  exit();
}