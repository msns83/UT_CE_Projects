#ifndef MESSAGE_H
#define MESSAGE_H

typedef struct MessageNode {
    char message[256];
    char author[50];
    struct MessageNode *next;
} MessageNode;

MessageNode *create_message(const char *text, const char *author);

#endif