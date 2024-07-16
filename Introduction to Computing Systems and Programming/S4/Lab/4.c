#include <stdio.h>

/*

line 28,12: we don't have i in this part and we should define

line 32, 31: an infinite loop because i is always 0 and is less then
15 so we should define outside 


*/

int main() {
    int z = 4;
    int i = 1 ; /*we should define an i here if we want to code works*/

    if (z - 4) { /*it is always false*/
        int i = 1;
        z = z + i;
    } else { /*so we always porduce this condition*/
        int i = 1; /*this var just for work here*/
        z = i + 1; /*z=5*/
        {
            int i = 1;
            z = i + 1; /*z=2*/
        }
        z = i; /*z=1*/
    }

    z = z + i; /*we don't have any i in this part*/

    i = 0;
    do {
        z = i + 1;
        i++;
    } while (i < 15);

    return 0;
}
