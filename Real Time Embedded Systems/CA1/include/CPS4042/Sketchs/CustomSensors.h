#ifndef CUSTOM_SENSORS_H
#define CUSTOM_SENSORS_H

#include <CPS4042/Hardwares/Sensors/VL530X.h>
#include <CPS4042/Sketchs/AbstractSketch.h>
#include <boost/random/mersenne_twister.hpp>
#include <boost/random/uniform_int_distribution.hpp>
#include <random>
#include <iostream>

class Sensor_0_20 : public AbstractSketch<Sensors::Vl530x>
{
public:
    explicit Sensor_0_20(Sensors::Vl530x *node) : AbstractSketch<Sensors::Vl530x>{node} {}

    std::int32_t setup(Sensors::Vl530x::Gpio &gpio) override {
        std::cout << "sensor 0 to 20 setup completed." << std::endl;
        return 0; 
    }

    std::int32_t loop(Sensors::Vl530x::Gpio &gpio) override
    {
        if (node()->i2c.ack == Bit::One)
        {
            std::random_device rd;
            std::mt19937 gen(rd());
            std::uniform_int_distribution<std::uint16_t> dist(0, 20);
            std::uint16_t randomNum = dist(gen);
            node()->i2c.write(static_cast<Byte>(randomNum));
        }
        return 0;
    }
};

class Sensor_50_100 : public AbstractSketch<Sensors::Vl530x>
{
public:
    explicit Sensor_50_100(Sensors::Vl530x *node) : AbstractSketch<Sensors::Vl530x>{node} {}

    std::int32_t setup(Sensors::Vl530x::Gpio &gpio) override {
        std::cout << "sensor 50 to 100 setup completed." << std::endl;
        return 0; }

    std::int32_t loop(Sensors::Vl530x::Gpio &gpio) override
    {
        if (node()->i2c.ack == Bit::One)
        {
            std::random_device rd;
            std::mt19937 gen(rd());
            std::uniform_int_distribution<std::uint16_t> dist(50, 100);
            std::uint16_t randomNum = dist(gen);
            node()->i2c.write(static_cast<Byte>(randomNum));
        }
        return 0;
    }
};

class Sensor_Text : public AbstractSketch<Sensors::Vl530x>
{
    const std::string text = "Hello I2C";
    int index = 0;

public:
    explicit Sensor_Text(Sensors::Vl530x *node) : AbstractSketch<Sensors::Vl530x>{node} {}

    std::int32_t setup(Sensors::Vl530x::Gpio &gpio) override {
        std::cout << "sensor text setup completed." << std::endl;
        return 0; 
        }

    std::int32_t loop(Sensors::Vl530x::Gpio &gpio) override
    {
        if (node()->i2c.ack == Bit::One)
        {
            if (index >= text.size())
                index = 0;
            Byte c = static_cast<Byte>(text[index++]);
            node()->i2c.write(c);
        }
        return 0;
    }
};

#endif // CUSTOM_SENSORS_H