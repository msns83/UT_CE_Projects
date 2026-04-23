#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "semaphore.h"
#include "spinlock.h"

static int customer_count = 0;
static struct spinlock customer_lock;

// This is borrowed from proc.c to access ptable
extern struct {
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;

int
sys_fork(void)
{
  return fork();
}

int
sys_rt_fork(void)
{
  int rel;
  if(argint(0, &rel) < 0)
    return -1;

  return rt_fork(rel); 
}

int
sys_set_class(void)
{
  int pid, cls;
  if(argint(0, &pid) < 0 || argint(1, &cls) < 0)
    return -1;
  return set_class(pid, cls);   
}

int
sys_ps(void)
{
  ps();
  return 0;
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

int
sys_set_sleep(void)
{
  int n;
  uint ticks0;
  struct proc *p = myproc();
  
  if(argint(0, &n) < 0)
    return -1;
  
  acquire(&tickslock);
  ticks0 = ticks;
  
  while(ticks - ticks0 < n){
    if(p->killed){
      release(&tickslock);
      return -1;
    }
    
    // We need to release tickslock before acquiring ptable.lock to avoid deadlock
    release(&tickslock);
    
    // Acquire ptable.lock before changing process state
    acquire(&ptable.lock);
    
    // Check if we need to sleep again - reacquire tickslock to check
    acquire(&tickslock);
    if(ticks - ticks0 >= n){
      // Time has elapsed while we were acquiring locks
      release(&tickslock);
      release(&ptable.lock);
      break;
    }
    
    // Mark process as sleeping on ticks
    p->chan = &ticks;
    p->state = SLEEPING;
    
    // Release tickslock before calling scheduler
    release(&tickslock);
    
    // Now we only hold ptable.lock as required by sched()
    sched();
    
    // When we return from scheduler, we need to reacquire tickslock
    acquire(&tickslock);
    
    // Release ptable.lock since we're done with it
    release(&ptable.lock);
  }
  
  release(&tickslock);
  return 0;
}

int
sys_getcmostime(void)
{
  struct rtcdate *r;
  
  if(argptr(0, (char**)&r, sizeof(*r)) < 0)
    return -1;
  
  cmostime(r);
  return 0;
}

int
next_palindrome(int num)
{
    num++;
    while (1) {
        int reversed = 0, original = num;
        while (original > 0) {
            reversed = reversed * 10 + original % 10;
            original /= 10;
        }
        if (reversed == num)
            return num;
        num++;
    }
}

int
sys_next_palindrome(void)
{
    int num;
    if (argint(0, &num) < 0)
        return -1;
    return next_palindrome(num);
}

void customer_lock_init(void) {
    initlock(&customer_lock, "customer_count");
}

int sys_barber_sleep(void) {
    cprintf("Barber: Going to sleep (no customers)\n");
    sem_wait(&barber_sems.customers);
    
    cprintf("Barber: Woken up by customer\n");
    return 0;
}

int sys_customer_arrive(void) {
    struct proc *curproc = myproc();
    
    if(sem_trywait(&barber_sems.waiting_room) == -1) {
        cprintf("Customer %d: No chairs available, leaving\n", curproc->pid);
        return -1;
    }
    
    cprintf("Customer %d: Entered barbershop\n", curproc->pid);
    
    sem_wait(&barber_sems.mutex);
    
    acquire(&customer_lock);
    customer_count++;
    int current_customer = customer_count;
    release(&customer_lock);
    
    if(sem_trywait(&barber_sems.barber) == 0) {
        cprintf("Customer %d: Waking up barber\n", curproc->pid);
        sem_signal(&barber_sems.customers);
        sem_signal(&barber_sems.mutex);
        
        cprintf("Customer %d: Getting haircut\n", curproc->pid);
        return current_customer;
    }
    
    cprintf("Customer %d: Barber busy, waiting in chair\n", curproc->pid);
    sem_signal(&barber_sems.customers);
    sem_signal(&barber_sems.mutex);
    
    sem_wait(&barber_sems.barber);
    cprintf("Customer %d: My turn for haircut\n", curproc->pid);
    
    return current_customer;
}

int sys_cut_hair(void) {
    cprintf("Barber: Cutting hair...\n");
    
    for(int i = 0; i < 1000000; i++) {
        asm volatile("nop");
    }
    
    cprintf("Barber: Finished cutting hair\n");
    
    sem_signal(&barber_sems.customer_done);
    
    sem_wait(&barber_sems.barber_done);
    
    sem_signal(&barber_sems.waiting_room);
    
    sem_signal(&barber_sems.barber);
    
    return 0;
}

int sys_customer_wait_haircut(void) {
    struct proc *curproc = myproc();
    
    sem_wait(&barber_sems.customer_done);
    
    cprintf("Customer %d: Haircut complete, leaving\n", curproc->pid);
    
    sem_signal(&barber_sems.barber_done);
    
    return 0;
}

int sys_open_shared_mem(void){
  int id; 
  if(argint(0,&id)<0) return -1;
  char *p = shm_open(id);
  if(!p) return -1;
  int va = PGROUNDUP(myproc()->sz);
  if(mappages(myproc()->pgdir, va, PGSIZE, (int)V2P(p), PTE_W|PTE_U)<0) return -1;
  myproc()->sz = va+PGSIZE;
  return va;
}

int
sys_close_shared_mem(void){
  int id; 
  if(argint(0,&id)<0) return -1;
  return shm_close(id);
}

int sys_monitor_init(void){
  int id, sz, initv;
  if(argint(0,&id)<0||argint(1,&sz)<0||argint(2,&initv)<0) return -1;
  return mon_init(id,sz,initv);
}
int sys_monitor_increase_all(void){
  int id; argint(0,&id);
  return mon_increase(id);
}
int sys_monitor_read(void){
  int id;
  char *buf;
  if(argint(0, &id) < 0 || argptr(1, &buf, PGSIZE) < 0)
    return -1;
  return mon_read(id, (int*)buf);
}
int sys_monitor_close(void){
  int id; argint(0,&id);
  return mon_close(id);
}
