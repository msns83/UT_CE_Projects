#include <stdio.h>

int main(){

   char array[][4] = {{'a','b','c','d'},{'e','f','g','h'}}; /*if you want no warning you should put {} to define rows*/

   char (*ptr)[4] = array; /*it should be character because it points to charecter*/

   printf("%c %c\n", (*ptr)[2], (*ptr)[3]);

   ptr+=1; /*it shouldn't be 2 because we only have two row that means 0 and 1*/

   printf("%c %c\n", (*ptr)[2], (*ptr)[3]);

   return 0;
}