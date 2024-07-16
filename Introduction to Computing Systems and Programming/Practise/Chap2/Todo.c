#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define null -7 ;

typedef struct workType work ;

struct workType{
    int number ;
    char name[30];
    int time[5] ;
    work * next ;
};

void printTasks(work *tempTask);
void addTask(work *firstNode);

int main(){

    int powerButton = 1 ;
    int userSelect = null ;
    work * myTasks= NULL ;

    myTasks = (work*) malloc(sizeof(work)) ;

    myTasks->number = 0 ;
    myTasks->next = NULL ;

    while (powerButton == 1) {
        printf("\nHello this is Your ToDo List\nWhat do you want to do ?\n\n");
        printf("1. See your tasks\n");
        printf("2. Add a task\n");
        printf("3. Edit a task\n");
        printf("4. Delete a task\n");
        printf("0. Exit\n\n");

        printf("please enter your Choice (from 0 to 4): ");
        scanf("%d", &userSelect);
        

        switch (userSelect) {
        case 1:
            printTasks(myTasks);
            break;

        case 2:
            addTask(myTasks);
            break;

        case 3:
            printf("\nComing Soon!\n");
            break;

        case 4:
            printf("\nComing Soon!\n");
            break;

        case 0:
            printf("\nBye!\n");
            powerButton = 0 ;
            break;
        default:
            printf("I think we have a wrong Choice! please try again\n\n");
            fflush(stdin);
            break;
        }

    }
    
    return 0 ;
}

void addTask(work *firstNode){
    work * tempTask = firstNode ;
    work * newTask ;
    int count = 0 ;
    int node = 0 ;

    newTask = (work *) malloc(sizeof(work));

    printf("New Task Number (greater than 0): ");
    scanf("%d", &(newTask->number));
    printf("New Task name (one word): ");
    scanf("%s", newTask->name);


    while (tempTask->next != NULL) {
        count++;
        tempTask = tempTask->next ;
    }

    tempTask =firstNode ;
    for (int i = 0; i <= count ; i++) {
        if (newTask->number <= tempTask->number) {
            break;
        }
        node = i ;
        tempTask = tempTask->next ;
    }

    newTask-> next = tempTask ;

    tempTask = firstNode ;
    for (int i = 0; i < node; i++) {
        tempTask = tempTask->next ;
    }

    tempTask->next = newTask ;
}

void printTasks(work *tempTask){

    int powerButton= 1 ;
    int count=0 ;
    
    tempTask = tempTask->next ;

    while (powerButton != 0) {
        while(tempTask != NULL) {
            printf("\nTask Number: %d , Take Name: %s\n",tempTask->number,tempTask->name);
            count ++ ;
            tempTask=tempTask->next;
        }

        if (count == 0) {
            printf("\nEmpty\n");
        }
        
        printf("\nenter 0 for exit of the list: ");
        scanf("%d", &powerButton);
        fflush(stdin);
    }
    
}