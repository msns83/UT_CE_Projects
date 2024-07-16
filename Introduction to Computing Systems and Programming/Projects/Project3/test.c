#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char* inputTaker(){

    char spaceCleaner ; // to save spaces and enters here and delete them by revaluing
    spaceCleaner = fgetc(stdin); // get the first char

    while (spaceCleaner == ' ' || spaceCleaner == '\n') {// cleaning spaces
        spaceCleaner = fgetc(stdin);
    }

    char *firstAdress = (char*) malloc(sizeof(char)) ; //take a part of memory to save string
    char * letter = firstAdress ; //letter is a temporary address to avoid lossing first address while processing

    *letter = spaceCleaner ;// set the first letter of string in alloc arr
    char templetter= fgetc(stdin) ; // templetter is a temporary char to check the input string chars
    int size = 1 ; // size of input string , at first it is 1 but then it will be refresh

    while(templetter != ' ') { // space and enter could end the string so we look for end of string with this while
        if (templetter == '\n') { // like pervious line chek for enter
            break;
        }
        size++ ; //refreshing size
        firstAdress = realloc(firstAdress, size * sizeof(char) ); // make alloc arr bigger bassed on size
        letter = firstAdress+size-1; // go to the last cell of arr
        *letter =templetter; // put input letter in that cell
        templetter = fgetc(stdin) ; // get next input letter
    }
    
    firstAdress = realloc(firstAdress , (size+1) * sizeof(char) ); // make alloc arr one cell bigger
    *(firstAdress+size) ='\0' ;    // and put null in the last cell

    return firstAdress ; // and return address of alloc arr
    
}

int main(){

    char* a ;
    int number= -2;
    // char* b ;
    // char* c ; 


    // a = inputTaker();
    // b = inputTaker();
    // c = inputTaker();

    // printf("-------------\n");

    // printf("%s\n",a);
    // printf("%s\n",b);
    // printf("%s\n",c);

    a = inputTaker();
    scanf("%d", &number);

    printf("s. %s\nd. %d\n",a,number);
    
    

    return 0 ;
}