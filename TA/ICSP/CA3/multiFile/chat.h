#ifndef CHAT_H
#define CHAT_H

#include "message.h"

typedef struct Chat {
    char name[50];
    MessageNode *messages;
    struct Chat *next;
} Chat;

typedef struct ChatList {
    Chat *head;
} ChatList;

Chat *create_chat(const char *name);
void add_chat(ChatList *chat_list, Chat *new_chat);
void add_message_to_chat(Chat *chat, const char *text, const char *author);

#endif