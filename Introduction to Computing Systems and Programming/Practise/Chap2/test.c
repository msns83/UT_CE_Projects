#include <stdio.h>

int main(){

    float result = 0 ;
    int power ;


    for (unsigned int i = 1; i <= 1000; i++) {
        if (i%2 == 1) {
            power = 1 ;
        } else {
            power = -1;
        }

        float eq = (2*i) - 1 ;
        result += power * (1/eq) ;
    }
    
    printf("%f\n", (1/(4*result))*180 );

    return 0;
}