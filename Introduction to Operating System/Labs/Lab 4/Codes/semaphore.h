#ifndef SEMAPHORE_H
#define SEMAPHORE_H

#include "spinlock.h"

#define MAX_SEMAPHORES 6
#define MAX_WAITING 10

struct semaphore {
    struct spinlock lock;
    int value;
    int waiting_count;
    int waiting_pids[MAX_WAITING];
    int used;
};

struct barber_semaphores {
    struct semaphore customers;
    struct semaphore barber;
    struct semaphore mutex;
    struct semaphore customer_done;
    struct semaphore barber_done;
    struct semaphore waiting_room;
};

extern struct barber_semaphores barber_sems;

void seminit(void);
void sem_init(struct semaphore *sem, int value);
void sem_wait(struct semaphore *sem);
void sem_signal(struct semaphore *sem);
int sem_trywait(struct semaphore *sem);

#endif