#include <stdio.h>

/*this program help you with area of jump and times of jump */

/*room number you get from user has three digits frist one is floor and next two numbers
are room number in that floor*/

/*area 1: room 1-4 , area 2: room 5-8 , area 3: room 9-12  area 4: room 13-16 */

/*height of jumps is half of first jump's height*/

/*height of each floor is 2 meter*/

/*you should reach to the middle of destiny floor  (2*floor number)+1 */

int main() {
    
    int roomNumber; /*get it from user*/
    int floor;
    int roomMainNumber; /*number of room in that floor*/
    int area;
    float heightOfFirstJump; /*get it from user*/
    float height= 0; /*the current height in each level*/
    int time= 0; /*times you need to jump*/

    printf("Please input the room number: ");
    scanf("%d", &roomNumber); /*taking room number*/

    floor = roomNumber/100; /*processing floor and room number in that floor*/
    roomMainNumber= roomNumber%100;

    if (1 <=roomMainNumber && roomMainNumber <= 4){ /*finding the area of jump*/
        area= 1;
    } else if (5 <=roomMainNumber && roomMainNumber <= 8) {
        area= 2;
    } else if (9 <=roomMainNumber && roomMainNumber <= 12) {
        area= 3;
    } else if (13 <=roomMainNumber && roomMainNumber <= 16) {
        area= 4;
    } else {
        printf("Wrong room number!\n"); /*validation of room number we can accept up to 16*/
        return 0;
    }
    
    printf("Please input the height of first: ");
    scanf("%f", &heightOfFirstJump); /*taking hieght of first jump*/

    if ((2*floor)+1 < heightOfFirstJump) {
        printf("this jump will pass you floor !"); /*validation of first jump that we don't pass the floor*/
        return 0;
    }
    

    while (height < ((2*floor)+1)-heightOfFirstJump ) { /*testing and finding times of jump that we need*/
        ++time;
        height = time*(heightOfFirstJump/2);
    }

    printf("%d\n", area); /*printing area of the jump and times of the jump*/
    printf("%d", time);

    return 0;
}