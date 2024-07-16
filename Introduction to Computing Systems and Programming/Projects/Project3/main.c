#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "./structdb.h" // contains structures formats
#include "tool.h" //contains some tools that can use in any project

#define null -2

int main(){

    char *username= (char*) malloc(sizeof(char)) ; //keep username of logged in user
    int *ID = (int*) malloc(sizeof(int)); //kepp ID of logged in user
    int commandNumber = null; // number of usercommand starts from 0 (signup) to 7 (find_user)
    int loggedIn = 0 ; //show currently status of program 

    user *firstUser = (user*) malloc(sizeof(user)) ; // create the dummy node of users list
    if (firstUser == NULL) { // validation of malloc
        printf("Memory not allocated.\n");
        exit(0);
    }
    firstUser->next = NULL ; // filling dummy node
    firstUser->username = (char*) malloc(sizeof(char)); // filling dummy node
    if (firstUser->username == NULL) { // validation of malloc
        printf("Memory not allocated.\n");
        exit(0);
    }
    *(firstUser->username)= '\0';// filling dummy node
    
    post *firstPost = (post*) malloc(sizeof(post));// create the dummy node of posts list
    if (firstPost == NULL) { // validation of malloc
        printf("Memory not allocated.\n");
        exit(0);
    }
    firstPost->next = NULL ; // filling dummy node

    printf("UT Tweete !!\n\n"); //guide of the app
    printf("List of commads:\n");
    printf("signup <user name> <password> , login <user name> <password>\n");
    printf("post <text>, like <user name> <post ID> , logout , delete <post_id>\n");
    printf("info , find_user <username> \n\n");

    while (1) {   //main part of program

        commandChecker(&commandNumber); // see which command we take from user and convert it to a number
        decider(commandNumber,firstUser,&loggedIn,firstPost,username,ID); // base on usercommand number decide which action should be done

        fflush(stdin); //clean the stdin for next command
    }

    return 0;
}