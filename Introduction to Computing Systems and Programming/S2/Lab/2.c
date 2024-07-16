/*#include <stdio.h>*/

int main() {
    int x, y;
    scanf("%d %d", &x , &y);
    printf("The result is: %d\n", ((x + y) << 2) % 3);
    return 0 ;
}