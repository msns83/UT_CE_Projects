#include <stdio.h>

void sort(int *a ,int *b, int *c);

int main(){
    int a, b, c;

    scanf("%d %d %d", &a, &b, &c);

    sort(&a, &b, &c);

    printf("%d < %d < %d", a, b, c);

    return 0;
}

void sort(int *a ,int *b, int *c){ 
    int arr[3] = {*a , *b , *c} ;
    int keeper ;

    for (int i = 0; i < 3; i++) {
        for (int j = i+1 ; j < 3; j++) {
            if (arr[j]<arr[i]) {
                keeper = arr[i];
                arr[i]= arr[j];
                arr[j] = keeper ;
            }
        }
    }

    *a = arr[0];
    *b = arr[1];
    *c = arr[2];
    
}