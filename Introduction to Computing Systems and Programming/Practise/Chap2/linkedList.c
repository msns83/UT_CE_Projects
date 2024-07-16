#include <stdio.h>
#include <string.h>
#include <stdlib.h>

typedef struct student std;

struct student{
char name[20];
int snum;
float grade;
std* next; //اشاره گر به محل دانشجوی بعدی
};

void printListOfStudents(std* tempStd){
    //عملیات چاپ اطلاعات در یک لیست زنجیره ای (لینکد لیست)
    while(tempStd != NULL){// تا زمانی که به اخرین گره نرسیده ایم اطلاعات را چاپ کن
        printf("student name: %s, std num= %d\n", tempStd->name, tempStd->snum);
        tempStd=tempStd->next;
    }
}

void enterStudents(std* myStudents){
    //اضافه کردن علی دایی بعنوان دانشجوی اول
    myStudents->next = (std *) malloc(sizeof(std)); // اول گره را اختصاص بده
    std* tempStd = myStudents->next; 
    tempStd->grade = 20; //اطلاغات گره را بنویس
    tempStd->snum = 1;
    strcpy(tempStd->name, "Ali Daei");
    tempStd->next = NULL; //چون آخرین گره است، گره ندارد و نول بنویس

    tempStd->next = (std *) malloc(sizeof(std)); // اول گره را اختصاص بده
    tempStd = tempStd->next;
    tempStd->grade = 19; //اطلاغات گره را بنویس
    tempStd->snum = 2;
    strcpy(tempStd->name, "Mehdi Taremi");
    tempStd->next = NULL; //چون آخرین گره است، گره ندارد و نول بنویس

}

int main() {

std* myStudents;

myStudents= (std *) malloc(sizeof(std)); //اختصاص حافظه برای حلقه اول لینکد لیست

if( !myStudents ){ //چک کن که آیا حافظه اختصاص داده شده یا خیر
    return 0 ;
} 

enterStudents(myStudents);

printListOfStudents(myStudents->next);
return 0 ;
}