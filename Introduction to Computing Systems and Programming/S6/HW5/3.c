#include <stdio.h>

int main(){
    int array[100]={};

    for(int i=0;i<100;i++)
        array[i] = 3*i + 1;

    printf("%d\n", array);
    printf("%d\n", array[5]+1);
    printf("%d\n", &array[0]+1);

    return 0;
}