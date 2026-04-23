#include "types.h"
#include "stat.h" 
#include "user.h"

int main(int argc, char *argv[]) {
    int customer_id = getpid();
    
    printf(1, "Customer %d: Approaching barbershop\n", customer_id);
    
    int result = customer_arrive();
    
    if(result < 0) {
        printf(1, "Customer %d: Barbershop full, going home\n", customer_id);
        exit();
    }
    
    printf(1, "Customer %d: In barbershop (customer #%d)\n", customer_id, result);
    
    if(customer_wait_haircut() < 0) {
        printf(1, "Customer %d: Error during haircut\n", customer_id);
        exit();
    }
    
    printf(1, "Customer %d: Satisfied with haircut, going home\n", customer_id);
    exit();
}