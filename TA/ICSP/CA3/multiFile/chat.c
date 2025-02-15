#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "chat.h"
#include "message.h"

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

void add_message_to_chat(Chat *chat, const char *text, const char *author)
{
    MessageNode *new_message = create_message(text, author);
    new_message->next = chat->messages;
    chat->messages = new_message;
}