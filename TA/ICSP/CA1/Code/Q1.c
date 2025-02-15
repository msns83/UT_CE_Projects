#include <stdio.h>

void count_vote(int row, int column);
void find_results(float positive, float negative, int absent);

#define POSITIVE 'P'
#define NEGATIVE 'N'
#define ABSENT 'A'

int main()
{
    int row, column;
    scanf("%d %d", &row, &column);

    count_vote(row, column);

    return 0;
}

void count_vote(int row, int column)
{
    float positive = 0;
    float negative = 0;
    int absent = 0;

    for (int i = 0; i < row; i++)
    {
        char sign;
        scanf("%c", &sign);
        for (int j = 0; j < column; j++)
        {
            scanf("%c", &sign);
            if (sign == ABSENT)
                absent++;
            else if (sign == POSITIVE)
                positive++;
            else if (sign == NEGATIVE)
                negative++;
        }
    }

    printf("Positive: %0.0f\n", positive);
    printf("Negative: %0.0f\n", negative);
    printf("Absent: %d\n", absent);

    find_results(positive, negative, absent);
}

void find_results(float positive, float negative, int absent)
{
    char result;
    if (negative < positive)
        result = POSITIVE;
    else if (negative == positive)
        result = ABSENT;
    else
        result = NEGATIVE;

    printf("P: %0.2f %%\n", (positive / (positive + negative)) * 100);
    printf("N: %0.2f %%\n", (negative / (positive + negative)) * 100);
    printf("Result: %c\n", result);
}