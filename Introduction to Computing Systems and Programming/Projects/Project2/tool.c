#include "game.h"
#include "tool.h"

void setArr(int* array , int size , int value){ /*sets members of an array*/
    for (int i = 0; i < size; i++) {
        *(array+i)= value ;
    }
}

void setChoices(int *choices , int* player1){ /*push player 1 cards to his table*/

    int counter=0 ;

    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 11; j++) {
            if (*((player1+i*11)+j) != 0 ) {
                *(choices+counter) = (i*11)+j;
                counter++;
            }   
        }
    }
}

char makeCard(int code) { /*convert code to symbol and number of the card*/
    char symbols[] = {'A','B','C','D'} ;
    return symbols[code/11];
}

int biggest(int *array ,int size){ /*find biggest member of an array*/

    int answer = 0 ;
    int flag = 0 ;

    for (int i = 0; i < size; i++) {
        flag =0 ;
        for (int j = i+1 ; j < size ; j++) {
            if (*(array+i)%11 < *(array+j)%11 ) {
                i = j-1 ;
                answer = j ;
                flag = 1 ;
                break;
            }
        }
        if (flag == 0) {
            break;
        }
    }

    return answer ;
}