#ifndef RWLOCK_H
#define RWLOCK_H

#include "spinlock.h"

struct rwlock {
    struct spinlock lock;        // Protects the rwlock structure
    int readers;                 // Number of active readers
    int writers;                 // Number of active writers (0 or 1)
    int waiting_writers;         // Number of writers waiting
    int waiting_readers;         // Number of readers waiting
    void *read_queue;           // Queue for waiting readers
    void *write_queue;          // Queue for waiting writers
};

void init_rwlock(struct rwlock *rw);
void acquire_read_lock(struct rwlock *rw);
void release_read_lock(struct rwlock *rw);
void acquire_write_lock(struct rwlock *rw);
void release_write_lock(struct rwlock *rw);

#endif