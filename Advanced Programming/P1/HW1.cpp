#include <iostream>
#include <string>
#include <vector>
#include <cmath>
using namespace std;

void enteringLines(vector<string>& lineNames, vector<int>& arriveTimes) {
	string lineName ;
		int arriveTime ;

		cin >> lineName ;
		lineNames.push_back(lineName) ;

		cin >> arriveTime ;
		arriveTimes.push_back(arriveTime);
}

void enteringStations(vector<string>& stationNames, vector<int>& stationTimes) {
	int count ;
	cin >> count ;

	for (int i = 0; i < count; i++) {
			int time ;
			string name ;

			cin >> time ;
			cin >> name ;

			stationNames.push_back(name) ;
			stationTimes.push_back(time) ;
		}
}

void numberingStations(vector<string>& stationNames, vector<int>& stationTimes, vector<vector<int> >& lineInfs) {
	vector<int> lineInf(3) ;

	lineInf[0]= stationNames.size() ;

	for (int i = 1; i <= 2 ; i++) {
		enteringStations(stationNames, stationTimes) ;
		lineInf[i]= (stationNames.size())-1 ;
	}

	lineInfs.push_back(lineInf);
}

void gettingTime(vector<int>& currentTime) {
	char sign ;
	cin >> currentTime[0] >> sign >> currentTime[1] ;
}

int findStation(vector<string>& stationNames, string destination) {
	int stationNum ;

	for (int i = 0; i < stationNames.size() ; i++) {
		if (stationNames[i] == destination) {
			stationNum= i ;
			break;
		}
	}

	return stationNum ;
}

int findDirecDistan(int stationNum, vector<int> lineInfs, string& direction) {
	int distance ;

	if (stationNum <= lineInfs[1]) {
		direction = "start" ;
		distance = (stationNum - lineInfs[0] + 1) ;
	} else {
		direction = "end" ;
		distance = (stationNum - lineInfs[1]) ;
	}

	return distance ;
}

vector<int> tripResult(vector<vector<int> >& lineInfs, int stationNum, string& direction) {
	vector<int> distance_lineNum ;

	for (int i = 0; i < lineInfs.size(); i++) {
		if (lineInfs[i][0] <= stationNum && stationNum <= lineInfs[i][2]) {
			distance_lineNum.push_back( findDirecDistan(stationNum, lineInfs[i], direction) ) ;
			distance_lineNum.push_back(i) ;
			break;
		}
	}

	return distance_lineNum ;
}

void receivingInf(vector<int>& currentTime, vector<string>& lineNames, vector<int>& arriveTimes, vector<string>& stationNames, vector<int>& stationTimes, vector<vector<int> >& lineInfs, string& destination) {
	int lineCount ;
	
	cin >> lineCount ;
	gettingTime(currentTime);
	 
	for (int i = 0; i < lineCount; i++) {
		enteringLines(lineNames, arriveTimes) ;
		numberingStations(stationNames, stationTimes, lineInfs) ;
	}

	cin >> destination ;
}

void processTrip(vector<string>& stationNames, string destination, vector<vector<int> >& lineInfs, string& direction, vector<int>& distance_lineNum) {
	int stationNum = findStation(stationNames, destination) ;
	distance_lineNum = tripResult(lineInfs, stationNum, direction) ;
}

int timeForArrive(vector<int>& currentTime, int arriveTime) {
	int duration ;

	duration = (((currentTime[0]*60) + currentTime[1]) - (6*60)) ;

	if (duration <= 0) {
		duration = (-1*duration) % arriveTime ;
	} else {
		duration = arriveTime - (duration % arriveTime) ;
		duration = duration % arriveTime ;
	}

	return duration ;
}

int timeInWay(string direction, int distance, vector<int>& stationTimes, int duration, vector<int> lineInf) {
	if (direction == "start") {
		for (int i = 0  ; i < distance ; i++) {
			duration += stationTimes[ (lineInf[0]) + i ] ;
		}
	} else {
		for (int i = 0; i < distance; i++) {
			duration += stationTimes[ (lineInf[1]) + 1 + i ] ;
		}
	}
	return duration ;
}

void processTime(vector<int>& resultTime, vector<int>& currentTime, int arriveTime, int distance, string& direction, vector<int>& stationTimes, vector<int> lineInf ) {
	int duration = timeForArrive(currentTime, arriveTime) ;
	duration = timeInWay(direction, distance, stationTimes, duration, lineInf);

	resultTime[1]= currentTime[1] + duration ;
	resultTime[0]= currentTime[0] + (resultTime[1] / 60) ;
	if (24 <= resultTime[0]) {
		resultTime[0] -= 24 ;
	}
	resultTime[1]= resultTime[1] % 60 ;

}

void timeFormatPrint(vector<int> resultTime, int digit, string sign) {
	if (resultTime[digit] < 10) {
		cout << 0 ;
	}
	cout << resultTime[digit] << sign ;
}

void printPrice(int distance) {
	cout << ceil( 1000 * log10(10 * distance) ) << endl ;
}

void printTrip(string direction, vector<int>& distance_lineNum, vector<string>& lineNames ) {
	cout << "Towards " << direction << " of " << lineNames[ distance_lineNum[1] ] << " in " << distance_lineNum[0] << " station(s)" << endl ;
}

int main() {
	vector<string> lineNames ;
	vector<string> stationNames ;
	vector<int> stationTimes ;
	vector<int> arriveTimes ;
	vector<int> currentTime(2) ;
	string destination ;

	vector<vector<int> > lineInfs ;

	vector<int> distance_lineNum ;
	string direction ;
	vector<int> resultTime(2) ;

	receivingInf(currentTime, lineNames, arriveTimes, stationNames, stationTimes, lineInfs, destination) ;

	processTrip(stationNames, destination, lineInfs, direction, distance_lineNum) ;
	processTime(resultTime, currentTime, arriveTimes[ distance_lineNum[1] ], distance_lineNum[0], direction, stationTimes, lineInfs[ distance_lineNum[1] ]) ;

	printTrip(direction, distance_lineNum, lineNames);
	timeFormatPrint(resultTime, 0, ":");
	timeFormatPrint(resultTime, 1, "\n");
	printPrice(distance_lineNum[0]) ;

	return 0;
}