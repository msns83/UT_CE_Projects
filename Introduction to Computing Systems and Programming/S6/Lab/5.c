#include <stdio.h>
#include <string.h>

int main(){

    char first_array [70], second_array [70];
    int equation , count ;

    printf("please input first word: ");
    scanf("%s", first_array);

    printf("please input second word: ");
    scanf("%s", second_array);

    equation = strcmp(first_array, second_array);
    count = strlen(first_array);

    if (equation == 0) {
        printf("True , number of characters : %d\n" , count);
    } else {
        printf("False\n");
        strcpy(second_array, first_array);
        printf("%s\n%s\n",first_array , second_array);
    }
    
    return 0;

}