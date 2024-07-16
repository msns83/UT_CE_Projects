#include <iostream>
using namespace std;

void f(int& y) {
    y = 1 ;
}

void g(int& x) {
    f(x) ;
}

int main() {

    int a = 10;
    int b = 14;

    g(a) ;

    cout << a << endl ;

    return 0;
}