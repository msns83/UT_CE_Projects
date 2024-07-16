#include <iostream>
#include <string>
using namespace std ;

void justAlphabet(string& sentence) {

    while ((sentence[0] < 'A' || 'Z' < sentence[0]) && (sentence[0] < 'a' || 'z' < sentence[0] )){
        if (sentence.size() == 0)
            break;
        sentence.erase(0,1) ;
    }

    if (sentence.size() != 0)
        while ((sentence[(sentence.size())-1] < 'A' || 'Z' < sentence[(sentence.size())-1]) && (sentence[(sentence.size())-1] < 'a' || 'z' < sentence[(sentence.size())-1] ))
            sentence.pop_back() ;
}

bool checker(string& sentence) {
    int capitalSmallDiff = 32 ;

    justAlphabet(sentence);

    if(sentence.size() <= 1)
        return true ;

    if ((sentence[0] != sentence[(sentence.size())-1]) && (abs(sentence[0] - sentence[(sentence.size())-1]) != capitalSmallDiff ) )
        return false ;
    
    sentence.pop_back();
    sentence.erase(0,1);

    if (checker(sentence))
        return true ;
    
    return false ;
}

void boolPrint(bool state){
    if (state == true)
        cout << "true" << endl ;
    else
        cout << "false" << endl ;
}

int main() {
	string sentence ;
	
    while (getline(cin, sentence, '\n'))
        boolPrint(checker(sentence)) ;
	
	return 0;
}