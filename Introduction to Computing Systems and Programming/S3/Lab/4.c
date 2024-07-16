#include <stdio.h>
#include <unistd.h>

int main(){
    int userMenuInput= 1 ;
    int m,n = 0;
    int base;

    
    while (userMenuInput != 0){
        printf("Hello\nWhat can i do for you?\n\ninput 1 for table\ninput 2 for shape\ninput 0 to quit\n\nYour input:");
        scanf("%d", &userMenuInput);

        switch (userMenuInput){

        case 0:
            break;

        case 1:
            printf("\nOK let's draw a Multiplication table\n\n");
            printf("Please input the numbers like m*n : ");
            scanf("%d*%d", &m , &n);
            printf("\n");

            if (1>m || 1>n){
                printf("m and n should be greater than 0\n\n");
                sleep(3);
                break;
            }
            

            for (int i = 1; i < m+1 ; i++){
                for (int j = 1; j < n+1 ; j++){
                    printf("%d ", i*j);
                }
                printf("\n");
            }
            printf("\n");
            sleep(3);
            break;

        case 2:
            printf("\nOK let's draw a Triangle\n\n");
            printf("Please input the size of shape's base (it should be odd): ");
            scanf("%d", &base);

            if (3>base){
                printf("base size should greater than 2\n\n");
                sleep(3);
                break;
            }
            

            for (int i = 1; i < base+1; i+=2) {
                for (int j = 0; j < (base-i)/2 ; j++){
                printf("-") ;  
                }
                for (int z = 0; z < i ; z++){
                    printf("$");
                }
                for (int h = 0; h < (base-i)/2 ; h++){
                    printf("-");
                }
                printf("\n");    
            }
            printf("\n");
            sleep(3);
            break;

        default:
            printf("\nThis is an invalid input\n\n");
            sleep(3);
            break;
        }
    }
    
    printf("\nGoodbye");
    return 0;
}