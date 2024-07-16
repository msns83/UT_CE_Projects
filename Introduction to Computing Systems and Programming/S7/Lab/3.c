#include <stdio.h>
#include <stdlib.h>

int main() {
    int *p = NULL;
    int i = 500000;

    for(int j=0;j<10;j++) {
        p = realloc(p, i * sizeof(int));/*put breakpoint here*/
        i+=500000;
        printf("%d\n",i);
    }

    free(p);
    return 0;
}