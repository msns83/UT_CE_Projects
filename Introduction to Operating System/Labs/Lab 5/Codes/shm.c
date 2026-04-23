#include "types.h"
#include "defs.h"
#include "spinlock.h"
#include "mmu.h"
#include "proc.h"
#include "shm.h"

static struct {
  struct spinlock lock;
  struct shm_entry table[SHM_MAX];
} shm_table;

void
shm_init(void) {
  initlock(&shm_table.lock, "shm_table");
  for(int i=0; i<SHM_MAX; i++){
    initlock(&shm_table.table[i].lock, "shm_ent");
    shm_table.table[i].id = 0;
  }
}

static struct shm_entry*
find_entry(int id) {
  struct shm_entry *e;
  acquire(&shm_table.lock);
  // lookup
  for(int i=0;i<SHM_MAX;i++){
    if(shm_table.table[i].id==id){
      e=&shm_table.table[i];
      acquire(&e->lock);
      e->refcnt++;
      release(&e->lock);
      release(&shm_table.lock);
      return e;
    }
  }
  // allocate new
  for(int i=0;i<SHM_MAX;i++){
    if(shm_table.table[i].refcnt==0){
      e=&shm_table.table[i];
      e->id=id;
      e->phys=kalloc();
      if(!e->phys){ release(&shm_table.lock); return 0; }
      memset(e->phys,0,PGSIZE);
      e->refcnt=1;
      release(&shm_table.lock);
      return e;
    }
  }
  release(&shm_table.lock);
  return 0;
}

char*
shm_open(int id) {
  struct shm_entry *e = find_entry(id);
  return e ? e->phys : 0;
}

int
shm_close(int id) {
  struct shm_entry *e = 0;
  acquire(&shm_table.lock);
  for(int i=0;i<SHM_MAX;i++){
    if(shm_table.table[i].id==id){
      e=&shm_table.table[i];
      acquire(&e->lock);
      e->refcnt--;
      if(e->refcnt==0){
        kfree(e->phys);
        e->id=0;
      }
      release(&e->lock);
      break;
    }
  }
  release(&shm_table.lock);
  return e?0:-1;
}

// Monitor functions
int
mon_init(int id, int size, int initval) {
  if(size>PGSIZE) return -1;
  char *p = shm_open(id);
  if(!p) return -1;
  int *arr=(int*)p, n=size/sizeof(int);
  for(int i=0;i<n;i++) arr[i]=initval;
  return size;
}

int
mon_increase(int id) {
  acquire(&shm_table.lock);
  for(int i=0;i<SHM_MAX;i++){
    if(shm_table.table[i].id==id){
      struct shm_entry *e=&shm_table.table[i];
      acquire(&e->lock);
      int *a=(int*)e->phys; int n=PGSIZE/sizeof(int);
      for(int j=0;j<n;j++) a[j]++;
      release(&e->lock);
      break;
    }
  }
  release(&shm_table.lock);
  return 0;
}

int
mon_read(int id, int *user_buf) {
  acquire(&shm_table.lock);
  for(int i = 0; i < SHM_MAX; i++){
    if(shm_table.table[i].id == id){
      struct shm_entry *e = &shm_table.table[i];
      acquire(&e->lock);
      if(copyout(myproc()->pgdir, (uint)user_buf, e->phys, PGSIZE) < 0){
        release(&e->lock);
        release(&shm_table.lock);
        return -1;
      }
      release(&e->lock);
      break;
    }
  }
  release(&shm_table.lock);
  return 0;
}

int
mon_close(int id) {
  return shm_close(id);
}