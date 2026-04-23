#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "spinlock.h"

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
