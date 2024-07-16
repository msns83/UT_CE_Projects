#include <stdio.h>
#include <stdlib.h>
#include "tweet.h"
#include "tool.h"

void decider(int commandNumber,user* firstuser,int* loggedIn,post* firstpost,char* username,int* ID){

    switch (commandNumber) {
    case 0:
        if (*loggedIn == 0) {
            signup(firstuser);
        } else {
            printf("you are logged in, first signout\n\n");
        }
        break;

    case 1:
        if (*loggedIn == 0) {
            login(loggedIn,firstuser,username,ID);
        } else {
            printf("you are logged in, first signout\n\n");
        }
        break;

    case 2:
        if (*loggedIn == 1) {
            makepost(firstpost,username,firstuser);
        } else {
            printf("you are not logged in, first login\n\n");
        }
        break;

    case 3:
        if (*loggedIn == 1) {
            like(firstpost,ID);
        } else {
            printf("you are not logged in, first login\n\n");
        }
        break;

    case 4:
        if (*loggedIn == 1) {
            logout(username , loggedIn);
        } else {
            printf("you are not logged in, first login\n\n");
        }
        break;

    case 5:
        if (*loggedIn == 1) {
            delete(username , firstpost, firstuser);
        } else {
            printf("you are not logged in, first login\n\n");
        }
        break;

    case 6:
        if (*loggedIn == 1) {
            info(username,firstuser,firstpost);
        } else {
            printf("you are not logged in, first login\n\n");
        }
        break;

    case 7:
        if (*loggedIn == 1) {
            find_user(firstpost);
        } else {
            printf("you are not logged in, first login\n\n");
        }
        break;

    default:
        printf("Wrong command , Please try again\n\n");
        break;
    }
}