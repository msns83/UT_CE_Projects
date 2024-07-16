#include <stdio.h>
#include <stdlib.h>

#define header 154

int main(){
    char detail[154] ;
    int rgb[50][50][3] ;
    FILE *input = fopen("./input2.bmp", "rb");
    for (int i = 0; i < header; i++){
        detail[i]= fgetc(input);
    }
    for (int i = 0; i < 50; i++) {
        for (int j = 0; j < 50; j++) {
            rgb[i][j][0] = fgetc(input)+100 ; 
            rgb[i][j][1] = fgetc(input)+100 ;
            rgb[i][j][2] = fgetc(input)+100 ;
        }
    }
    FILE *output = fopen("./output.bmp", "wb");
    for (int i = 0; i < header; i++){
        fputc(detail[i],output);
    }
    for (int i = 0; i < 50; i++) {
        for (int j = 0; j < 50; j++) {
            fputc(rgb[i][j][0],output);
            fputc(rgb[i][j][1],output);
            fputc(rgb[i][j][2],output);
        }
    }
    fclose(input);
    fclose(output);
    return 0 ; 
}