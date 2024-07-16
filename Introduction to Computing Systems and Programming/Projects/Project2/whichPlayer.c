#include "game.h"
#include "whichPlayer.h"
#include "tool.h"
#include <stdio.h>
#include <unistd.h>

void whichPlayer(int player,int *playersChoices,int *player1Table,int *player2,int *player3,int *player4,int circular,int *score, int *nextPlayer, int *setScore) {

    int winnerTeam ;

    switch (player) { /*executes the steps based on which player (from 0 to 3) should start*/
    case 0:
        
        board(playersChoices, score , setScore);
        cardsStack(player1Table);
        player1FrstChoose(playersChoices , player1Table);
        sleep(3);
        othPlayerChoose(playersChoices,player2,2,1,circular);
        othPlayerChoose(playersChoices,player3,3,1,circular);
        othPlayerChoose(playersChoices,player4,4,1,circular);
        scoring(playersChoices, circular , 1 , nextPlayer , score , &winnerTeam );
        board(playersChoices, score, setScore);
        printf("Team %d won and got 1 point because of player %d\n\n" , winnerTeam , *(nextPlayer)+1 );
        sleep(7);
        setArr(playersChoices,4,-1);
        break;

    case 1:
        
        othPlayerFrChoose(1,player2,circular,playersChoices);
        othPlayerChoose(playersChoices,player3,3,2,circular);
        othPlayerChoose(playersChoices,player4,4,2,circular);
        board(playersChoices, score , setScore);
        cardsStack(player1Table);
        player1Choose(playersChoices , player1Table, 2);
        sleep(3);
        scoring(playersChoices, circular , 2 , nextPlayer , score , &winnerTeam );
        board(playersChoices, score , setScore);
        printf("Team %d won and got 1 point because of player %d\n\n" , winnerTeam , *(nextPlayer)+1 );
        sleep(7);
        setArr(playersChoices,4,-1);
        break;
    
    case 2:
        othPlayerFrChoose(2,player3,circular,playersChoices);
        othPlayerChoose(playersChoices,player4,4,3,circular);
        board(playersChoices, score , setScore);
        cardsStack(player1Table);
        player1Choose(playersChoices , player1Table, 3);
        sleep(3);
        othPlayerChoose(playersChoices,player2,2,3,circular);
        scoring(playersChoices, circular , 3 , nextPlayer , score , &winnerTeam );
        board(playersChoices, score , setScore);
        printf("Team %d won and got 1 point because of player %d\n\n" , winnerTeam , *(nextPlayer)+1 );
        sleep(7);
        setArr(playersChoices,4,-1);
        break;
    
    case 3:
        othPlayerFrChoose(3,player4,circular,playersChoices);
        board(playersChoices, score , setScore);
        cardsStack(player1Table);
        player1Choose(playersChoices , player1Table,4);
        sleep(3);
        othPlayerChoose(playersChoices,player2,2,4,circular);
        othPlayerChoose(playersChoices,player3,3,4,circular);
        scoring(playersChoices, circular , 4 , nextPlayer , score , &winnerTeam );
        board(playersChoices, score , setScore);
        printf("Team %d won and got 1 point because of player %d\n\n" , winnerTeam , *(nextPlayer)+1 );
        sleep(7);
        setArr(playersChoices,4,-1);
        break;
    
    default:
        break;
    }
}