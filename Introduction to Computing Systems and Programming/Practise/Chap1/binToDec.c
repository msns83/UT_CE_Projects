#include <stdio.h>

int main(){

    int binary ;
    scanf("%d", &binary);

    int y ;
    int result,h = 0;
    int z = binary ;
    
    while (z != 0){
        z = z/10;
        h += 1 ;
    }

    z=binary;

    for (int i = 0; i < h; i++){
        y = z%10 ;
        z= z/10 ;
        if (y==1 || y==0){
            result = result + y*(1 << i);
        }else {
            printf("\n%d isn't a binary number !!\n" , binary);
            return 0;
        }    
    }

    printf("\n%d\n" , result);
    
    return 0;
}