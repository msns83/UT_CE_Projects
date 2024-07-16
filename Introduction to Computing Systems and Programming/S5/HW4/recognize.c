#include <stdio.h>

void recognize(char s[], int sizeString) {

    int count = 0 ; /*for counting number of unrepeated letters*/
    int flag = 0 ; /*to find that this is a repeated charecter*/
    const int letterSize = sizeString; /*changing sizeString to const for use as array size*/
    char letters[letterSize] ; /*array of unrepeated letters*/

    for (int i = 0; i < sizeString; i++) { /*finding repeated letters*/

        for (int j = 0; j < count; j++) { /*comparing each letter to find repeated letter*/
            if (s[i]==letters[j]) {
                flag = 1;
                break;
            }
        }
        
        if (flag==1) {
            flag = 0; 
        } else if (flag == 0){
            letters[count] = s[i] ;
            count++ ;
        }
    }

    if (count%2 == 0) { /*printing result*/
        printf("CHAT WITH THIS USER");
    } else {
        printf("BLOCK THIS USER");
    }

}