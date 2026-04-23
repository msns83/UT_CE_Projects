#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[]) {
    printf(1, "Barber: Starting work day\n");
    
    while(1) {
        if(barber_sleep() < 0) {
            printf(1, "Barber: Error sleeping\n");
            break;
        }
        
        if(cut_hair() < 0) {
            printf(1, "Barber: Error cutting hair\n");
            break;
        }
        
        printf(1, "Barber: Ready for next customer\n");
    }
    
    printf(1, "Barber: End of work day\n");
    exit();
}
