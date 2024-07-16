#include <iostream>
#include <string>
using namespace std;

double power(double num, int p) {

	double answer = num ;

	if (p == 0) {
		answer = 1 ;
	}

	for(int i=1 ; i < p ; i++) {
		answer *= num ;
	}

	return answer ;
}

double factorial(int num) {

	double result = 1 ;

	for(int i=2 ; i <= num ; i++) {
		result *= i ;
	}

	return result ;
}


int main() {

	double x ;
	int n ;
	double answer ;
	double tempNum ;

	cin >> x ;
	cin >> n ;

	if (n == 0) {
		cerr << "0 isn't valid\n" ;
		return 1;
	}

	for (int i=0 ; i < (n+1) ; i++ ) {

		tempNum = (power(2,i)/factorial(i)) * power(x,i) ;
		answer += tempNum ;
	}

	answer = static_cast<float>(static_cast<int>(answer * power(10, 2))) / power(10, 2) ;

	cout << answer << endl ;

	return 0 ;
}