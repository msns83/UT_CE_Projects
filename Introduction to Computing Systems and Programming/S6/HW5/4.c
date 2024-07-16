#include <stdio.h>
int main() {
    FILE* my_file = fopen("file.txt", "w");
    fputs("Help", my_file);
    fseek(my_file, 3, SEEK_SET);
    fputs("local", my_file);
    fseek(my_file,5, SEEK_SET);
    fputs("Friday", my_file);
    fseek(my_file, 8, SEEK_SET);
    fputs("end!", my_file);
    fclose(my_file);
}