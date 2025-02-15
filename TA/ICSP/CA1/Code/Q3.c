#include <stdio.h>

#define SUM_SYMBOL '+'
#define MULT_SYMBOL '*'
#define WRONG_SYMBOL "Wrong symbol"

int main()
{
    char command_type;
    int numbers_count;

    scanf("%c %d", &command_type, &numbers_count);

    int result;

    if(command_type == SUM_SYMBOL)
    {
        result = 0;

        for(int i = 0; i < numbers_count; i++)
        {
            int new_number;
            scanf("%d", &new_number);

            result += new_number;
        }    

        printf("%d", result);   
    }

    else if(command_type == MULT_SYMBOL)
    {
        result = 1;
        for(int i = 0; i < numbers_count; i++)
        {
            int new_number;
            scanf("%d", &new_number);

            result *= new_number; 
        }

        printf("%d", result);          
    }

    else
    {
        printf("%s", WRONG_SYMBOL);
    }

    return 0;
}