#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define LEFT 'L'
#define RIGHT 'R'
#define UP 'U'
#define DOWN 'D'
#define QUIT 'Q'
#define BACK 'B'
#define NEW 'N'

#define SIZE 4

void printBoard(int board[SIZE][SIZE]);
void initializeBoard(int board[SIZE][SIZE]);
void addRandom(int board[SIZE][SIZE]);
int moveLeft(int board[SIZE][SIZE]);
int moveRight(int board[SIZE][SIZE]);
int moveUp(int board[SIZE][SIZE]);
int moveDown(int board[SIZE][SIZE]);
int calculateScore(int board[SIZE][SIZE]);
int isGameOver(int board[SIZE][SIZE]);
int isWinning(int board[SIZE][SIZE]);
void copyBoard(int src[SIZE][SIZE], int dest[SIZE][SIZE]);

int main()
{
    srand(time(0));
    int board[SIZE][SIZE];
    int prevBoard[SIZE][SIZE];
    initializeBoard(board);
    copyBoard(board, prevBoard);

    while (1)
    {
        printBoard(board);
        printf("Move (%c/%c/%c/%c) or Quit, Back, New Start(%c, %c, %c): ", LEFT, RIGHT, UP, DOWN, QUIT, BACK, NEW);

        char move;
        scanf(" %c", &move);
        int moved = 0;

        if (move == LEFT || move == RIGHT || move == UP || move == DOWN)
        {
            copyBoard(board, prevBoard);
            if (move == LEFT)
                moved = moveLeft(board);
            else if (move == RIGHT)
                moved = moveRight(board);
            else if (move == UP)
                moved = moveUp(board);
            else if (move == DOWN)
                moved = moveDown(board);

            if (moved)
                addRandom(board);
        }
        else if (move == BACK)
            copyBoard(prevBoard, board);
        else if (move == NEW)
            initializeBoard(board);
        else if (move == QUIT)
            break;
        else
            printf("Invalid move!\n");

        if (isWinning(board))
        {
            printBoard(board);
            printf("You Win\n");
            break;
        }

        if (isGameOver(board))
        {
            printBoard(board);
            printf("Game Over\n");
            break;
        }
    }
    return 0;
}

void initializeBoard(int board[SIZE][SIZE])
{
    for (int i = 0; i < SIZE; i++)
        for (int j = 0; j < SIZE; j++)
            board[i][j] = 0;
    addRandom(board);
    addRandom(board);
}

void printBoard(int board[SIZE][SIZE])
{
    printf("****************************************\n");
    printf("Your Score: %d\n", calculateScore(board));
    printf("--------------------\n");
    for (int i = 0; i < SIZE; i++)
    {
        for (int j = 0; j < SIZE; j++)
        {
            if (board[i][j] == 0)
                printf("|    ");
            else
                printf("|%4d", board[i][j]);
        }
        printf("|\n");
    }
    printf("--------------------\n");
}

int moveLeft(int board[SIZE][SIZE])
{
    int moved = 0;
    for (int i = 0; i < SIZE; i++)
    {
        int target = 0;
        for (int j = 1; j < SIZE; j++)
        {
            if (board[i][j] != 0)
            {
                if (board[i][target] == 0)
                {
                    board[i][target] = board[i][j];
                    board[i][j] = 0;
                    moved = 1;
                }
                else if (board[i][target] == board[i][j])
                {
                    board[i][target] *= 2;
                    board[i][j] = 0;
                    moved = 1;
                    target++;
                }
                else
                {
                    target++;
                    if (target != j)
                    {
                        board[i][target] = board[i][j];
                        board[i][j] = 0;
                        moved = 1;
                    }
                }
            }
        }
    }
    return moved;
}

int moveRight(int board[SIZE][SIZE])
{
    int moved = 0;
    for (int i = 0; i < SIZE; i++)
    {
        int target = SIZE - 1;
        for (int j = SIZE - 2; j >= 0; j--)
        {
            if (board[i][j] != 0)
            {
                if (board[i][target] == 0)
                {
                    board[i][target] = board[i][j];
                    board[i][j] = 0;
                    moved = 1;
                }
                else if (board[i][target] == board[i][j])
                {
                    board[i][target] *= 2;
                    board[i][j] = 0;
                    moved = 1;
                    target--;
                }
                else
                {
                    target--;
                    if (target != j)
                    {
                        board[i][target] = board[i][j];
                        board[i][j] = 0;
                        moved = 1;
                    }
                }
            }
        }
    }
    return moved;
}

int moveUp(int board[SIZE][SIZE])
{
    int moved = 0;
    for (int j = 0; j < SIZE; j++)
    {
        int target = 0;
        for (int i = 1; i < SIZE; i++)
        {
            if (board[i][j] != 0)
            {
                if (board[target][j] == 0)
                {
                    board[target][j] = board[i][j];
                    board[i][j] = 0;
                    moved = 1;
                }
                else if (board[target][j] == board[i][j])
                {
                    board[target][j] *= 2;
                    board[i][j] = 0;
                    moved = 1;
                    target++;
                }
                else
                {
                    target++;
                    if (target != i)
                    {
                        board[target][j] = board[i][j];
                        board[i][j] = 0;
                        moved = 1;
                    }
                }
            }
        }
    }
    return moved;
}

int moveDown(int board[SIZE][SIZE])
{
    int moved = 0;
    for (int j = 0; j < SIZE; j++)
    {
        int target = SIZE - 1;
        for (int i = SIZE - 2; i >= 0; i--)
        {
            if (board[i][j] != 0)
            {
                if (board[target][j] == 0)
                {
                    board[target][j] = board[i][j];
                    board[i][j] = 0;
                    moved = 1;
                }
                else if (board[target][j] == board[i][j])
                {
                    board[target][j] *= 2;
                    board[i][j] = 0;
                    moved = 1;
                    target--;
                }
                else
                {
                    target--;
                    if (target != i)
                    {
                        board[target][j] = board[i][j];
                        board[i][j] = 0;
                        moved = 1;
                    }
                }
            }
        }
    }
    return moved;
}

void addRandom(int board[SIZE][SIZE])
{
    int empty[SIZE * SIZE][2];
    int count = 0;
    for (int i = 0; i < SIZE; i++)
        for (int j = 0; j < SIZE; j++)
            if (board[i][j] == 0)
            {
                empty[count][0] = i;
                empty[count][1] = j;
                count++;
            }
    if (count > 0)
    {
        int r = rand() % count;
        board[empty[r][0]][empty[r][1]] = (rand() % 2 + 1) * 2;
    }
}

int isGameOver(int board[SIZE][SIZE])
{
    for (int i = 0; i < SIZE; i++)
        for (int j = 0; j < SIZE; j++)
            if (board[i][j] == 0)
                return 0;

    for (int i = 0; i < SIZE; i++)
        for (int j = 0; j < SIZE - 1; j++)
            if (board[i][j] == board[i][j + 1])
                return 0;

    for (int j = 0; j < SIZE; j++)
        for (int i = 0; i < SIZE - 1; i++)
            if (board[i][j] == board[i + 1][j])
                return 0;

    return 1;
}

int calculateScore(int board[SIZE][SIZE])
{
    int score = 0;
    for (int i = 0; i < SIZE; i++)
        for (int j = 0; j < SIZE; j++)
            score += board[i][j];
    return score;
}

int isWinning(int board[SIZE][SIZE])
{
    for (int i = 0; i < SIZE; i++)
        for (int j = 0; j < SIZE; j++)
            if (board[i][j] == 2048)
                return 1;
    return 0;
}

void copyBoard(int src[SIZE][SIZE], int dest[SIZE][SIZE])
{
    for (int i = 0; i < SIZE; i++)
        for (int j = 0; j < SIZE; j++)
            dest[i][j] = src[i][j];
}