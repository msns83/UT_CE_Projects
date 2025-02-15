#include <iostream>
#include <vector>
#include "date.hpp"
using namespace std;

void addClock(vector<Time *> &dates, vector<int> props)
{
    try
    {
        dates.push_back(new Clock(props));
    }
    catch (runtime_error &error)
    {
        cerr << error.what() << endl;
    }
    catch (...)
    {
        cerr << "UNKNOWN ERROR (CLOCK)" << endl;
    }
}

void addDate(vector<Time *> &dates, vector<int> props)
{
    try
    {
        dates.push_back(new Date(props));
    }
    catch (runtime_error &error)
    {
        cerr << error.what() << endl;
    }
    catch (...)
    {
        cerr << "UNKNOWN ERROR (DATE)" << endl;
    }
}

int main()
{
    vector<Time *> dates;

    addClock(dates, {12, 12});
    addClock(dates, {14, 53});
    addDate(dates, {1340, 11, 15});
    addDate(dates, {1340, 8, 9});

    ((*dates[0]) + dates[1])->print();

    dates[2]->print() ;
    
    ((*dates[2]) += dates[3]).print() ;

    dates[2]->print() ;
}