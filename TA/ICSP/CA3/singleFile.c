#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define LOGIN "login"
#define SIGNUP "signup"
#define LOGOUT "logout"
#define NEWCHAT "newChat"
#define SELECTCHAT "selectChat"
#define SENDMESSAGE "sendMessage"
#define EXIT "exit"
#define SHOWCHAT "showChat"
#define LOADUSERS "loadUsers"





typedef struct MessageNode
{
    char message[256];
    char author[50];
    struct MessageNode *next;
} MessageNode;

typedef struct Chat
{
    char name[50];
    MessageNode *messages;
    struct Chat *next;
} Chat;

typedef struct ChatList
{
    Chat *head;
} ChatList;

typedef struct User
{
    char username[50];
    char password[50];
    ChatList chat_list;
    struct User *next;
} User;

typedef struct UserList
{
    User *head;
} UserList;

typedef struct System
{
    User *logged_in_user;
    UserList user_list;
    Chat *current_chat;
} System;

MessageNode *create_message(const char *text, const char *author)
{
    MessageNode *new_message = (MessageNode *)malloc(sizeof(MessageNode));
    strcpy(new_message->message, text);
    strcpy(new_message->author, author);
    new_message->next = NULL;
    return new_message;
}

void add_message_to_chat(Chat *chat, const char *text, const char *author)
{
    MessageNode *new_message = create_message(text, author);
    new_message->next = chat->messages;
    chat->messages = new_message;
}

Chat *create_chat(const char *name)
{
    Chat *new_chat = (Chat *)malloc(sizeof(Chat));
    strcpy(new_chat->name, name);
    new_chat->messages = NULL;
    new_chat->next = NULL;
    return new_chat;
}

void add_chat(ChatList *chat_list, Chat *new_chat)
{
    new_chat->next = chat_list->head;
    chat_list->head = new_chat;
}

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


void send_message_to_current_chat(System *system, const char *message_text)
{   
    add_message_to_chat(system->current_chat, message_text, system->logged_in_user->username);
}

void display_messages_recursively(MessageNode *msg)
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

char *get_user_message()
{
    char buffer[512];
    int index = 0;
    char ch;

    while ((ch = getchar()) != '\n' && ch != EOF && index < 511)
    {
        buffer[index++] = ch;
    }

    buffer[index] = '\0';

    char *message = (char *)malloc(index + 1);

    if (message == NULL)
    {
        printf("Memory allocation failed.\n");
        exit(1);
    }

    strcpy(message, buffer);
    return message;
}

void cleanup_system(System *system)
{
    free_users(system->user_list.head);
    system->logged_in_user = NULL;
    system->current_chat = NULL;
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

int main()
{
    System system = {NULL, {NULL}, NULL};

    char input[256];

    while (1)
    {
        printf("Enter command: ");
        if (fgets(input, sizeof(input), stdin) == NULL)
        {
            break;
        }

        input[strcspn(input, "\n")] = 0;

        if (strncmp(input, SIGNUP, 6) == 0)
        {
            char username[50], password[50];
            printf("Username: ");
            scanf("%s", username);
            printf("Password: ");
            scanf("%s", password);
            sign_up(&system, username, password);
            while (getchar() != '\n')
                ;
        }
        else if (strncmp(input, LOGIN, 5) == 0)
        {
            if (system.logged_in_user != NULL){
                printf("Error: There is an open session, please logout first.\n");
                continue;
            }
            char username[50], password[50];
            printf("Username: ");
            scanf("%s", username);
            printf("Password: ");
            scanf("%s", password);
            log_in(&system, username, password);
            while (getchar() != '\n')
                ;
        }
        else if (strncmp(input, LOGOUT, 6) == 0)
        {
            log_out(&system);
        }
        else if (strncmp(input, NEWCHAT, 15) == 0)
        {
            char selected_user[50];
            char chat_name[50];
            printf("Enter chat name: ");
            scanf("%s", chat_name);
            printf("Enter selected username: ");
            scanf("%s", selected_user);
            create_chat_between_users(&system, selected_user, chat_name);
            while (getchar() != '\n')
                ;
        }
        else if (strncmp(input,SELECTCHAT, 11) == 0)
        {
            char chat_name[50];
            printf("Enter chat name: ");
            scanf("%s", chat_name);
            select_chat(&system, chat_name);
            while (getchar() != '\n')
                ;
        }
        else if (strncmp(input, SENDMESSAGE, 12) == 0)
        {
            if (system.current_chat == NULL){
                printf("Error: No chat selected. Please select a chat first.\n");
                continue;
            }
            printf("Reciver: %s\n" , find_chat_receiver(&system, system.current_chat)->username);
            printf("Enter message: ");
            send_message_to_current_chat(&system, get_user_message());
        }
        else if (strncmp(input, EXIT , 4) == 0)
        {
            break;
        }
        else if (strncmp(input,SHOWCHAT , 8) == 0)
        {
            display_current_chat_messages(&system);
        }
        else if (strncmp(input, LOADUSERS , 9) == 0)
        {
            char filename[256];
            printf("Enter filename: ");
            scanf("%s", filename);
            load_users_from_file(&system, filename);
            while (getchar() != '\n')
                ;
        }
        else
        {
            printf("Unknown command.\n");
        }
        
    }

    cleanup_system(&system);

    return 0;
}
