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
    while (!feof(input)) {
        * (in_order_array+(*size))= fgetc(input);
        *size += 1  ;
    }
    (*size) -= 1 ;
    fclose(input);
    return in_order_array;
}

void write_reversed_array_in_file(char* in_order_array , int size) {
    char *reversed_array = in_order_array ;
    FILE* output = fopen(OUTPUT_FILE_ADDRESS, "a");
    fprintf(output,"\n");
    fwrite(reversed_array , sizeof(char) , size , output);
    fclose(output);
}

int main() {
    int size= 0 ;
    char* in_order_array = read_input_file(&size);
    write_reversed_array_in_file(in_order_array , size);
    return 0;
}