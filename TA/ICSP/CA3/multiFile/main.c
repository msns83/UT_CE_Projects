#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "system.h"

#define LOGIN "login"
#define SIGNUP "signup"
#define LOGOUT "logout"
#define NEWCHAT "newChat"
#define SELECTCHAT "selectChat"
#define SENDMESSAGE "sendMessage"
#define EXIT "exit"
#define SHOWCHAT "showChat"
#define LOADUSERS "loadUsers"



char *get_user_message()
{
    char buffer[512];
    int index = 0;
    char ch;

    while ((ch = getchar()) != '\n' && ch != EOF && index < 511)
        buffer[index++] = ch;
    buffer[index] = '\0';

    char *message = (char *)malloc(index + 1);
    if (message == NULL)
        exit(1);
        
    strcpy(message, buffer);
    return message;
}

void handle_signup(System *system)
{
    char username[50], password[50];
    printf("Username: ");
    scanf("%s", username);
    printf("Password: ");
    scanf("%s", password);
    sign_up(system, username, password);
    while (getchar() != '\n')
        ;
}

void handle_login(System *system)
{
    if (system->logged_in_user != NULL){
        printf("Error: There is an open session, please logout first.\n");
        return ;
    }
    char username[50], password[50];
    printf("Username: ");
    scanf("%s", username);
    printf("Password: ");
    scanf("%s", password);
    log_in(system, username, password);
    while (getchar() != '\n')
        ;
}

void handle_logout(System *system)
{
    log_out(system);
}

void handle_newChat(System *system)
{
    char selected_user[50], chat_name[50];
    printf("Enter chat name: ");
    scanf("%s", chat_name);
    printf("Enter selected username: ");
    scanf("%s", selected_user);
    create_chat_between_users(system, selected_user, chat_name);
    while (getchar() != '\n')
        ;
}

void handle_selectChat(System *system)
{
    char chat_name[50];
    printf("Enter chat name: ");
    scanf("%s", chat_name);
    select_chat(system, chat_name);
    while (getchar() != '\n')
        ;
}

void handle_sendMessage(System *system)
{
    if (system->current_chat == NULL)
    {
        printf("Error: No chat selected. Please select a chat first.\n");
        return;
    }
    printf("Receiver: %s\n", find_chat_receiver(system, system->current_chat));
    printf("Enter message: ");
    send_message_to_current_chat(system, get_user_message());
}

void handle_showChat(System *system)
{
    display_current_chat_messages(system);
}
void handle_loadUsers(System * system){

    char filename[256];
    printf("Enter filename: ");
    scanf("%s", filename);
    load_users_from_file(&system, filename);
}

int main()
{
    System system = {NULL, {NULL}, NULL};
    char input[256];

    while (1)
    {
        printf("Enter command: ");
        scanf("%s", input);
        while (getchar() != '\n')
            ;

        if (strcmp(input, SIGNUP) == 0)
            handle_signup(&system);
        else if (strcmp(input, LOGIN) == 0)
            handle_login(&system);
        else if (strcmp(input, LOGOUT) == 0)
            handle_logout(&system);
        else if (strcmp(input ,NEWCHAT) == 0)
            handle_newChat(&system);
        else if (strcmp(input, SELECTCHAT) == 0)
            handle_selectChat(&system);
        else if (strcmp(input, SENDMESSAGE) == 0)
            handle_sendMessage(&system);
        else if (strcmp(input, SHOWCHAT) == 0)
            handle_showChat(&system);
        else if (strcmp(input , LOADUSERS) == 0)
            handle_loadUsers(&system);
        else if (strcmp(input, EXIT) == 0)
            break;
        else
            printf("Unknown command.\n");
    }

    cleanup_system(&system);
    return 0;
}