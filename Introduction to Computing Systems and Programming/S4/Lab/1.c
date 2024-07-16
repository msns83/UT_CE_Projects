#include "fact.h" /*import header file*/
#include <stdio.h>


int main(){

    int n;
    int result=0;

    printf("Please input your number: "); /*take input*/
    scanf("%d", &n);

    for (int i = 0; i < n+1; i++){
        int sign; /*solving the odd powers and (-1)*/
        if (i%2==0) {
            sign = 1;
        } else {
            sign= -1;
        }
        
        result= result + sign * fact(i); /*finding answer of sigma*/
    }

    printf("%d", result);
    
    return 0;
}