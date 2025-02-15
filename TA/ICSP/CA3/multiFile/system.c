#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "system.h"
#include "chat.h"
#include "message.h"

void create_chat_between_users(System *system, const char *second_username, const char *chat_name)
{
    if (system->logged_in_user == NULL)
    {
        printf("Error: No user is currently logged in.\n");
        return;
    }
    
    User *user1 = system->logged_in_user;
    User *user2 = NULL;
    User *temp = system->user_list.head;

    while (temp != NULL)
    {
        if (strcmp(temp->username, second_username) == 0)
        {
            user2 = temp;
            break;
        }
        temp = temp->next;
    }

    if (user2 == NULL)
    {
        printf("Error: User '%s' not found.\n", second_username);
        return;
    }

    if (user1 == user2)
    {
        printf("Error: You cannot create a chat with yourself.\n");
        return;
    }

    Chat *temp_chat = user1->chat_list.head;
    while (temp_chat != NULL)
    {
        if (strcmp(temp_chat->name, chat_name) == 0)
        {
            printf("Error: Chat with name '%s' already exists.\n", chat_name);
            return;
        }
        temp_chat = temp_chat->next;
    }

    Chat *new_chat = create_chat(chat_name);

    add_chat(&user1->chat_list, new_chat);
    add_chat(&user2->chat_list, new_chat);

    printf("Chat with name '%s' created between '%s' and '%s'.\n", chat_name, user1->username, user2->username);
}

void sign_up(System *system, const char *username, const char *password)
{
    User *temp = system->user_list.head;
    while (temp != NULL)
    {
        if (strcmp(temp->username, username) == 0)
        {
            printf("Error: Username '%s' already exists.\n", username);
            return;
        }
        temp = temp->next;
    }
    add_user(&system->user_list, username, password);
    printf("User '%s' successfully registered!\n", username);
}

void log_in(System *system, const char *username, const char *password)
{
    User *temp = system->user_list.head;
    while (temp != NULL)
    {
        if (strcmp(temp->username, username) == 0 && strcmp(temp->password, password) == 0)
        {
            system->logged_in_user = temp;
            printf("User '%s' logged in successfully!\n", username);
            return;
        }
        temp = temp->next;
    }
    printf("Error: Invalid username or password.\n");
}

void log_out(System *system)
{
    if (system->logged_in_user != NULL)
    {
        printf("User '%s' logged out successfully!\n", system->logged_in_user->username);
        system->logged_in_user = NULL;
        system->current_chat = NULL;
    }
    else
    {
        printf("Error: No user is currently logged in.\n");
    }
}

void select_chat(System *system, const char *chat_name)
{
    if (system->logged_in_user == NULL)
    {
        printf("Error: No user is currently logged in.\n");
        return;
    }

    Chat *chat = system->logged_in_user->chat_list.head;
    while (chat != NULL)
    {
        if (strcmp(chat->name, chat_name) == 0)
        {
            system->current_chat = chat;
            printf("Chat '%s' has been selected as the current chat\n", chat_name);
            return;
        }
        chat = chat->next;
    }

    printf("Error: Chat '%s' not found for user '%s'.\n", chat_name, system->logged_in_user->username);
}

void send_message_to_current_chat(System *system, const char *message_text)
{
    add_message_to_chat(system->current_chat, message_text, system->logged_in_user->username);
}

static void display_messages_recursively(MessageNode *msg)
{
    if (msg == NULL)
        return;
    display_messages_recursively(msg->next);
    printf("%s: %s\n", msg->author, msg->message);
}

void display_current_chat_messages(System *system)
{
    if (system->current_chat == NULL)
    {
        printf("Error: No chat selected. Please select a chat first.\n");
        return;
    }
    printf("Messages in Chat '%s':\n", system->current_chat->name);
    display_messages_recursively(system->current_chat->messages);
}

void cleanup_system(System *system)
{
    free_users(system->user_list.head);
    system->logged_in_user = NULL;
    system->current_chat = NULL;
}


User *find_chat_receiver(System *system, Chat *current_chat){
    if (current_chat == NULL || system->logged_in_user == NULL)
        return NULL;

    User *temp_user = system->user_list.head;

    while (temp_user != NULL){
        if (temp_user == system->logged_in_user){
            temp_user = temp_user->next;
            continue;
        }

        Chat *temp_chat = temp_user->chat_list.head;
        while (temp_chat != NULL){
            if (temp_chat == current_chat)
                return temp_user;
            temp_chat = temp_chat->next;
        }

        temp_user = temp_user->next;
    }

    return NULL;
}
