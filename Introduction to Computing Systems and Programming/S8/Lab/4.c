#include <stdio.h>
#include <stdlib.h>

#define ZERO 0
#define ONE 1
#define READ_CHAR_SIZE 100
#define WRITE_CHAR_SIZE 100
#define INPUT_TXT_ADDRESS "./input.txt"
#define OUTPUT_FILE_ADDRESS "./output.txt"

char* read_input_file(int *size) {
    FILE* input = fopen(INPUT_TXT_ADDRESS,"r" );
    char* in_order_array = (char*)malloc(READ_CHAR_SIZE * sizeof(char));
    * (in_order_array)= fgetc(input);
    while (!feof(input)) {
        fseek(input , 1 , SEEK_CUR );
        * (in_order_array+(*size)+1)= fgetc(input);
        *size += 1  ;
    }
    fclose(input);
    return in_order_array;
}

char* reverse_array(char* in_order_array, int size) {
    char *reversed_array = (char*)malloc(size * sizeof(char));
    for (int i = ZERO; i < size; i++){
        *(reversed_array+i) = *(in_order_array+size-ONE-i) ;
    }
    printf("\n");
    return reversed_array;
}

void write_reversed_array_in_file(char* in_order_array , int size) {
    char *reversed_array = reverse_array(in_order_array , size);
    FILE* output = fopen(OUTPUT_FILE_ADDRESS, "w");
    fwrite(reversed_array , sizeof(char) , size , output);
    fclose(output);
}

int main() {
    int size= 0 ;
    char* in_order_array = read_input_file(&size);
    write_reversed_array_in_file(in_order_array , size);
    return 0;
}