#include <stdio.h>
#define PI 3.1416

int main() {
    float r, result;
    printf("please enter the radius:\n");
    scanf("%f" , &r);
    result = PI*(r*r);
    printf("\nS= %.3f\n" , result);
    return 0;
}