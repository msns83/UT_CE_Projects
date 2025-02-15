#ifndef USER_H
#define USER_H

#include "chat.h"
#include "system.h"

typedef struct User {
    char username[50];
    char password[50];
    ChatList chat_list;
    struct User *next;
} User;

typedef struct UserList {
    User *head;
} UserList;


User *create_user(const char *username, const char *password);
void add_user(UserList *user_list, const char *username, const char *password);
void free_users(User *head);
void load_users_from_file(System *system, const char *filename);


#endif