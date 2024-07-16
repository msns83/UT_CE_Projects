#include <stdio.h>

int main(){
    int x[0], a=2;
    int *b = &a, *x_ptr= x; /*add & to a we should pass an adress but we pass a value it means second cell in computer , remove & from x , x is an array so it's name is an adress and we don't need &*/
    scanf("%d %d",b, x_ptr);
    printf("a=%d , x=[%d]\n",*b , x[0]); /*remove * , we don't need to use pointer for a vlaue x[0] is a value */
    return 0;
}