#include "types.h"
#include "stat.h"
#include "user.h"

#define NUM_CUSTOMERS 10
#define CUSTOMER_DELAY 100000

void delay(int cycles) {
    for(int i = 0; i < cycles; i++) {
        asm volatile("nop");
    }
}

int main(int argc, char *argv[]) {
    int barber_pid;
    int customer_pids[NUM_CUSTOMERS];
    struct stat st;
    
    printf(1, "=== Sleeping Barber Problem Simulation ===\n");
    printf(1, "Barbershop has 5 waiting chairs\n");
    printf(1, "Testing with %d customers\n\n", NUM_CUSTOMERS);
    
    if(stat("barber", &st) < 0) {
        printf(1, "Error: barber program not found!\n");
        printf(1, "Make sure 'barber' is compiled and available.\n");
        printf(1, "Try running: make clean && make\n");
        exit();
    }
    
    if(stat("customer", &st) < 0) {
        printf(1, "Error: customer program not found!\n");
        printf(1, "Make sure 'customer' is compiled and available.\n");
        printf(1, "Try running: make clean && make\n");
        exit();
    }
    
    printf(1, "Both programs found. Starting simulation...\n\n");
    
    barber_pid = fork();
    if(barber_pid == 0) {
        char *args[] = {"barber", 0};
        if(exec("barber", args) < 0) {
            printf(1, "Error: Could not exec barber (exec failed)\n");
            exit();
        }
    } else if(barber_pid < 0) {
        printf(1, "Error: Could not fork barber process\n");
        exit();
    }
    
    printf(1, "Barber process started (PID: %d)\n", barber_pid);
    
    delay(CUSTOMER_DELAY);
    
    for(int i = 0; i < NUM_CUSTOMERS; i++) {
        customer_pids[i] = fork();
        
        if(customer_pids[i] == 0) {
            char *args[] = {"customer", 0};
            if(exec("customer", args) < 0) {
                printf(1, "Error: Could not exec customer %d (exec failed)\n", i+1);
                exit();
            }
        } else if(customer_pids[i] < 0) {
            printf(1, "Error: Could not fork customer %d\n", i+1);
            continue;
        }
        
        printf(1, "Customer %d process started (PID: %d)\n", i+1, customer_pids[i]);
        
        delay(CUSTOMER_DELAY / 2);
    }
    
    printf(1, "\nAll customers dispatched. Waiting for completion...\n\n");
    
    int completed_customers = 0;
    for(int i = 0; i < NUM_CUSTOMERS; i++) {
        if(customer_pids[i] > 0) {
            wait();
            completed_customers++;
        }
    }
    
    printf(1, "\n%d customers completed. Terminating barber...\n", completed_customers);
    
    kill(barber_pid);
    wait();
    
    printf(1, "=== Simulation Complete ===\n");
    exit();
}