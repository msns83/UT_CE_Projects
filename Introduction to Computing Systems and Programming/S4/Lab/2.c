#include <stdio.h>

int fibo(int n); /*declaration*/

int main() {
    
    long int n;

    printf("Please input the number (n of fibonacii series): ");
    scanf("%d", &n); /*take input*/

    printf("%d", fibo(n));

    return 0;
}

int fibo(int n) {
    int result=1;
    int firstSen=1;
    int secondSen=1;

    if (n<1){
        return 0;
    }
    
    for (int i = 0; i < n-2; i++) {
        
        result= firstSen+secondSen; /*algorithem of fibonacci series*/
        firstSen= secondSen;
        secondSen= result;
    }
    
    return result ;
}
