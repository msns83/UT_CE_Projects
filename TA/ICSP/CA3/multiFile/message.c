#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "message.h"

MessageNode *create_message(const char *text, const char *author)
{
    MessageNode *new_message = (MessageNode *)malloc(sizeof(MessageNode));
    strcpy(new_message->message, text);
    strcpy(new_message->author, author);
    new_message->next = NULL;
    return new_message;
}