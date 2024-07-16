#include <stdio.h>

int main() {

    /*checking the first digit of two numbers are co-prime or not */
    /*input: 13 15*/
    /*output: true*/
    
    int userInput1, userInput2;
    int number1, number2;
    int checker1, checker2;
    int flag= 0; 

    printf("Please input your number (double digits numbers): "); /*take numbers from user*/
    scanf("%d %d", &userInput1 , &userInput2);

    number1= userInput1%10; /*produce first digit*/
    number2= userInput2%10;

    if (number1==0 || number2==0) {
        printf("We can't work with 0"); /*validation*/
        return 0;
    }
    

    for (int i = 2; i < number1 ; i++) { /*checking co-prime*/

        checker1= number1%i;

        if (checker1==0){

            checker2= number2%i;

            if (checker2==0){
                flag= 1;
                break;
            }
        }       
    }
    
    if (flag==1) { /*printing result*/
        printf("false");
    } else {
        printf("true");
    }
    
    return 0;
}