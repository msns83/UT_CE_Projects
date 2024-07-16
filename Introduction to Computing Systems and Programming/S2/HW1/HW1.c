#include <stdio.h>

int main(){
    char bin ;
    int x=9;
    int y;
    int z;
    int h=1;
    int t = 0;
    scanf("%c", &bin);

    for (int i = 0; i < 10; i++) {
        printf("%c\n" , bin);
        if (bin == '0')
        {
            y= 0;
        } else if(bin == '1'){
            y=1;
        } else {
            printf("404");
        }

        z=  y * (h << x );

        t = t+z ;
        
        scanf("%c", &bin); 
        x -=1 ;
    }

    printf("here  it is : %d", t);
    

    return 0 ;
}