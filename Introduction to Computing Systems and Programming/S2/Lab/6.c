#include <stdio.h>

int main() {
    char x;
    /*printf("Enter a number:\n");
    scanf("%d", &x);
    printf("%c\n", x);*/   

    for (int i = 0; i < 4000 ; i++)
    {
        x= i ;
        printf("%c\n", x);
    }
    

    return 0 ;
}