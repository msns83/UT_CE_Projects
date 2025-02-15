#ifndef SYSTEM_H
#define SYSTEM_H

#include "user.h"

typedef struct System {
    User *logged_in_user;
    UserList user_list;
    Chat *current_chat;
} System;

void create_chat_between_users(System *system, const char *second_username, const char *chat_name);
void sign_up(System *system, const char *username, const char *password);
void log_in(System *system, const char *username, const char *password);
void log_out(System *system);
void select_chat(System *system, const char *chat_name);
void send_message_to_current_chat(System *system, const char *message_text);
void display_current_chat_messages(System *system);
void cleanup_system(System *system);
User *find_chat_receiver(System *system, Chat *current_chat);

#endif