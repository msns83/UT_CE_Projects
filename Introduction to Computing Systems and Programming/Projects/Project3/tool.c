#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "./tool.h"

#define null -2

void commandChecker(int *commandNumber){

    int equation = null ; // to find that user input a valid command
    char command[11]= "nothing" ; // input from user
    *commandNumber= null ; // number of command
    char commands[8][10] = {"signup","login","post","like","logout","delete","info","find_user"}; //list of commands
    
    printf("enter your command:"); //taking input
    scanf("%s", command);

    for(int i = 0; i < 8; i++) { // checking for EQ between input and list of commands

        equation = strcmp(command , commands[i] );
        
        if (equation == 0) {
           *commandNumber = i ; //set number of command
           break; 
        }
    }
}

char* inputTaker(){

    char spaceCleaner ; // to save spaces and enters here and delete them by revaluing
    spaceCleaner = fgetc(stdin); // get the first char

    while (spaceCleaner == ' ' || spaceCleaner == '\n') {// cleaning spaces
        spaceCleaner = fgetc(stdin);
    }

    char *firstAdress = (char*) malloc(sizeof(char)) ; //take a part of memory to save string
    if (firstAdress == NULL) {
        printf("Memory not allocated.\n");//check for memory alloc ;
        exit(0);
    }
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
        if (firstAdress == NULL) {
        printf("Memory not allocated.\n");//check for memory alloc ;
        exit(0);
        }
        letter = firstAdress+size-1; // go to the last cell of arr
        *letter =templetter; // put input letter in that cell
        templetter = fgetc(stdin) ; // get next input letter
    }
    
    firstAdress = realloc(firstAdress , (size+1) * sizeof(char) ); // make alloc arr one cell bigger
    if (firstAdress == NULL) {
        printf("Memory not allocated.\n");//check for memory alloc ;
        exit(0);
    }
    *(firstAdress+size) ='\0' ;    // and put null in the last cell

    return firstAdress ; // and return address of alloc arr  
}

void changePostCount(user* firstuser, char* username, int num){
    user* tempuser = firstuser->next ; // to navigate link list

    while (tempuser != NULL){
        if (strcmp(tempuser->username , username) == 0) {
            tempuser->postCount += num ; // if find that user add one and come out
            break;
        }
        tempuser = tempuser->next ;
    }
}

void aFileUpdate(user* firstuser){
    user* tempuser = firstuser->next ; // to navigate the list
    FILE* accounts = fopen("./accounts.txt", "w"); // open the file

    while (tempuser != NULL) { //navigate list and print in file
        fprintf(accounts , "%s %s %d\n" , tempuser->username , tempuser->password , tempuser->postCount);
        tempuser = tempuser->next ;
    }

    fclose(accounts); //close file
}

void pFileUpdate(post* firstpost){
    post* temppost = firstpost->next ; // to navigating list
    FILE* posts = fopen("./posts.txt", "w"); // open file

    while (temppost != NULL) { // print in file
        fprintf(posts , "%s %s %d\n", temppost->text, temppost->username, temppost->likes );
        temppost = temppost->next ;
    }

    fclose(posts); //close file
    
}