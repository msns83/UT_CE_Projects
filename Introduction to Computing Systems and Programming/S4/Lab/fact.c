#include "fact.h"

int fact(int x){ /*factorial function*/

    int result=1;

    for (int i = 1; i < x+1; i++){
        result= result*i; /*multiplication of number and (number +1)*/
    }

    return result;
}