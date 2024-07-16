#include <stdio.h>
#include <stdlib.h>

int main(){
    int* a;
    a = (int*)malloc(100*sizeof(int));
    for (int i = 0; i < 100; i++)
        a[i] = 3 * i + 1;
    printf("%d\n", a);
    printf("%d\n", (a+4));
    printf("%d\n", *(a+4));
    printf("%d\n", a[99]);
    printf("%d\n", &a[99]);
    printf("%d\n", &a[99]+2);
}