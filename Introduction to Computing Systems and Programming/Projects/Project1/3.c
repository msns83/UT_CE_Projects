#include <stdio.h>
#define null 404

int main(){

    int a, b, c , x ; /*coefficients and argument of Eq*/
    float errorRate; /*error rate*/
    float range; /*range that answer will find in it*/
    float answer1=null , answer2=null , answer3=null ; /*answers*/
    float test1 , test2 ; /*flags that we use to find answers*/

    printf("coefficient of x^2: "); /*taking infromation*/
    scanf("%d", &a);
    printf("coefficient of x: ");
    scanf("%d" , &b);
    printf("c of the Eq: ");
    scanf("%d", &c);
    printf("Please input error rate: ");
    scanf("%f", &errorRate);

    if (b <= a && c <= a){ /*finding the range. it is square of the greatest coefficient*/
        range = a*a;
    } else if ( a <= b && c <= b) {
        range = b*b;
    } else {
        range = c*c;
    }

    x = -range;
    test1= ((x*x*x)+(a*x*x)+(b*x)+c);

    for (float i = -range+errorRate; i < range; i+=errorRate) {
        test2 = ((i*i*i)+(a*i*i)+(b*i)+c);
        if (test2*test1<0){
            answer1 = i-(errorRate/2) ;
            break;
        }
        test1= ((i*i*i)+(a*i*i)+(b*i)+c);
    }

    x= answer1 + errorRate;
    test1= ((x*x*x)+(a*x*x)+(b*x)+c);
    
    for (float i = answer1+(2*errorRate); i < range; i+=errorRate) {
        test2 = ((i*i*i)+(a*i*i)+(b*i)+c);
        if (test2*test1<0){
            answer2 = i-(errorRate/2) ;
            break;
        }
        test1= ((i*i*i)+(a*i*i)+(b*i)+c);
    }

    x = answer2 + errorRate;
    test1= ((x*x*x)+(a*x*x)+(b*x)+c);
    
    for (float i = answer2+(2*errorRate); i < range; i+=errorRate) {
        test2 = ((i*i*i)+(a*i*i)+(b*i)+c);
        if (test2*test1<0){
            answer3 = i-(errorRate/2) ;
            break;
        }
        test1= ((i*i*i)+(a*i*i)+(b*i)+c);
    }
    
    if (answer1==null) { /*printing answers*/
        printf("bedoon rishe\n");
    }else{
        printf("%f\n", answer1);
    }

    if (answer2==null) {
        printf("bedoon rishe\n");
    }else{
        printf("%f\n", answer2);
    }

    if (answer3==null) {
        printf("bedoon rishe");
    }else{
        printf("%f", answer3);
    }

    return 0;
}