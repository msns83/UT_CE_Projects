#include <iostream>
#include <vector>
using namespace std ;

void printer(const vector<int>& numbers, vector<char>& signs) {
    int size = signs.size() ;

    for (int i = 0; i < size; i++)
        cout << numbers[i] << signs[i] ;

    cout << numbers[size] << '=' << numbers[size+1] << endl ;   
}

bool checker(int preResult, int start,const vector<int>& numbers, vector<char>& signs) {
    if (start == (numbers.size())-1) {
        if (preResult == numbers[(numbers.size())-1])
            return true ;
        return false ;
    }
    
    if(checker(preResult + numbers[start], start+1, numbers, signs)) {
        signs[start-1]= '+' ;
        return true ;
    }

    if (checker(preResult - numbers[start], start+1, numbers, signs)) {
        signs[start-1]= '-' ;
        return true ;
    }

    if (checker(preResult * numbers[start], start+1, numbers, signs)) {
        signs[start-1]= '*' ;
        return true ;
    }

    return false ;
}

vector<int> numberInput(int count){
    vector<int> numbers ;

    for (int i = 0; i < count; i++) {
        int number ;
        cin >> number ;
        numbers.push_back(number) ;
    }
    
    return numbers ;
}


int main() {
    int count ;
    cin >> count ;

    if (count <= 1)
        return 0 ;
    
    vector<int> numbers = numberInput(count) ;
    vector<char> signs(count-2, ' ') ;
    // the number of signs is one less than numbers and as we know the last one is '=' so we need (count-2)

    if(checker(numbers[0], 1, numbers, signs))
        printer(numbers, signs);
    else
        cout << "No Solution!" << endl ;

    return 0;
}