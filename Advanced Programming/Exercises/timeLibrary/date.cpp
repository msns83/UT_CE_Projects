#include <iostream>
#include <vector>
#include <string>
#include "date.hpp"
using namespace std;

Clock::Clock(vector<int> properties)
{

    if (properties.size() != 2)
        throw runtime_error("number of arguments is not correct for a Clock!");
    if (properties[0] < 0 || 23 < properties[0])
        throw runtime_error(to_string(properties[0]) + " is not a defind hour!");
    if (properties[1] < 0 || 59 < properties[1])
        throw runtime_error(to_string(properties[1]) + " is not a defind minute!");

    hour = properties[0];
    minute = properties[1];
}

Date::Date(std::vector<int> properties)
{

    if (properties.size() != 3)
        throw runtime_error("number of arguments is not correct for a Date!");
    if (properties[0] < 1300 || 1500 < properties[0])
        throw runtime_error("year should be in range (1300,1500)");
    if (properties[1] < 1 || 12 < properties[1])
        throw runtime_error("month should be in range (1,12)");
    if (properties[2] < 1 || 31 < properties[1])
        throw runtime_error("month should be in range (1,31)");

    year = properties[0];
    month = properties[1];
    day = properties[2];
}

Time *Clock ::operator+(const Time *secondTime) const
{
    // safe down casting

    Clock *clock = (Clock *)secondTime;
    Clock *newClock = new Clock();

    newClock->minute = (clock->minute + this->minute) % 60;
    newClock->hour = (clock->minute + this->minute) / 60;
    newClock->hour = (clock->hour + this->hour + newClock->hour) % 24;

    return newClock;
}

Time &Date ::operator+=(const Time *secondTime)
{
    // safe down casting

    Date *date = (Date *)secondTime;

    int newDay = (this->day + date->day) % 30;
    int newMonth = (this->day + date->day) / 30;
    int newYear = (newMonth + this->month + date->month) / 12;
    newMonth = (newMonth + this->month + date->month) % 12;

    this->month = newMonth ;
    this->day = newDay ;
    this->year = newYear ;

    return *this;
}

void Clock ::print() const
{
    string hourText = (hour < 10) ? ("0" + to_string(hour)) : to_string(hour);
    string minuteText = (minute < 10) ? ("0" + to_string(minute)) : to_string(minute);

    cout << hourText << ":" << minuteText << endl;
}

void Date ::print() const
{
    cout << this->year << "/" << this->month << "/" << this->day << endl;
}