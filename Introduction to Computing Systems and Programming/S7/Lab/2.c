#include <stdio.h>
#include <stdlib.h>

int main() {
    int* p = (int*)malloc(10 * sizeof(int));
    int i;

    printf("P = %p\n", p);

    for (i = 0; i < 10; i++) {
        p[i] = i;
    }

    free(p);

    printf("P = %p\n", p);
    printf("P[1] =%d\n", *(p+1));
    printf("P[15] =%d", *(p+15));

    return 0;
}