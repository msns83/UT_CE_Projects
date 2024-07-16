#include <stdio.h>
#include <math.h>

float one(float a,float b,float c);
int two(int numberOne, int NumberTwo);
char three(int getHours);
void four(int number);
int five(int number);
void six(int days);

float one(float a,float b,float c){

    float delta= (b*b)-4*a*c ; /*define delta and answers*/
    float answerOne, answerTwo;

    if (delta<0) { /*answering to negative delta*/

        printf("NO ROOT FOUND");
        return 0;

    } else { /*processing answers*/

        answerOne= (-b + sqrt(delta))/(2*a) ;
        answerTwo= (-b - sqrt(delta))/(2*a) ;
        printf("%f , %f", answerOne, answerTwo);
        return answerOne;
    }
}

int two(int numberOne, int numberTwo) {
    int digits= numberOne; /*help to counting digits */
    int lastDigit; /*current last digit*/
    int tenPower; 
    int tenMultiple= 1 ; /*tenMultiple = 10 ^ tenPower*/
    int digitsCounter=0;
    int reversedNumber= 0 ;

    while (digits != 0) {
        digits= digits/10 ; /*counting digits*/
        digitsCounter += 1 ;
    }

    digits= numberOne; /*redifining for reusing*/
    tenPower= digitsCounter;

    for (int i = 0; i < digitsCounter; i++) {

        lastDigit= digits%10;

        for (int j=0; j < tenPower ; j++) {
            tenMultiple = tenMultiple*10; /* processing required tenMultiple*/
        }

        reversedNumber += lastDigit*tenMultiple; /*fingding reversed number with extra 0*/

        digits = digits/10; /*redifining for reusing*/
        tenMultiple=1;
        tenPower = tenPower-1 ; 
    }

    reversedNumber = reversedNumber/10; /*deleting extra zero*/

    if (reversedNumber == numberTwo){ /*printing yes or no*/
        printf("YES");
        return 1;
    } else {
        printf("NO");
        return 0;
    }
}

char three(int getHours){
    int days = getHours/24 ;
    int leftHours = getHours%24;
    int whichDay = days%7;

    if (whichDay==0 || whichDay==2 || whichDay==4 || whichDay==6) {
        if(12 <= leftHours){
            printf("B");
            return 'B';
        } else{
            printf("A");
            return 'A';
        }
    } else{
        if(12 <= leftHours){
            printf("D");
            return 'D';
        } else{
            printf("C");
            return 'C';
        }
    }
}

void four(int number){
    int cheker;
    int flag= 0;

    for (int i = 2; i < number ; i++){ /*counting numbers*/

        for (int j= 2; j < i; j++){ /*testing numbers for being prime*/
            cheker= i%j;
            if (cheker==0){
                flag=1;
                break;
            }
        }
            
        if (flag==0){ /*print prime number*/
            printf("%d ",i);
        }

        flag=0; /*redifine our flag*/
    }
}

int five(int number) {
    int result=1;
    int firstSen=0;
    int secondSen=1;

    if (number<1){ /*validation*/
        return 0;
    }
    
    for (int i = 0; i < number-2; i++) {
        
        result= firstSen+secondSen; /*algorithem of fibonacci series*/
        firstSen= secondSen;
        secondSen= result;
    }
    
    printf("%d", result);

    return result ;
}

void six(int days) {

    int years = days/365; /*catching years*/
    int months;
    int leftDays;

    if (186 < days%365){ /*first 6 months*/
        months = 6 + (((days%365)-186)/30);
        leftDays = ((days%365)-186)%30 ;
    } else { /*second 6 months*/
        months = (days%365)/31;
        leftDays= (days%365)%31;
    }

    printf("%d.%d.%d", 1300+years , 1+months , 1+leftDays); /*adding dates*/

}