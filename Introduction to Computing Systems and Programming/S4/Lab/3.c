#include <stdio.h>

int g(int y);
int f(int x);

int main() {
    int a = 10;
    printf("%d", f(a)); /*pass 10 to function f*/  /*now f(10)=6 so it shows us 6*/
    return 0;
}

int f(int x) {
    return g(x); /*pass 10 to function g*/
}

int g(int y) { /*y is 10 now*/
    int j = 2; 
    y = j * 3; /*now y is 2*3= 6 */
    return y;  /*so it pass y=6 to the upper levels*/
}