#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"
#include "semaphore.h"

struct barber_semaphores barber_sems;

void seminit(void) {
    sem_init(&barber_sems.customers, 0);
    sem_init(&barber_sems.barber, 0);
    sem_init(&barber_sems.mutex, 1);
    sem_init(&barber_sems.customer_done, 0);
    sem_init(&barber_sems.barber_done, 0);
    sem_init(&barber_sems.waiting_room, 5);
}

void sem_init(struct semaphore *sem, int value) {
    initlock(&sem->lock, "semaphore");
    sem->value = value;
    sem->waiting_count = 0;
    sem->used = 1;
    for(int i = 0; i < MAX_WAITING; i++) {
        sem->waiting_pids[i] = -1;
    }
}

void sem_wait(struct semaphore *sem) {
    struct proc *curproc = myproc();
    
    acquire(&sem->lock);
    
    if(sem->value > 0) {
        sem->value--;
        release(&sem->lock);
        return;
    }
    
    if(sem->waiting_count < MAX_WAITING) {
        sem->waiting_pids[sem->waiting_count] = curproc->pid;
        sem->waiting_count++;
    }

    sleep(sem, &sem->lock);

    sem->value--;
    release(&sem->lock);
}

void sem_signal(struct semaphore *sem) {
    acquire(&sem->lock);
    
    sem->value++;
    
    if(sem->waiting_count > 0) {
        int wake_pid = sem->waiting_pids[0];
        for(int i = 0; i < sem->waiting_count - 1; i++) {
            sem->waiting_pids[i] = sem->waiting_pids[i + 1];
        }
        sem->waiting_count--;
        sem->waiting_pids[sem->waiting_count] = -1;
        
        wakeup(sem);
    }
    
    release(&sem->lock);
}

int sem_trywait(struct semaphore *sem) {
    acquire(&sem->lock);
    
    if(sem->value > 0) {
        sem->value--;
        release(&sem->lock);
        return 0;
    }
    
    release(&sem->lock);
    return -1;
}