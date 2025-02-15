#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "user.h"

User *create_user(const char *username, const char *password)
{
    User *new_user = (User *)malloc(sizeof(User));
    strcpy(new_user->username, username);
    strcpy(new_user->password, password);
    new_user->chat_list.head = NULL;
    new_user->next = NULL;
    return new_user;
}

void add_user(UserList *user_list, const char *username, const char *password)
{
    User *new_user = create_user(username, password);
    new_user->next = user_list->head;
    user_list->head = new_user;
}

void free_users(User *head)
{
    while (head != NULL)
    {
        User *temp = head;
        head = head->next;
        free(temp);
    }
}

void load_users_from_file(System *system, const char *filename)
{
    FILE *file = fopen(filename, "r");
    if (file == NULL){
        printf("Error: Unable to open file '%s'.\n", filename);
        return;
    }

    int users_added = 0;
    char line[256];
    while (fgets(line, sizeof(line), file)){

        line[strcspn(line, "\n")] = 0;
        char username[50], password[50];
        if (sscanf(line, "%49s %49s", username, password) == 2){
            add_user(&system->user_list, username, password);
            users_added++;
        }
        else{
            printf("Warning: Invalid format in line '%s'. Skipping.\n", line);
        }
    }

    fclose(file);
    printf("Users successfully loaded from '%s'. %d user(s) added.\n", filename, users_added);
}
