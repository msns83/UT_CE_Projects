#include <stdio.h>

int main() {
    
    int arr[]= {3,2,5,4,1,2,3,8,3,6} ;
    const int arrsize = sizeof(arr)/sizeof(arr[0]) ; 
    int arr2[arrsize];
    float average=0;
    int reviewNumber;


    for (int i = 0; i < arrsize; i++) {
        average += arr[i] ;
    }
    average /= arrsize ;

    for (int i = 1; i < arrsize ; i++) {
        for (int j = i-1 ; 0<=j; j--) {
            if (arr[j]>arr[i]) {
                arr2[i]=j ;
                break;
            } else {
                arr2[i]= -1;
            }   
        }     
    }

    arr2[0]=-1;

    reviewNumber= ((arrsize-1)*(arrsize))/2;
    printf("number of reviews: %d\n", reviewNumber );
    printf("average: %f\n", average);
    
    printf("{");
    for (int i = 0; i < arrsize-1; i++){
        printf("%d,", arr2[i]);
    }
    printf("%d", arr2[arrsize-1]);
    printf("}");

    return 0;
}