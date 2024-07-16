#include "game.h"
#include <stdio.h>
#include <stdlib.h>
#include "tool.h"

void board(int choices[4] , int *score , int *setScore){
        char symbols[4];
        int numbers[4];

        for (int i = 0; i < 4; i++) { /*validation for empty choices*/
            if (choices[i] == -1) {
                symbols[i] = ' ';
                numbers[i] = -1 ;
            } else {
                symbols[i] = makeCard(choices[i]) ;
                numbers[i] = (choices[i]%11)+1 ;
            }
        }


        /*prints graphic of the board*/
        printf("  \t      P3\n"); 
        printf("  ----------------------------\t  Team 1: %d\n", *(score) );

        if (numbers[2] == -1) { /*validation for empty choices*/
            printf("  |\t         \t     |\n");
        } else {
            if (10 <= numbers[2]) {
            printf("  |\t      %c%d\t     |\n",symbols[2],numbers[2]);
            } else {
                printf("  |\t      %c%d \t     |\n",symbols[2],numbers[2]);
            }
        }
        
        for (int i = 0; i < 2; i++) {
            printf("  |\t\t\t     |\n");
        }

        if (numbers[1]== -1 && numbers[3]==-1){ /*validation for empty choices*/
            printf("P2|   \t\t\t     |P4\n");
        } else if (numbers[1] != -1 && numbers[3]==-1) {
            if (10<=numbers[1]) {
                printf("P2|%c%d\t\t\t     |P4\n",symbols[1],numbers[1]);
            } else {
                printf("P2|%c%d \t\t\t     |P4\n",symbols[1],numbers[1]);
            }
        } else if (numbers[1] == -1 && numbers[3] != -1) {
            if (10<=numbers[3]) {
                printf("P2|   \t\t\t  %c%d|P4\n",symbols[3],numbers[3]);
            } else {
                printf("P2|   \t\t\t   %c%d|P4\n",symbols[3],numbers[3]);
            }
        } else {
            if (10 <= numbers[1] && 10<=numbers[3]) {
                printf("P2|%c%d\t\t\t  %c%d|P4\n",symbols[1],numbers[1],symbols[3],numbers[3]);
            } else if (10 <= numbers[1] && numbers[3] < 10) {
                printf("P2|%c%d\t\t\t   %c%d|P4\n",symbols[1],numbers[1],symbols[3],numbers[3]);
            } else if (numbers[1] < 10 && numbers[3] < 10) {
                printf("P2|%c%d \t\t\t   %c%d|P4\n",symbols[1],numbers[1],symbols[3],numbers[3]);
            } else if (10 <= numbers[3] && numbers[1] < 10) {
                printf("P2|%c%d \t\t\t  %c%d|P4\n",symbols[1],numbers[1],symbols[3],numbers[3]);
            }
        }
        
        
        for (int i = 0; i < 2; i++) {
            printf("  |\t\t\t     |\n");
        }

        if (numbers[0] == -1) { /*validation for empty choices*/
            printf("  |\t         \t     |\n");
        } else {
            if (10 <= numbers[0]) {
            printf("  |\t      %c%d\t     |\n",symbols[0],numbers[0]);
            } else {
                printf("  |\t      %c%d \t     |\n",symbols[0],numbers[0]);
            }
        }

        printf("  ----------------------------\t  Team 2: %d\n", *(score+1) );
        printf("  \t      P1\n\n");
        printf("Score Board   Team1: %d , Team2: %d\n\n", *(setScore) , *(setScore+1));
}

void cardsStack(int player1[11]){

    char symbol ;
    char symbols[] = {'A','B','C','D'};

    printf("---------------------------------------------------------------\n");
    printf("Symbol |");
    for (int j = 0; j < 11; j++) {
        if (player1[j] == -1) { /*validation for empty choices*/
            symbol = '-' ;
        } else {
            symbol = symbols[(player1[j])/11] ;
        }
        printf(" %c  |", symbol);
    }
    printf("\n---------------------------------------------------------------\n");
    
    printf("number |");
    for (int j = 0; j < 11; j++) { /*validation for empty choices and diffrence between two charaters and one character number*/
        if (player1[j] == -1) {
            printf(" 0  |");
        } else {
            if ( 10 <= ((player1[j]%11)+1)) {
                printf(" %d |", ((player1[j]%11)+1) );
            } else {
                printf(" %d  |", ((player1[j]%11)+1) );
            }
        }
    }
    

    printf("\n---------------------------------------------------------------\n");

    printf("        "); /*prints number of choices*/
    for (int i = 0; i < 11; i++) {
        printf(" %d   ", i );
    }
    printf("\n");
}

void cardGiving(int* player1 , int* player2 , int* player3 , int* player4,int cards[] ,int numOfCard) {

    int startRange=0 ; /*show where we should start of gard dividing*/
    int endRange=0 ; /*show that we used, up to which member of shuffled cards*/


    if (numOfCard == 5){
        startRange=0 ;
        endRange=5 ;
    } else if (numOfCard == 4) {
        startRange=20;
        endRange=24;
    } else if (numOfCard == 2){
        startRange=36;
        endRange = 38;
    }

    /*dividing cards between players*/
    for (int i = startRange ; i < endRange; i++) {
        int symbol = cards[i]/11 ;
        int number = cards[i]%11 ; 
        *((player1+(symbol*11))+number)= number+1 ;
    }

    startRange = endRange ;
    endRange += numOfCard ;

    for (int i= startRange ; i < endRange; i++) {
        int symbol = cards[i]/11 ;
        int number = cards[i]%11 ; 
        *((player2+(symbol*11))+number)= number+1 ;
    }

    startRange = endRange;
    endRange += numOfCard ;

    for (int i = startRange ; i < endRange ; i++) {
        int symbol = cards[i]/11 ;
        int number = cards[i]%11 ; 
        *((player3+(symbol*11))+number)= number+1 ;
    }

    startRange = endRange ;
    endRange += numOfCard ;

    for (int i = startRange ; i < endRange; i++) {
        int symbol = cards[i]/11 ;
        int number = cards[i]%11 ; 
        *((player4+(symbol*11))+number)= number+1 ;
    }

}

void getCircular(int* circular, int *player1Table){
    int takedCircular=-1  ;
    char symbol ;

    while (*circular == -1) {
        printf("please choose the circular (from 0 to 4): ");
        scanf("%d", &takedCircular);
        if (0 <= takedCircular && takedCircular <= 4) {
            *circular = *(player1Table+takedCircular)  ; /*validaton and set circular*/
            symbol = makeCard(*circular);
            printf("you choosed %c for circular\n\n" , symbol );
        } else {
            printf("invalid choice please try again\n");
            fflush(stdin);
        }
    }
}

void player1FrstChoose(int *choice , int *player1Table) {
    int takedChoice = -1 ; /*to test that input is valid or not*/
    char symbol;
    int number; 

    while (*choice == -1) {
        printf("please input your choice (from 0 to 10): ");
        scanf("%d", &takedChoice);
        
        if (0 <= takedChoice && takedChoice <= 10) {
            if (*(player1Table+takedChoice) != -1) {

                *choice = *(player1Table+takedChoice) ; /*validation and pass selected card to choices array*/
                *(player1Table+takedChoice) = -1 ;
                symbol = makeCard(*choice); 
                number = ((*choice)%11)+1 ;
                printf("you choosed %c%d\n" , symbol , number);

            } else {
                printf("you choosed a used card !! please try again\n");
                fflush(stdin);
            }
        } else {
            printf("wrong choice please try again\n");
            fflush(stdin);
        }
    }
}

void player1Choose(int *choice , int *player1Table , int starter) {
    int takedChoice = -1 ; /*to test that input is valid or not*/
    char symbol;
    int number;
    int token = 0 ;

    while (*choice == -1) {
        printf("please input your choice (from 0 to 10): ");
        scanf("%d", &takedChoice);
        
        if (0 <= takedChoice && takedChoice <= 10) {

            if (*(player1Table+takedChoice) != -1) {

                if ( (*(player1Table+takedChoice)/11) == *(choice+(starter-1))/11) {
                    *choice = *(player1Table+takedChoice) ; /*validation and pass selected card to choices array*/
                    *(player1Table+takedChoice) = -1 ;
                    symbol = makeCard(*choice); 
                    number = ((*choice)%11)+1 ;
                    printf("you choosed %c%d\n" , symbol , number);
                } else { /*check if you have start card symbol*/
                    for (int i = 0; i < 11; i++) {
                        if (*(player1Table+i) != -1 && *(player1Table+i)/11 == *(choice+(starter-1))/11 ) {
                            printf("you have a card that has start symbol, please use that\n");
                            token = 1 ;
                            fflush(stdin);
                            break;
                        }
                    }
                    if (token == 0 ) {
                        *choice = *(player1Table+takedChoice) ;
                        *(player1Table+takedChoice) = -1 ;
                        symbol = makeCard(*choice); 
                        number = ((*choice)%11)+1 ;
                        printf("you choosed %c%d\n" , symbol , number);    
                    }
                }
            } else {
                printf("you choosed a used card !! please try again\n");
                fflush(stdin);
            }
        } else {
            printf("wrong choice please try again\n");
            fflush(stdin);
        }
    }
}

void othPlayerChoose(int *choices , int *playerCards, int player , int starter , int circular){

    int symbol = (*(choices+(starter-1)))/11 ;
    int flag = 0; 
    int cardChoosed = 0 ;
    int coPlayer = -1 ;
    int biggest = (*(choices+(starter-1)))%11 ;
    int possibleWinner = -1 ;

    switch (player) {
    case 2:
        coPlayer = 3 ;
        break;
    case 3:
        coPlayer = 0 ;
        break;
    case 4:
        coPlayer = 1 ;
        break;
    default:
        break;
    }
    

    for (int i = 0; i < 4; i++) {
        if (*(choices+i) != -1 && (*(choices+i))/11 == symbol ) {
            if (biggest < (*(choices+i))%11) {
                biggest = (*(choices+i))%11 ;
                possibleWinner = i ;
            }
        }
    }


    
    if (possibleWinner == coPlayer) {

        for (int i = 0; i<11 ; i++) { /*plays the smallest card of start symbol*/
            if (*((playerCards+symbol*11)+i) != 0 && *((playerCards+symbol*11)+i) != -1) {
                *(choices+(player-1))=  ((symbol*11)+i) ;
                *((playerCards+symbol*11)+i) = -1 ;
                flag = 0 ;
                break;
            } else {
                flag = 1 ;
            }
        }

        if (flag == 1) { /*plays the smallest card*/
            for (int i = 0; i < 11; i++){
                for (int j = 0; j < 4; j++) {
                    if ( *((playerCards+j*11)+i) != 0 && *((playerCards+j*11)+i) != -1 && j != circular/11 ) {
                        *(choices+(player-1)) = (j*11)+i ;
                        *((playerCards+j*11)+i) = -1 ;
                        cardChoosed = 1 ;
                        break; 
                    }
                }
                if (cardChoosed == 1) {
                    flag = 0;
                    break;
                }  
            }
        }

        if (flag == 1) { /*plays smallest circular*/

            for (int i = 0 ; i < 11 ; i++) {
                if (*((playerCards+((circular/11)*11))+i) != 0 && *((playerCards+((circular/11)*11))+i) != -1) {
                    *(choices+(player-1))= ((circular/11)*11)+i ;
                    *((playerCards+((circular/11)*11))+i) = -1 ;
                    flag = 0;
                    break;
                }
            }
        }

    } else {
        for (int i = 10; 0 <= i ; i--) { /*plays the biggest card of start symbol*/
        if (*((playerCards+symbol*11)+i) != 0 && *((playerCards+symbol*11)+i) != -1) {
            *(choices+(player-1))=  ((symbol*11)+i) ;
            *((playerCards+symbol*11)+i) = -1 ;
            flag = 0 ;
            break;
        } else {
            flag = 1 ;
        }
    }

    if (flag == 1) { /*plays the circular card*/
        for (int i = 10; 0 <= i ; i--) {
            if (*((playerCards+((circular/11)*11))+i) != 0 && *((playerCards+((circular/11)*11))+i) != -1) {
                *(choices+(player-1))= ((circular/11)*11)+i ;
                *((playerCards+((circular/11)*11))+i) = -1 ;
                flag = 0;
                break;
            } else {
                flag= 2 ;
            }
        }
    }

    if (flag == 2) { /*you don't have circular or start card so plays the littlest card*/

        for (int i = 0; i < 11; i++){
            for (int j = 0; j < 4; j++) {
                if ( *((playerCards+j*11)+i) != 0 && *((playerCards+j*11)+i) != -1 ) {
                    *(choices+(player-1)) = (j*11)+i ;
                    *((playerCards+j*11)+i) = -1 ;
                    cardChoosed = 1 ;
                    break; 
                }
            }
            if (cardChoosed == 1) {
                break;
            }  
        }
    }


    }
    
}

void scoring(int *choice, int circular, int starter , int *nextPlayer , int *score , int *team){
    
    int flag = 0;
    int startsym = (*(choice+(starter-1))/11) ;
    int winner , answer , winnerSpecial , winnerTeam;
    int choices[4] = {-1,-1,-1,-1} ;



    for (int i = 0; i < 4; i++){ /*equal real choices array to another temporary array to processes on it */
        choices[i] = *(choice+i);
    }
    
    

    for (int i= 0; i < 4; i++) { /*check if all are start card symbol*/
        if ( (choices[i]/11) != startsym && (choices[i]/11) != (circular/11) ) {
            choices[i] = -1 ;
        }

        if ((choices[i]/11) == (circular/11) ) {
            flag = 1 ;
            answer = choices[i]%11 ;
            winnerSpecial = i ;
            break;
        }
    }
    

    if (flag == 0) { /*situation: all are start card symbol*/
        winner = biggest(&choices[0] , 4);

        if (winner == 0 || winner == 2) {
            winnerTeam = 0 ;
        } else if (winner == 1 || winner == 3) {
            winnerTeam = 1 ;
        }

        *nextPlayer = winner ;
        *(score+winnerTeam) = *(score+winnerTeam)+1 ;
        *team = winnerTeam+1 ;
    }

    if (flag == 1) { /*situation: we have a circular between cards*/
        for (int i = 0; i < 4; i++) {
            if ((choices[i]/11) == (circular/11) ) {
                if (answer < (choices[i]%11) ) {
                    answer = (choices[i]%11) ;
                    winnerSpecial =  i ;
                }     
            }
        }
        
        if (winnerSpecial == 0 || winnerSpecial == 2) {
            winnerTeam = 0 ;
        } else if (winnerSpecial == 1 || winnerSpecial == 3) {
            winnerTeam = 1 ;
        }

        *nextPlayer = winnerSpecial ;
        *(score+winnerTeam) = *(score+winnerTeam)+1 ;
        *team = winnerTeam+1 ;
    }
}

void othPlayerFrChoose(int player,int *cards,int circular,int *choices){

    int flag = 0 ;

    for (int i = 10 ; 0 <= i; i--) { /*plays the biggest uncircular card */
        for (int j = 0; j < 4; j++) {
            if (j == (circular/11)) {
                continue;
            }
            if ( *((cards+11*j)+i) != 0 && *((cards+11*j)+i) != -1 ) {
                *(choices+player) = (j*11)+i ;
                *((cards+11*j)+i) = -1 ;
                flag = 1 ;
                break;
            }
        }
        if (flag == 1) {
            break;
        }
    }

    if (flag == 0) { /*you don't have any uncircular card so plays the biggest circular card*/
        for (int i = 10; 0<= i ; i--) {
            for (int j= 0; j < 4; j++) {
                if ( *((cards+11*j)+i) != 0 && *((cards+11*j)+i) != -1 ){
                    *(choices+player) = (j*11)+i ;
                    *((cards+11*j)+i) = -1 ;
                    flag = 2 ;
                    break;
                }
            }
            if (flag == 2) {
                break;
            }  
        }
    }
    
}