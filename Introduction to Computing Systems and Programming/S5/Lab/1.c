#include <stdio.h>

int main() {
    
    const a = 5 ;
    int array[a];

    for (int i = 0; i < 5; i++){
        printf("number: ");
        scanf("%d", &array[i]);
    }

    for (int i = 4; 0<=i ; i--) {
        printf("%d\n", array[i]);
    }
    
    return 0 ;
}