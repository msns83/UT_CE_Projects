#include <stdio.h>

int main() {
    
    char msg[]= "hello" ;
    int count; 
    
    for (count = 0; msg[count] != '\0'; ++count);

    printf("%d\n", sizeof(msg) / sizeof(msg[0]));
    printf("%d", count);

    return 0;
}
