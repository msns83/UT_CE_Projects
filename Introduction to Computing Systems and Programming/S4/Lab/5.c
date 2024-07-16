#include <stdio.h>

long fib(long n);

int main() {
    
    long n = 6;
    printf("%d", fib(n));

    return 0;
}


long fib(long n) {
 if (n <= 2){
    return 1;
 }
 return fib(n - 1) + fib (n - 2);
}