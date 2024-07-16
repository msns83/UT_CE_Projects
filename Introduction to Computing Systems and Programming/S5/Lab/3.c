#include <stdio.h>

int main() {
    
    int arr[5]= {1,2,3,4,5} ;
    int arrTwo[5];

    for (int i = 0; i < sizeof(arr)/sizeof(arr[0]); i++) {
        arrTwo[i]= arr[i];
    }

    for (int i = 0; i < sizeof(arrTwo)/sizeof(arrTwo[0]) ; i++) {
        printf("%d,", arrTwo[i]);
    }


    return 0;
}
