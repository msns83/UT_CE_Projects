#ifndef SENSOR_H
#define SENSOR_H

#include <CPS4042/Hardwares/Sensors/VL530X.h>
#include <CPS4042/Sketchs/AbstractSketch.h>
#include <boost/random/mersenne_twister.hpp>
#include <boost/random/uniform_int_distribution.hpp>
#include <random>
#include <algorithm>
#include <cstdint>
#include <iostream>
#include <iomanip>

class Sensor : public AbstractSketch<Sensors::Vl530x>
{
public:
    explicit Sensor(Sensors::Vl530x *node) : AbstractSketch<Sensors::Vl530x>{node}
    {
    }

    std::int32_t setup(Sensors::Vl530x::Gpio &gpio) override
    {
        std::cout << "Vl530x setup completed." << std::endl;
        return 0;
    }

    void send_data()
    {
        delay(1000);

        std::random_device rd;
        std::mt19937 gen(rd());
        std::uniform_int_distribution<std::uint16_t> dist(0, 4000);

        std::uint16_t randomNum = dist(gen);
        Byte highByte = static_cast<Byte>((randomNum >> 8) & 0xFF);
        Byte lowByte = static_cast<Byte>(randomNum & 0xFF);
        Byte checksum = std::max(highByte, lowByte) - std::min(highByte, lowByte);

        std::cout << std::hex << std::uppercase << std::setfill('0');
        std::cout << "[Sensor] Data: 0x" << std::setw(4) << randomNum << ", ";
        std::cout << "Checksum: 0x" << std::setw(2) << (static_cast<unsigned int>(checksum) & 0xFF) << std::endl;
        std::cout << std::dec;

        node()->i2c.write(highByte);
        node()->i2c.write(lowByte);
        node()->i2c.write(checksum);
    }

    std::int32_t loop(Sensors::Vl530x::Gpio &gpio) override
    {
        if (node()->i2c.isDataAvailable())
            Byte data = node()->i2c.read();

        if (node()->i2c.ack == Bit::One)
            if (!node()->i2c.isDataAvailable())
                send_data();

        return 0;
    }
};

#endif // SENSOR_H
