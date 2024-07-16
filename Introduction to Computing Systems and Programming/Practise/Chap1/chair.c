#include <stdio.h>
#define chairs 32

int main(){

    char binary ;
    int result = 0 ;

    printf("Please input the sensor binary code (%d bits, System can identify wrong code):\n", chairs);
    scanf("%c" , &binary);

    for (int i = 0; i < chairs; i++){
        if (binary=='1'){
            result += 1 ;
        } else if (binary != '0' && binary != '1'){
            printf("\nWrong Input\n");
            return 0;
        }
        scanf("%c", &binary);
    }

    printf("\nNumber of full chairs: %d\nNumber of empty chairs: %d\n\n", result, chairs-result);
    

    return 0 ;
}