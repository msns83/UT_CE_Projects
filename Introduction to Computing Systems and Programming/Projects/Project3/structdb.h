#ifndef STRCT
#define STRCT

typedef struct User_type { // structure of users
    int ID ; //user ID get used for check unrepeated likes
    char* username; // user username
    char* password ;  //user password
    int postCount ;
    struct User_type* next ; // addrass of next user of the list
} user;

typedef struct Post_type { // structure of posts
    int ID ; //post Id get used for liking and deleting
    char* username; // author username
    char *text ; // the content of the post
    int likes; // number of likes
    int* likers ; // IDs of likers of the post 
    struct Post_type* next ; // address of next post in list
}post ;

#endif