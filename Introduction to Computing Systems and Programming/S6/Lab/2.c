#include <stdio.h>
#define SIZE 4

int main () {
    int i, sum = 0;
    int num[SIZE];

    printf("Enter %d numbers: \n", SIZE);

    for (i = 0; i < SIZE; i++)
    scanf ("%d", num+i); /* Complete this instruction */

    for (i = 0; i < SIZE; i++)
    sum += *(num+i) ; /* Complete this instruction */

    printf("Sum: %d\n", sum);
    return 0;
}