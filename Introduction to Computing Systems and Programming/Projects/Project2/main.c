#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>
#include "game.h"
#include "whichPlayer.h"
#include "tool.h"

void shuffle_card(int* card);

int main() {

    /*to convert a code to a card => symbol:(code/11)+1 , number:(code%11)+1 */
    /*-1 in all arrays means used or unidentified*/

    int cards[44] , player1Table[11]; /*unshuffled cards , the cars stack in front of player 1*/
    int player1[4][11],player2[4][11],player3[4][11],player4[4][11]; /*each of player's cards*/
    int playersChoices[4]= {-1,-1,-1,-1} ; /*the array of player choices in each round*/
    int score[2] = {0,0} ; /*score of teams*/
    int setScore[2] = {0,0};
    int nextPlayer= 0 ; /*which player should start next round varies from 0 to 3*/
    int circular = -1 ; /*code of circular of game*/
    int endOfGame = 0; /*it's a flag to show end of game*/
    int endOfSet = 0 ;

    while(endOfSet == 0) {
    
        setArr(&player1[0][0],44,0); /*set all members of array to a number */
        setArr(&player2[0][0],44,0);
        setArr(&player3[0][0],44,0);
        setArr(&player4[0][0],44,0);
        setArr(&player1Table[0],11,-1);
        setArr(&playersChoices[0],4,-1);
        setArr(&cards[0], 44 , 0);
        nextPlayer = 0 ;
        circular = -1 ;

        shuffle_card(cards); /*the pre processes for the game , shuffling and ... */
        board(playersChoices, &score[0], &setScore[0]);
        cardGiving(&player1[0][0],&player2[0][0],&player3[0][0],&player4[0][0],cards,5);
        setChoices(&player1Table[0], &player1[0][0]); /*set the card stack for player 1 only*/
        cardsStack(player1Table);
        getCircular(&circular , &player1Table[0]);
        sleep(2);
        cardGiving(&player1[0][0],&player2[0][0],&player3[0][0],&player4[0][0],cards,4);
        cardGiving(&player1[0][0],&player2[0][0],&player3[0][0],&player4[0][0],cards,2);
        setChoices(&player1Table[0], &player1[0][0]);

        while (endOfGame == 0) {
            /*decide which player should play*/
            whichPlayer(nextPlayer,&playersChoices[0],&player1Table[0],&player2[0][0],&player3[0][0],&player4[0][0],circular,&score[0],&nextPlayer,&setScore[0]);
            
            if (score[0] == 6) { /*ends the set and shows the winner*/
                if (score[1]== 0) {
                    setScore[0] = setScore[0]+2 ;
                } else {
                    setScore[0] = setScore[0]+1;
                }
                setArr(&score[0],2,0);
                printf("End of the Set :)\nand the winner is ...\nTEAM 1 :)\n");
                endOfGame = 1 ;
            } else if (score[1] == 6) {

                if (score[0]== 0) {
                    setScore[1] = setScore[1]+2 ;
                } else {
                    setScore[1] = setScore[1]+1;
                }
                setArr(&score[0],2,0);
                printf("End of the Set :)\nand the winner is ...\nTEAM 2 :)\n");
                endOfGame = 1 ;
            }
        }

        endOfGame = 0 ;

        if (setScore[0] == 5) { /*ends the game*/
                endOfSet = 1 ;
                printf("End of the game :)\nand the winner is ...\nTEAM 1 :)\n");
            } else if (setScore[1] == 5) {
                endOfSet = 1 ;
                printf("End of the game :)\nand the winner is ...\nTEAM 1 :)\n");
            }

    }
    
    return 0;
}

void shuffle_card(int* card) {
    int i, r, temp;
    for (temp = 0, i = 0; temp < 44; i++, temp++)
        card[temp] = i;
    srand(time(NULL));
    for (i = 43; i > 0; i--) {
        r = rand() % i;
        temp = card[i];
        card[i] = card[r];
        card[r] = temp;
    }
}