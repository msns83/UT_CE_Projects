#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"
#include "rwlock.h"

// shared data
static struct rwlock global_rwlock;
static int shared_data = 0;
static int initialized = 0;

// Initialize rw lock
void init_rwlock(struct rwlock *rw) {
    initlock(&rw->lock, "rwlock");
    rw->readers = 0;
    rw->writers = 0;
    rw->waiting_writers = 0;
    rw->waiting_readers = 0;
    rw->read_queue = 0;
    rw->write_queue = 0;
}

void acquire_read_lock(struct rwlock *rw) {
    acquire(&rw->lock);
    
    while (rw->writers > 0 || rw->waiting_writers > 0) {
        rw->waiting_readers++;
        sleep(rw, &rw->lock);
        rw->waiting_readers--;
    }
    
    rw->readers++;
    release(&rw->lock);
}

void release_read_lock(struct rwlock *rw) {
    acquire(&rw->lock);
    rw->readers--;

    if (rw->readers == 0 && rw->waiting_writers > 0) {
        wakeup(rw);
    }
    
    release(&rw->lock);
}

void acquire_write_lock(struct rwlock *rw) {
    acquire(&rw->lock);
    
    // Wait while there are active readers or writers
    while (rw->readers > 0 || rw->writers > 0) {
        rw->waiting_writers++;
        sleep(rw, &rw->lock);
        rw->waiting_writers--;
    }
    
    rw->writers = 1;
    release(&rw->lock);
}

void release_write_lock(struct rwlock *rw) {
    acquire(&rw->lock);
    rw->writers = 0;
    
    // Wake up all waiting processes (writers have priority)
    wakeup(rw);
    
    release(&rw->lock);
}

int sys_init_rw_lock(void) {
    if (!initialized) {
        init_rwlock(&global_rwlock);
        shared_data = 0;
        initialized = 1;
        cprintf("Readers-Writers lock initialized\n");
        return 0;
    }
    return -1;
}


int sys_get_rw_pattern(void) {
    int pattern;
    
    if (argint(0, &pattern) < 0)
        return -1;
    
    if (!initialized) {
        cprintf("Error: RW lock not initialized\n");
        return -1;
    }
    
    cprintf("Process %d starting pattern execution: %d (binary: ", myproc()->pid, pattern);

    int temp = pattern;
    int bits[32];
    int bit_count = 0;
    
    if (temp == 0) {
        cprintf("0");
        bit_count = 1;
    } else {
        while (temp > 0) {
            bits[bit_count] = temp & 1;
            temp >>= 1;
            bit_count++;
        }
        
        // Print from most significant bit to least significant bit
        for (int i = bit_count - 1; i >= 0; i--) {
            cprintf("%d", bits[i]);
        }
    }
    cprintf(")\n");
    
    // Execute pattern from left to right (most significant bit first)
    // Skip the most significant bit as it's always 1 for positive numbers
    for (int i = bit_count - 2; i >= 0; i--) {
        if (bits[i] == 0) {
            
            // Read operation
            cprintf("Process %d: Acquiring READ lock\n", myproc()->pid);
            acquire_read_lock(&global_rwlock);
            
            cprintf("Process %d: Reading shared_data = %d\n", myproc()->pid, shared_data);
            
            // Simulate some read work
            for (int j = 0; j < 1000000; j++);
            
            cprintf("Process %d: Releasing READ lock\n", myproc()->pid);
            release_read_lock(&global_rwlock);
            
        } else {
            // Write operation
            cprintf("Process %d: Acquiring WRITE lock\n", myproc()->pid);
            acquire_write_lock(&global_rwlock);
            
            int old_value = shared_data;
            shared_data++;
            cprintf("Process %d: Writing shared_data: %d -> %d\n", myproc()->pid, old_value, shared_data);
            
            // Simulate some write work
            for (int j = 0; j < 1000000; j++);
            
            cprintf("Process %d: Releasing WRITE lock\n", myproc()->pid);
            release_write_lock(&global_rwlock);
        }
        
        // Small delay between operations
        for (int j = 0; j < 100000; j++);
    }
    
    cprintf("Process %d: Pattern execution completed\n", myproc()->pid);
    return 0;
}