#include <stdio.h>

/*this program take number of days that you eat and number of food's type that you eat each day
then it says that you become fat or not */

/*it works with calorie and if remain clorie is postive it means obesity otherwise thiness or without change */

/* remain calorie is takedcalorie - usedcalorie*/

/*used calorie for each day is 100*/

int main(){

    int days; /*days we check*/
    int typeOfFood; /*number of food type*/
    int foodCalorie = {329,127,61,83,156,296,496,73,34,16}; /*list of food's calorie*/
    int CalorieInTake=0; /*calorie you get from foods*/
    int remainCalorie; /*remain calorie*/

    printf("Please input number of days: "); /*taking days of checking*/
    scanf("%d", &days);

    for (int i = 0; i < days; i++) { 
        printf("number of food: "); /*asking type of food for number of days*/
        scanf("%d", &typeOfFood); 

        if (10 < typeOfFood || typeOfFood < 1 ) { /*type of food validation*/
            printf ("Wrong food number");
            return 0;
        }

        switch (typeOfFood) { /*finding input food's Calorie*/
        case 1 :
            foodCalorie= 329;
            break;
        
        case 2:
            foodCalorie= 127;
            break;

        case 3:
            foodCalorie= 61;
            break;

        case 4:
            foodCalorie= 83;
            break;
        
        case 5 :
            foodCalorie= 156;
            break;
        
        case 6:
            foodCalorie= 296;
            break;

        case 7:
            foodCalorie= 496;
            break;

        case 8:
            foodCalorie= 73;
            break;
        
        case 9:
            foodCalorie= 34;
            break;
        
        case 10:
            foodCalorie= 16;
            break;

        default:
            break;
        }
         
        CalorieInTake = CalorieInTake + foodCalorie ; /*calorie you get from food*/
    }

    remainCalorie = CalorieInTake - (100*days) ; /*process of remain calorie*/

    if (remainCalorie > 0) { /*printing the result*/
        printf("chag");
    } else if (remainCalorie < 0) {
        printf("laghar");
    } else {
        printf("bedoon taghir");
    }
    
    return 0;
}