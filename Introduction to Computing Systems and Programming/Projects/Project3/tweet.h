#include "./structdb.h"

void signup(user* firstUser); // check if there is repeathed username or not then add one new user in users list
void login(int* loggedIn,user* firstUser,char* username,int* ID); //check if password and username are true in compare to users list change app status to 1 and set app username and ID
void makepost(post* firstpost, char* username, user* firstuser); //add a post with app username to posts list
void like(post* firstpost,int* ID); //check if the like request isn't unrepeated then add one to post likes
void logout(char* username , int* loggedIn); //change the app status to zero
void delete(char* username,post* firstPost, user* firstuser); // free storge of deleted post and connect the rest of list
void info(char* username,user* firstUser,post* firstPost); // show the information of app username
void find_user(post* firstPost); //search for info of a user in a list