#ifndef DATE
#define DATE

#include <vector>
#include <iostream>

class Time
{
public:
    virtual Time *operator+(const Time *secondTime) const = 0;
    virtual Time& operator+=(const Time *secondTime) = 0;
    virtual void print() const = 0;

protected:
    int year = 0;
    int month = 0;
    int day = 0;
};

class Clock : public Time
{
public:
    Clock(const std::vector<int> properties);
    Time *operator+(const Time *secondTime) const;
    Time &operator+=(const Time *secondTime) {};
    void print() const;

private:
    Clock(){};
    int hour = 0;
    int minute = 0;
};

class Date : public Time
{
public:
    Date(const std::vector<int> properties);
    Time &operator+=(const Time *secondTime);
    Time *operator+(const Time *secondTime) const {};
    void print() const;

private:
    Date(){};
};

#endif