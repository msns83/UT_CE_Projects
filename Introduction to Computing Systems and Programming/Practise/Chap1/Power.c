#include <stdio.h>

int main(){

    int power;
    int baseNumber;
    int number=1;

    scanf("%d^%d", &baseNumber, &power);


    for (int i = 0; i < power ; i++){
        number= number*baseNumber;
    }

    printf("\n%d\n", number);
    
    
    return 0;
}