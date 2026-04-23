#include "types.h"
#include "user.h"

int main(void) {
    int pid = getpid();
    printf(1, "Process ID: %d\n", pid);
    exit();
}