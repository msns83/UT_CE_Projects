#include <stdio.h>

int main() {
    /*printing odd prime numbers up to the number that user says*/
    /*input: 15*/
    /*output: 3 5 7 11 13 */

    int userInput,checker;
    int flag= 0;

    printf("Please input your number: "); /*take numbers from users*/
    scanf("%d", &userInput);

    for (int i = 2; i <= userInput ; i++){

        if (i%2==0) {
            continue; /*identify odd numbers*/
        }

        for (int j= 2; j < i; j++){ /*checking prime numbers*/
            checker= i%j;
            if (checker==0){
                flag=1;
                break;
            }
        }

        if (flag==0){ /*printing the result*/
            printf("%d ",i);
        }

        flag=0;

        }

    return 0;
}