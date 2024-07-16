#include <stdio.h>
#include <stdlib.h>

#define true 1 

typedef struct Student_type {
    char name[41] ;
    int studentNum ;
    int score ;
}Student;


int main(){
    int guessedNumber = 0 ;
    scanf("%d", &guessedNumber);
    int size=0 ; 

    Student* firstStudent = (Student*) malloc(guessedNumber*sizeof(Student));

    Student* tempStudent = firstStudent ;



    for (int i = 0; i < guessedNumber; i++) {

        tempStudent->score = 2 ;
        scanf("%s %d %d", tempStudent->name ,&(tempStudent->studentNum), &(tempStudent->score) );

        if (tempStudent->studentNum == 0) {
            break;
        }

        size++ ;

        if (i == guessedNumber-1) {
            guessedNumber *= 2 ;
            firstStudent = (Student*) realloc(firstStudent , guessedNumber*sizeof(Student));
        }
        tempStudent = firstStudent+size ;
    }
    

    for (int i = 0; i < size; i++) {
        int flag= 0 ;
        int smallest = 0 ;
        for (smallest= 0 ; smallest < size; smallest++) {
            flag = 0;
            for (int j = smallest+1 ; j <size ; j++) {
                if ( ((firstStudent+j)->score) < ((firstStudent+smallest)->score) ) {
                    smallest = j-1 ;
                    flag = 1 ;
                    break;
                }   
            }
            if (flag == 0){
                break;
            }
        }
        
        
            printf("%s\n", ((firstStudent+smallest)->name));
            ((firstStudent+smallest)->score) = 101 ;
        }
        
        

        return 0 ;
}

