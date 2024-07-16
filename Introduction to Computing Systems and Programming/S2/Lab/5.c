#include <stdio.h>

int main() {
    float x = 0.3;
    printf("%.30f\n", x + x + x + x + x + x + x + x + x + x);
    printf("%.5f\n", 10*x);
    return 0;
}