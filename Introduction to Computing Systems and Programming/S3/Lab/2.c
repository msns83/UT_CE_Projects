#include <stdio.h>

int main(){

    int m,n = 0;

    printf("Please input the numbers like m*n : ");
    scanf("%d*%d", &m , &n);
    printf("\n");

    for (int i = 1; i < m+1 ; i++){
        for (int j = 1; j < n+1 ; j++){
            printf("%d ", i*j);
        }
        printf("\n");
    }
    

    return 0;
}