#include <stdio.h>

void separate(int arr[], int sizeArr) { 

    const int fixedSize = sizeArr ; /*change type of size to const in order to prevent error*/
    int odds[fixedSize], evens[fixedSize], oddCount=0, evenCount=0 ; /*define new arrays and count of members of them*/
    int holder; /*define a holder to holding some values for moments of swaping*/

    for (int i=0 ; i < sizeArr ; i++) { /*separating odds and evens and counting members of them*/
        if (arr[i]%2 == 0) {
            evens[evenCount]= arr[i];
            evenCount++ ;
        } else {
            odds[oddCount] = arr[i];
            oddCount++ ; 
        }
    }


    for (int i = 0; i < evenCount ; i++) { /*sorting even numbers*/
        for (int j = i+1 ; j < evenCount ; j++) {
            if (evens[i]>evens[j]) {
                holder = evens[i];
                evens[i]= evens[j];
                evens[j]= holder ;
            }
        }
    }

    for (int i = 0; i < oddCount ; i++) { /* sorting odd numbers */
        for (int j = i+1 ; j < oddCount ; j++) {
            if (odds[i]>odds[j]) {
                holder = odds[i];
                odds[i]= odds[j];
                odds[j]= holder ;
            }
        }
    }

    for (int i=0; i < evenCount-1 ; i++) { /*printing even numbers*/
        printf("%d,", evens[i]);
    }
    printf("%d\n", evens[evenCount-1]);
    

    for (int i=0; i < oddCount-1 ; i++) { /*printing odd numbers*/
        printf("%d,", odds[i]);
    }
    printf("%d", odds[oddCount-1]);
    
    
}