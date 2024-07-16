#include <stdio.h>

int main(){

    int a ;
    int x;
    int even = 0;
    int odd = 0 ;

    printf("Please input the number:\n");
    scanf("%d", &a);

    if (a > 9999999){
        printf("\nWRONG INPUT");
        return 0;
    }
    

    for (int i = 0; i < 7; i++){
        x = a%10 ;
        a = (a-x)/10 ;
        int y = x%2;

        if (y == 0){
            even = even+1 ;
        } else if (y == 1) {
            odd = odd+1 ;
        }
    }

    printf ("\neven: %d\n" , even);
    printf ("odd: %d\n" , odd);

    if (even > odd){
        printf("\nmore evens!");
    } else if(odd > even){
        printf("\nmore odds!");
    } else {
        printf("\nthey are equal!");
    }

    printf("\n\nDone!");
    
    return 0 ;
}