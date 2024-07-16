#include <stdio.h>
#include <stdlib.h>

int main(){

    int point[16][4]={0} ;
    char board[8][18] = {"    *   *   *   *","(1)","    *   *   *   *","(2)","    *   *   *   *","(3)","    *   *   *   *","     (1) (2) (3) "} ;
    int vORh = 2 ;
    int x = 4 , y= 4 ;

    for (int i = 0; i < 8; i++){
        for (int j = 0; j < 17; j++){
            printf("%c", board[i][j]);
        }
        printf("\n");
    }

    printf("Vertical (0) or Horizontal (1) ? ");
    scanf("%d", &vORh );
    printf("which line (x y)? ");
    scanf("%d %d", &x , &y );

    if (vORh == 1) {
        int start = (4*x)+1 ;
        board[(-2*y)+8][start] = '-' ; 
        board[(-2*y)+8][start+1]= '-' ;
        board[(-2*y)+8][start+2]= '-' ;
    }

    for (int i = 0; i < 8; i++){
        for (int j = 0; j < 17; j++){
            printf("%c", board[i][j]);
        }
        printf("\n");
    }

    return 0 ;
}