#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define ZERO 0
#define ONE 1
#define true 1

typedef struct icsp_student icsp_std;

struct icsp_student {
    char* first_name;
    char* last_name;
    char* student_number;
    float mid_term_exam_score;
    float final_exam_score;
    float homework_score;
    icsp_std* next ;
};

int endList(icsp_std* node);
icsp_std* makeList();
int add_to_i(icsp_std* head_of_list, icsp_std* new_std, int i);
char* read_line_from_input_file(FILE* input);
icsp_std** read_students_credentials_from_file(int* num_of_lines);
void printListOfStudents(icsp_std* tempStd);
icsp_std* finder(icsp_std* head, char* stdNum);
int remove_from_i(icsp_std* head_of_list, int i);
int print_reverse(icsp_std *head);
int delete_all(icsp_std *head);
int list_length(icsp_std *head);

int main(){
    int num_of_lines=0 ;
    char stdNum[15]= "810195001" ;
    int flag=0 ;

    icsp_std* head =  makeList();
    icsp_std** new = read_students_credentials_from_file(&num_of_lines);
    for (int i = 0; i < num_of_lines; i++) {
        flag = add_to_i(head, new[i] , i );
    }
    // printListOfStudents(head);

    
    // icsp_std* finded = finder(head,stdNum) ;

    // if (finded != NULL) {
    //     printf("finded: %s\n\n", finded->last_name );
    // }
    // flag = remove_from_i(head, 1);

    // printListOfStudents(head);


    flag = print_reverse(head);

    printf("list length: %d\n\n", list_length(head));

    flag = delete_all(head);

    printf("list deleted\nlist length: %d\n\n", list_length(head));

    return 0 ;

    
}

icsp_std* makeList(){ //first part
    icsp_std* firstNode = (icsp_std*) malloc(sizeof(icsp_std));
    firstNode->final_exam_score = -1.0 ;
    firstNode->homework_score = -1.0 ;
    firstNode->mid_term_exam_score= -1.0 ;
    firstNode->next = NULL ;

    return firstNode;
}

int endList(icsp_std* node){ //second part
    int result = 0 ;
    if (node->next == NULL) {
        result = 1 ;
    }
    return result ;
}

// int set_new_std_next_of_head(icsp_std* head_of_list,icsp_std* new_std) {   //part 3.1
//      if (new_std == NULL || head_of_list == NULL)
//            return 0;
//      head_of_list->next = new_std; // -> this line and next one should be replaced
//      new_std->next = head_of_list->next;
//      return 1;
// }

int add_to_i(icsp_std* head_of_list, icsp_std* new_std, int i) { //part 3.2

    if (head_of_list == NULL)
        return ZERO;

    icsp_std* current_std = head_of_list;

    if (current_std->next == NULL && i == 0) {
        current_std->next = new_std ;
        return ONE;
    }else if(current_std->next == NULL && i != 0){
        return ZERO;
    }

    int counter = ZERO;
    
    while (true){

        if (counter == i) {
            new_std->next = current_std->next ;
            current_std->next = new_std ;
            return ONE;
        }

        counter++;

        if (current_std->next == NULL && counter == i) {
            new_std->next = current_std->next ;
            current_std->next = new_std ;
            return ONE;
        }

        if (current_std->next == NULL && counter < i) {
            return ZERO;
        }

        current_std = current_std->next;
    }     
}

char* read_line_from_input_file(FILE* input) { //part 4
	int line_length = ZERO;
	char* line = (char*)malloc(sizeof(char));
	*(line) = '0';
	char temp_char[1] = {' '};
	while (true) {
		fread(temp_char, sizeof(char), ONE, input);
		line_length++;
		line = (char*)realloc(line, sizeof(char) * line_length);
		line[line_length - ONE] = NULL;
		switch (temp_char[ZERO]){
			case '\n' :
				return line;
				break;
			case EOF : 
				return line;
				break;
			default:
				line[line_length - ONE] = temp_char[ZERO];
				break;
		}	
	}
}

icsp_std** read_students_credentials_from_file(int* num_of_lines) { //part 4 main
	FILE* input;

	if (input = fopen("./input.txt", "r")) {
		*num_of_lines = atoi(read_line_from_input_file(input));
		icsp_std** students = (icsp_std**) malloc(sizeof(icsp_std*) * (*num_of_lines));
		for (int i = 0; i < (*num_of_lines); i++) {
			icsp_std* std = (icsp_std*)malloc(sizeof(icsp_std));
			std->first_name = read_line_from_input_file(input);
			std->last_name = read_line_from_input_file(input);
			std->student_number = read_line_from_input_file(input);
			std->mid_term_exam_score = atof(read_line_from_input_file(input));
			std->final_exam_score = atof(read_line_from_input_file(input));
			std->homework_score = atof(read_line_from_input_file(input));
			std->next = NULL ;
			students[i] = std;
		}
		fclose(input);
		return students;
	}
	return NULL;
}

void printListOfStudents(icsp_std* tempStd){ // to test everything is working
    tempStd = tempStd->next ;

    while(tempStd != NULL){
        printf("student first name: %s\n", tempStd->first_name);
        printf("student last name: %s\n", tempStd->last_name);
        printf("student last name: %s\n", tempStd->student_number);
        printf("\n");
        tempStd=tempStd->next;
    }
}

icsp_std* finder(icsp_std* head,char* stdNum){ //part5
    icsp_std* tempStudent = head->next ;
    int result = 0 ;


    while (tempStudent != NULL) {
        result = strcmp(stdNum , tempStudent->student_number);
        if (result== -13) {
            return tempStudent ;
        }
        tempStudent = tempStudent->next ;
    }

    printf("there is no such a student! \n");
    return tempStudent ;
}

int remove_from_i(icsp_std* head_of_list, int i) { //part 6

    if (head_of_list == NULL)
        return ZERO;

    icsp_std* current_std = head_of_list;
    icsp_std* trash_std ;

    if (current_std->next == NULL) {
        return ZERO;
    }

    int counter = ZERO;
    
    while (true){

        if (counter == i && current_std->next != NULL) {
            trash_std = current_std->next ;
            current_std->next = current_std->next->next ;
            free(trash_std);
            return ONE;
        }

        counter++;

        if (current_std->next == NULL && i < counter) {
            return ZERO;
        }

        current_std = current_std->next;
    }     
}

int list_length(icsp_std *head){ //part 7.5
    int length = 0 ;
    icsp_std* tempStudent = head->next ;

    while (tempStudent != NULL) {
        length++;
        tempStudent = tempStudent->next ;
    }
    
    return length ;
} 

int print_reverse(icsp_std *head){ //part 7.1
    int length = list_length(head);
    icsp_std* tempStudent = head->next ;
    if (tempStudent == NULL){
        return 0 ;
    }
    
    
    for (int j = length; 0 < j; j--) {
        tempStudent = head->next;
        for (int i = 0; i < j-1 ; i++) {
            tempStudent = tempStudent->next;
        }
        printf("student first name: %s\n", tempStudent->first_name);
        printf("student last name: %s\n", tempStudent->last_name);
        printf("student last name: %s\n", tempStudent->student_number);
        printf("\n");
    }
    
    return 1 ;
}

int delete_all(icsp_std *head){ //part 7.4
    int length = list_length(head);
    length-- ;
    if (head->next == NULL) {
        return 0 ;
    }
    for ( length ; 0 <= length; length--){
        remove_from_i(head , length );
    }
    return 1 ;

}