#include <stdio.h>

int main() {
    int userInput;
    int cheker;
    int flag= 0;

        printf("Please input your number: ");
        scanf("%d", &userInput);
        printf("user input:%d\n", userInput);

        for (int i = 2; i <= userInput ; i++){
            if (i%2==0) {
                continue;
            }
            
            for (int j= 2; j < i; j++){
                cheker= i%j;
                if (cheker==0){
                    flag=1;
                    break;
                }
            }
            
            if (flag==0){
                printf("%d\n",i);
            }
            flag=0;
        }
    

    return 0;
}