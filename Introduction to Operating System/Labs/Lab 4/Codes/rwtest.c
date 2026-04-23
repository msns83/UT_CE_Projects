#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[]) {
    int pid;
    
    printf(1, "Initializing Readers-Writers lock...\n");
    if (init_rw_lock() < 0) {
        printf(1, "Failed to initialize RW lock\n");
        exit();
    }
    
    printf(1, "Starting test with multiple processes...\n");
    
    // Test pattern: 19 (binary: 10011) = read, read, write, write
    // Test pattern: 13 (binary: 1101) = read, write, read
    // Test pattern: 7 (binary: 111) = write, write
    
    int patterns[] = {19, 13, 7, 25}; // Different patterns for testing
    int num_patterns = 4;
    
    for (int i = 0; i < num_patterns; i++) {
        pid = fork();
        if (pid == 0) {
            // Child process
            printf(1, "Child %d executing pattern %d\n", getpid(), patterns[i]);
            get_rw_pattern(patterns[i]);
            exit();
        } else if (pid < 0) {
            printf(1, "Fork failed\n");
            exit();
        }
    }
    
    for (int i = 0; i < num_patterns; i++) {
        wait();
    }
    
    printf(1, "All tests completed\n");
    exit();
}
