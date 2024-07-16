#include "./structdb.h"

void commandChecker(int *commandNumber); //convert text command to a number from 0 to 7
char* inputTaker(); //take an unlimited input , like scanf but it works with alloc memory
void changePostCount(user* firstuser, char* username , int num); //add num to user profile's postCounts
void aFileUpdate(user* firstuser); //update accounts.txt file
void pFileUpdate(post* firstpost); //update posts.txt file 
void decider(int commandNumber,user* firstuser,int* loggedIn,post* firstpost,char* username,int* ID); //base on command number execute one of tweet.h finctions