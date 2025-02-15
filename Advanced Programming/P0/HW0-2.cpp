#include <iostream>
#include <vector>
#include <string>
using namespace std;

int filler(vector<int>* vec, int n1, int n2, int n3 , int n4) {
	(*vec).push_back(n1) ;
	(*vec).push_back(n2) ;
	(*vec).push_back(n3) ;
	(*vec).push_back(n4) ;

	return 0 ;
}

int subChecker(vector<int> modified, vector<int> test) {

	for (int i = 0; i < 3; i++) {
		if (modified[0] == test[i]) {
			for (int j = 0; j < 3; j++) {
				if (modified[1] == test[j]) {
					for (int k = 0; k < 3; k++) {
						if (modified[2] == test[k]) {
							return modified[3] ;
						}
					}
				}
			}
		}
	}

	return -1 ;
}

int checker(vector<int> triple) {

	int flag=0 ;

	vector<string> state(6);
	state[0] = "Khoshbakht" ;
	state[1] = "Badbakht" ;
	state[2] = "Pooldar" ;
	state[3] = "Faghir" ;
	state[4] = "OmreToolani" ;
	state[5] = "JavoonMarg" ;

	vector<vector<int> > modified(6) ;
	filler(&modified[0],1,2,3,0);
	filler(&modified[1],12,3,6,1);
	filler(&modified[2],6,8,22,2);
	filler(&modified[3],10,22,48,3);
	filler(&modified[4],13,14,15,4);
	filler(&modified[5],33,15,18,5);

	for (int i = 0; i < 6; i++) {
		int stateNum = subChecker(modified[i], triple) ;
		if(stateNum != -1) {
			cout << state[stateNum] << endl ;
			flag = 1 ;
		}
	}

	return flag ;
}


int main() {
	
	vector<vector<int> > groups(16);
	int num ;
	int flag = 0 ;

	for (int i = 0 ; i < 16 ; i++) {
		for (int j = 0; j < 3; j++) {
			cin >> num ;
			groups[i].push_back(num) ;
		}
	}


	for (int i = 0 ; i < 16; i++) {
		if (checker(groups[i]) == 1) {
			flag = 1;
		}
	}

	if (flag == 0) {
		cout << "Bakhtet Pake!" << endl ;
	}

	return 0;
}