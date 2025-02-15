#include <stdio.h>

#define NOT_POSSIBLE -1

int main()
{
    int time = 0;
    double weight_a, weight_b;
    double growth_rate_a, growth_rate_b; 
    scanf("%lf %lf", &weight_a, &weight_b);
    scanf("%lf %lf", &growth_rate_a, &growth_rate_b);

    if(weight_a <= weight_b && growth_rate_a <= growth_rate_b)
    {
        time = NOT_POSSIBLE;
    }

    else
    {
        while(weight_a <= weight_b)
        {
            weight_a *= growth_rate_a;
            weight_b *= growth_rate_b;
            time++;
        }
    }    

    printf("%d", time);

    return 0;
}