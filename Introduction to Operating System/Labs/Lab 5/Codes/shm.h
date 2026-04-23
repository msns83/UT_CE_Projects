#ifndef XV6_SHM_H
#define XV6_SHM_H

#include "spinlock.h"
#define SHM_MAX 16

struct shm_entry {
  int id;              
  char *phys;          
  int refcnt;        
  struct spinlock lock;
};

void shm_init(void);
char *shm_open(int id);
int shm_close(int id);

int mon_init(int id, int size, int initval);
int mon_increase(int id);
int mon_read(int id, int *user_buf);
int mon_close(int id);

#endif