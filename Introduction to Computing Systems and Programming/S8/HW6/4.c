#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define true 1

typedef struct Point{
    int x;
    int y;
} Point;

typedef struct Node_type{
    Point point ;
    struct Node_type* next ;
} Node;

Node* convert(Point arr[1000], int size){

    Node* head = (Node*) malloc(sizeof(Node));
    head->next = NULL ;

    for (int i = 0; i < size; i++) {
        int counter = 0; //to find right place for puting node
        Node* newNode = (Node*) malloc(sizeof(Node)) ;
        newNode->point = arr[i];
        Node* tempNode = head ;

        while (true){
            if (counter == i) {
                newNode->next = tempNode->next ;
                tempNode->next = newNode ;
                break;
            }

            counter++;
            tempNode = tempNode->next;
        }     
    }
    return head ;
}

void print_distance(Node* head){
    Node* tempNode = head->next ;

    while (tempNode != NULL && tempNode->next != NULL) {
        double x = (tempNode->next->point.x)-(tempNode->point.x);
        double y = (tempNode->next->point.y)-(tempNode->point.y);
        double distance = sqrt( (x*x)+(y*y) );
        printf("%lf\n",distance);
        tempNode = tempNode->next ;
    }
     
}
