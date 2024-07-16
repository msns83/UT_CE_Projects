void board(int choices[4] , int *score , int *setScore); ; /*prints scores and a board with players cards in it */
void cardsStack(int player1[11]); /*print the table and card stack in front player 1*/
void cardGiving(int* player1 , int* player2 , int* player3 , int* player4,int cards[] ,int numOfCard); /*it takes number of cards that should be divide and divides shuffled cards */
void getCircular(int* circular, int *player1Table); /*takes circular from user*/
void player1FrstChoose(int *choice , int *player1Table); /*executes the steps of choosing player 1 at first place*/
void player1Choose(int *choice , int *player1Table , int starter); /*like player1FrstChoose but now he isn't starter*/
void othPlayerFrChoose(int player,int *cards,int circular,int *choices); /*algorithm of other players start first */
void othPlayerChoose(int *choices , int *playerCards, int player , int starter , int circular); /*algorithm of other players playes (not first !!) */
void scoring(int *choices, int circular, int starter , int *nextPlayer , int* score, int* team); /*finds the most valuable card and shows the winner*/