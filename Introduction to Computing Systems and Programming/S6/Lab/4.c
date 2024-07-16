#include <stdio.h>

int compare(char* first_array, char* second_array);

int main(){

    char first_array [70], second_array [70];

    printf("please input first word: ");
    scanf("%s", first_array);

    printf("please input second word: ");
    scanf("%s", second_array);

    compare(first_array, second_array);
    
    return 0;

}

int compare(char* first_array, char* second_array){

    int count ;
    int equation = 1 ;
    int num_equ = 0 ;


    for (count=0; first_array[count] != '\0' ; count++) {
        if (first_array[count] != second_array[count]){
            equation = 0;
        }
    }

    if (second_array[count] == '\0') {
        num_equ = 1 ;
    }
    
    if (equation == 1) {
        printf("equation: True\n");
    } else {
        printf("equation: False\n");
    }

    if (num_equ == 1) {
        printf("number of characters: True\n");
    } else {
        printf("number of characters: False\n");
    }

}