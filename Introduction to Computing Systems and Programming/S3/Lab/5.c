#include <stdio.h>
#include <stdlib.h>

int main(){

    long int seed = 810101459;
    int userInput ;
    int randomNumber = rand() % 100;

    srand(seed);
    
    while (userInput != randomNumber){
        printf("please input your guess: ");
        scanf("%d", &userInput);
        if (userInput > randomNumber){
            printf("your guess is greater than target\n");
        } else if (randomNumber > userInput){
            printf("your guess is less than target\n");
        }      
    }
    
    printf("\nYour guess is correct\n the target number is :%d\n", randomNumber);

    return 0;
}
