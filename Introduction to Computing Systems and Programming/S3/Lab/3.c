#include <stdio.h>

int main(){

    int base;
    printf("Please input the size of shape's base (it should be odd): ");
    scanf("%d", &base);

    for (int i = 1; i < base+1; i+=2) {
        for (int j = 0; j < (base-i)/2 ; j++){
         printf("-") ;  
        }
        for (int z = 0; z < i ; z++){
            printf("&");
        }
        for (int h = 0; h < (base-i)/2 ; h++){
            printf("-");
        }
        printf("\n");    
    }
    
    return 0;
}