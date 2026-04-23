#include "types.h"
#include "stat.h"
#include "user.h"

#define N_EDF 3
#define N_RR 3
#define N_FCFS 3
#define ITERS 3
#define LITERS 3  
#define BUSYLOOP 10000000
#define LBUSYLOOP 200000000

static void busywait(void) {
    for(volatile int i = 0; i < BUSYLOOP; i++);
}

static void longbusywait(void) {
    int x = 2;
    for(volatile int i = 0 ; i < LBUSYLOOP; i++)
        x = (x*x)-(x*2) * 33 ;
}

int main(int argc, char *argv[]) {
    int pid_count = getpid() + 1 ;
    int rel_deadlines[N_EDF] = {100, 3, 20};

    printf(1,"User changed schedule class\n");
    set_class(getpid(),1); 
    printf(1,"Main process -> real-time, deadline: 1, pid: %d \n", getpid());

    for(int i = 0; i < N_RR; i++){
        printf(1,"New Noraml process (going to be Critical) -> pid: %d\n", pid_count++);
        int pid = fork();
        if(pid < 0){
            printf(1,"classtest: fork failed\n");
            exit();
        }
        if(pid == 0){
            for(int j = 0; j < ITERS; j++){
                printf(1, "NORMAL pid %d  iter %d\n", getpid(), j);
                busywait();
            }
            ps();
            exit();
        }
    }

    for(int i = 0; i < N_EDF; i++) {
        printf(1,"New real-time process -> pid: %d, deadline: %d\n", pid_count++, rel_deadlines[i]);
        int pid = rt_fork(rel_deadlines[i]);

        if(pid < 0){
            printf(1, "classtest: rt_fork failed\n");
            exit();
        }   

        if(pid == 0){
            for(int j = 0; j < LITERS; j++){
                printf(1, "REAL-TIME pid %d  iter %d\n", getpid(), j);
                longbusywait();
            }
            ps();
            exit();
        }

    }

    ps();
    for(int i = 0; i < N_EDF + N_RR; i++){
        wait();
    }

    for(int i = 0; i < N_FCFS; i++){
        printf(1,"New Noraml process -> pid: %d\n", pid_count++);
        int pid = fork();
        if(pid < 0){
            printf(1,"classtest: fork failed\n");
            exit();
        }
        if(pid == 0){
            for(int j = 0; j < ITERS; j++){
                printf(1, "NORMAL pid %d  iter %d\n", getpid(), j);
                busywait();
            }
            ps();
            exit();
        }
    }

    ps();
    for(int i = 0; i < N_FCFS; i++){
        wait();
    }

    ps();
    exit();
}