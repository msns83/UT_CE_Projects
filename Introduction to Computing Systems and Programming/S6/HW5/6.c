#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#define ARRAY_LENGTH 5

float calc_mean(float* data_array);
float calc_standard_deviation(float* data_array);
float calc_cv(float* data_array);

int main() {
    float data_array[ARRAY_LENGTH];

    for (int i = 0; i < ARRAY_LENGTH; i++){
        scanf("%f", &data_array[i]);
    }

    printf("%.1f", calc_cv(data_array));

    return 0;

}

float calc_mean(float* data_array) {
    float sum= 0 ;
    for (int i = 0; i < ARRAY_LENGTH; i++) {
        sum += *(data_array+i) ;
    }

    return sum/ARRAY_LENGTH ;
    
}

float calc_standard_deviation(float* data_array) {
    float sum = 0 ;
    float square = 0 ;
    float average = calc_mean(data_array);

    for (int i = 0; i < ARRAY_LENGTH; i++) {
        square = (*(data_array+i)-average)* (*(data_array+i)-average) ;
        sum += square ;
    }

    return sqrt(sum/ARRAY_LENGTH) ;

}

float calc_cv(float* data_array) {
    return calc_standard_deviation(data_array) / calc_mean(data_array);
}