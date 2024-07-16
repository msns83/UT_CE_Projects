#include <stdio.h>
#include <stdlib.h> 

int main() {

    int arr_size, i;
    int* dynamic_arr;

    printf("Enter the size of array:\n");
    scanf("%d", &arr_size);

    /* Requesting an integer array with capacity of arr_size elements.
    * On success dynamic_arr will be a pointer to the beginning of the array.
    * On failure dynamic_arr will be null. */

    dynamic_arr = (int*) malloc (arr_size * sizeof(int));

    if (dynamic_arr == NULL) {
        printf("Oops! Memory allocation failed.\n");
        exit(EXIT_FAILURE);
    }

    /* From now on you can work with the dynamic array just like static arrays!*/

    printf("Enter %d numbers:\n", arr_size);
    for (i = 0; i < arr_size; i++){
        scanf("%d", &dynamic_arr[i]);
    }
    
    for (int i = 0; i < arr_size; i++) {
        printf("-%d\n", dynamic_arr[i]);
    }

    free(dynamic_arr); /* Do not forget to free the allocated memory! */
    
    return 0;
}