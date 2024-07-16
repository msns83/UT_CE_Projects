#include <stdio.h>
#define row 2
#define column 3

void calc_transposed_matrix(int matrix[row][column] , int transposedMatrix[column][row]);

int main(){

    int matrix[row][column] = {{1,2,3},{4,5,6}} ;
    int transposedMatrix[column][row] ;  
    calc_transposed_matrix(matrix , transposedMatrix);

    for (int i = 0; i < row; i++) {
        for (int j = 0; j < column; j++) {
            printf("%d ", matrix[i][j]);
        }
        printf("\n");
    }

    printf("\n\n");

    for (int i = 0; i < column; i++) {
        for (int j = 0; j < row; j++) {
            printf("%d ", transposedMatrix[i][j]);
        }
        printf("\n");
    }
    
    
    return 0;
}

void calc_transposed_matrix(int matrix[row][column] , int transposedMatrix[column][row]){
    for (int i = 0; i < row; i++) {
        for (int j = 0; j < column; j++) {
            transposedMatrix[j][i] = matrix[i][j] ;
        }   
    }
}