#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "./structdb.h"
#include "tweet.h"
#include "tool.h"

#define null -2

//general definition of functions are in .h files 
//** means definition is availbale in file

void signup(user* firstUser){

    user* tempuser = firstUser ; // we use it to navigate the linked list
    int flag = 0 ; //to find this is a repeated username
    char* username = inputTaker() ; // take the first unlimited string from stdin as username
    char* password = inputTaker(); // take the second unlimited string from stdin as username

    while (tempuser != NULL) { //navigate and check linked list for repeated user
        if ( strcmp(tempuser->username , username ) == 0 ){
            printf("this username has already taken ! \n\n");
            flag = 1 ;
            break;
        }
        tempuser = tempuser->next ;
    }
    
    if (flag == 0){ // if there wasn't a repeated user make a new user and fill it
        user* newuser = (user*) malloc(sizeof(user)); // make new user
        if (newuser == NULL) {
        printf("Memory not allocated.\n");
        exit(0);
        }

        if (firstUser->next == NULL){ //assign and ID bassed on last ID
            newuser->ID = 1 ;
        }else {
            newuser->ID = (firstUser->next->ID) +1 ;
        }
        
        newuser->next = firstUser->next ; // positioning in linked list 
        firstUser->next = newuser ; //positioning in linked list
        newuser->username = username ; // assign unlimited input to username
        newuser->password = password ;
        newuser->postCount = 0 ;
        aFileUpdate(firstUser); // upadate accounts.txt
        printf("%s! you signed up succesfully!\n\n", newuser->username);  //print succes message
    }
}

void login(int* loggedIn,user* firstUser,char* fUsername,int* ID){
    user* tempuser = firstUser ; //**
    int flag = 0 ; //to check do we have this user ?!
    char *username = inputTaker(); //**
    char *password = inputTaker(); 

    while (tempuser != NULL) { //navigate link list
        if ( strcmp(tempuser->username , username ) == 0 ){ // check for same username compare to input 
            if (strcmp(tempuser->password , password ) == 0) { // check for same password compare to input 
                fUsername = (char*) realloc(fUsername, strlen(username)+1 ) ; //resize app username
                *ID = tempuser->ID ; // set app ID
                strcpy(fUsername , username); //set app username
                *loggedIn= 1 ; //set app status
                printf("%s! you logged in succesfully!\n\n", tempuser->username);
                flag = 1 ;
                break;
            }
            printf("Wrong username or password\n\n");
            flag = 2 ;
            break;
        }
        tempuser = tempuser->next ;
    }

    if (flag == 0) {
        printf("Wrong username or password\n\n");
    }

    free(username); // free inputs
    free(password);

}

void makepost(post* firstpost, char* username, user* firstuser){
    int ID = 1 ; // to assign a new ID to new post base on last post 
    int flag= 0 ; // to check that out link list is empty or not
    int token = 0 ; // to check that we missed post ID between posts or not like 1 2 3 - 5 (4 missed)
    post* start = firstpost; //save the current post address while navigating
    post* end = NULL ; //save the next post address while navigating

    post* newPost = (post*) malloc(sizeof(post)); // make a new post
    if (newPost == NULL) {
        printf("Memory not allocated.\n");
        exit(0);
    }

    post* tempPost = firstpost->next ; // for navigating link list

    while (tempPost != NULL) { // navigate the list to find the bestplace to add a new post
        flag = 1 ;
        if (strcmp(tempPost->username, username) == 0) {
            if (ID < tempPost->ID) { //option 4 : link list isn't empty and we have posts from this user and new post should add somewhere between the list of posts of that user
                newPost->next = tempPost;
                start->next = newPost ;
                flag=2 ;
                break;
            }
            ID++ ; // also find the propriate ID number for post
            start= tempPost;
            end = tempPost->next;
            token = 1 ;
        }
        tempPost = tempPost->next ;
    }

    if (flag == 0) { // option 1 : link list is empty
        newPost->next = end ;
        start->next = newPost;
    } else if(flag == 1){ //option 2 : link list isn't empty but we don't have any post from this user
        newPost->next = start->next;
        start->next = newPost ;
    }
    
    if (flag != 2 && token ==1) { //option 3 : link list isn't empty and we have posts from this user and new post should add to the end of the list of posts of that user
        newPost->next = end ;
        start->next= newPost ;
    }
    
    newPost->ID = ID ; // giving ID that generated in last while in this function

    newPost->username = (char*) malloc((strlen(username)+1)* sizeof(char)); // set username of the post to username of the app
    strcpy(newPost->username , username );
    newPost->likes = 0 ;// set post likes to

    char spaceCleaner ; // to save spaces and enters here and delete them by revaluing
    spaceCleaner = fgetc(stdin); // get the first char

    while (spaceCleaner == ' ' || spaceCleaner == '\n') {// cleaning spaces and enters
        spaceCleaner = fgetc(stdin);
    }

    char* letterAdress = (char*) malloc(sizeof(char)) ; // make a space to collect post text
    if (letterAdress == NULL) {
        printf("Memory not allocated.\n");
        exit(0);
    }

    char* letter = letterAdress ; // we make it to dont lose the head of arr while navigating
    *letter = spaceCleaner ;// set the first letter of string in alloc arr
    char tempLetter= fgetc(stdin) ;
    int size=1 ;
    
    while (tempLetter != '\n') { // this part works like inputTaker() in tool.c but it isn't sensitive to space
        size++ ;
        letterAdress = (char*) realloc(letterAdress , size * (sizeof(char)) );
        if (letterAdress == NULL) {
            printf("Memory not allocated.\n");
            exit(0);
        }
        letter= letterAdress+(size-1) ;
        *letter = tempLetter;
        tempLetter = fgetc(stdin) ;
    }

    letterAdress = realloc(letterAdress , (size+1) * sizeof(char) ); // make alloc arr one cell bigger
    if (letterAdress == NULL) {
            printf("Memory not allocated.\n");
            exit(0);
    }
    *(letterAdress+size) ='\0' ;    // and put null in the last cell

    
    newPost->likers = (int*) malloc(sizeof(int)); // make the likers ID array
    newPost->text = letterAdress ; // assign address of first letter of the post content to post

    changePostCount(firstuser, username, 1);// add one to post counts 
    aFileUpdate(firstuser); // update accounts file
    pFileUpdate(firstpost); //update posts file

    printf("user:%s\n",username); //print the post
    printf("Post:%s\n", newPost->text);
    printf("Post_ID:%d\n",newPost->ID);

    printf("\n");
}

void like(post* firstpost, int* ID){
    post* tempPost = firstpost->next ; // to navigate link list
    int flag = 0 ; // to check if we have this post or not
    int repeatedCheck = 0 ; // to check app username didn't like this before
    int number = null ; // input from user

    char* username = inputTaker(); //**
    scanf("%d", &number); //input from user

    if (number == null){ // validation
        printf("invalid post ID\n");
    }else {
        while (tempPost != NULL) { // navigating linked list
            if (strcmp(tempPost->username, username) == 0) { //find that post
                if (tempPost->ID == number) { //find that ID

                    for (int i = 0; i < tempPost->likes; i++) { //check for repeated like
                        if ( *((tempPost->likers)+i) == *ID ) {
                            repeatedCheck = 1 ;
                            flag =2 ;
                            printf("you've liked this once before!!\n\n");
                            break;
                        }
                    }
                    
                    if (repeatedCheck == 0){ // add 1 to post likes
                        tempPost->likes = tempPost->likes + 1 ;
                        tempPost->likers = (int*) realloc(tempPost->likers , (tempPost->likes)*sizeof(int) );
                        *((tempPost->likers)+((tempPost->likes)-1)) = *ID ;
                        flag = 1 ;
                        break;
                    }
                     
                }  
            }
            tempPost = tempPost->next ;
        }

        if (flag == 1) { // if it was succesful print post details
            printf("user: %s\n",tempPost->username);
            printf("Post_ID: %d\n",tempPost->ID);
            printf("Post:%s\n",tempPost->text);
            printf("Likes:%d\n", tempPost->likes);
            printf("\n");
            pFileUpdate(firstpost);
        }

        if (flag == 0) {
            printf("there is no such a post!\n\n");
        }
    }
    

    free(username); // free input
}

void logout(char* username , int* loggedIn){
    username = realloc(username, sizeof(char)); // resize app username
    *loggedIn = 0 ; 
    printf("you logged out succfully , bye! \n\n");
}

void delete(char* username,post* firstPost, user* firstuser) {

    int flag =0 ; //to find if there is such a post
    int number = null ; // input from user
    post* tempPost = firstPost->next ; //it keeps the current node
    post* start = firstPost ; //it keeps the next node

    scanf("%d", &number);


    while (tempPost != NULL) { //navigate the list
        if (strcmp(tempPost->username, username) == 0) {
            if (tempPost->ID == number) {
                free(tempPost->text); // free memory
                start->next = tempPost->next;
                free(tempPost); //free memory
                flag=1;
                break; 
            }  
        }
        start = tempPost ;
        tempPost = tempPost->next ;
    }

    if (flag == 1) { //succesful
        changePostCount(firstuser,username,-1);
        aFileUpdate(firstuser);
        pFileUpdate(firstPost);
        printf("you deleted post %d\n",number);
        printf("\n");
    }
    
    if (flag == 0) { // not succesful
        printf("there is no such a post!\n\n");
    }
}

void info(char* username,user* firstUser,post* firstPost){
    
    user* tempuser = firstUser->next ; //**
    post* temppost = firstPost->next ; //**

    printf("\nUsername: %s\n", username); //print app username

    while(tempuser != NULL){ // find that username and print it's password
        if ( strcmp(tempuser->username, username)== 0 ) {
            printf("Password: %s\n\n", tempuser->password);
        }
        tempuser = tempuser->next ;
    }
    
    while(temppost != NULL){ // find app username posts
        if ( strcmp(temppost->username , username)== 0 ) {
            printf("Post_ID: %d\n", temppost->ID );
            printf("Post:%s\n",temppost->text);
            printf("Likes: %d\n" , temppost->likes );
            printf("\n");
        }
        temppost = temppost->next ;
    }
}

void find_user(post* firstPost){

    post* temppost = firstPost->next ; //**
    int flag = 0 ; //to find that we have this user or not
    char* username = inputTaker(); //take unput username
    
    printf("\n");
    while(temppost != NULL){ //finding input user
        if ( strcmp(temppost->username , username)== 0 ) {
            printf("Post_ID: %d\n", temppost->ID );
            printf("Post:%s\n", temppost->text);
            printf("Likes: %d\n" , temppost->likes);
            printf("\n");
            flag = 1 ;
        }
        temppost = temppost->next ;
    }

    if (flag == 0) {
        printf("this user doesn't have any post!!\n");
    }

    free(username);
}