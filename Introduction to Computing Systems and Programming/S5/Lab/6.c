#include <stdio.h>
#include <ctype.h>

int stringLength(char str[]);

int main() {
    
    char text[5][21];
    int size[5] ;
    char flag;

    for (int i = 0; i < 5 ; i++) {
        printf("please input: ");
        scanf("%s", text[i]);
        size[i]= stringLength(text[i]);
    }

    for (int i = 0; i < size[0]; i++) {
        flag = tolower(text[0][i]);
        for (int j = 1; j < 5 ; j++) {
            for (int h = 0; h < size[j]; h++) {
                if (tolower(text[j][h]) == flag) {
                    text[j][h] = '$';
                }      
            }     
        }
    }

    for (int i = 0; i < 5; i++) {
        printf("%s\n", text[i]);
    }

    return 0;
}

int stringLength(char str[]) {
    int count; 
    for (count = 0; str[count] != '\0'; ++count);
    return count; 
}