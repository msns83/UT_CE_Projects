#ifndef MICROCONTROLLER_H
#define MICROCONTROLLER_H

#include <CPS4042/Hardwares/Boards/Esp8266.h>
#include <CPS4042/Sketchs/AbstractSketch.h>
#include <CPS4042/Utils/ByteStream.h>
#include <CPS4042/Utils/Wave.h>
#include <bitset>

class MicroController_SensorReader : public AbstractSketch<Boards::Esp8266>
{
public:
    explicit MicroController_SensorReader(Boards::Esp8266* node) : AbstractSketch<Boards::Esp8266> {node} {
    }

    std::int32_t setup(Boards::Esp8266::Gpio& gpio) override {
        node()->i2c.init(0x29);
        state = Data_state::WAIT_HIGH;
        std::cout << "ESP8266 setup completed." << std::endl;
        return 0;
    }

    void handle_wait_low(Byte data) {
        low = data;
        calculated_checksum = std::max(high, low) - std::min(high, low);
        state = Data_state::WAIT_CHECKSUM;
    }

    void handle_wait_high(Byte data) {
        high = data;
        state = Data_state::WAIT_LOW;
    }

    void handle_wait_checksum(Byte data) {
        Byte checksum = data;

        std::cout << std::hex << std::uppercase << std::setfill('0');
        std::cout << "[Micro] First: 0x" << std::setw(2) << (static_cast<unsigned int>(high) & 0xFF) << ", ";
        std::cout << "Second: 0x" << std::setw(2) << (static_cast<unsigned int>(low) & 0xFF) << ", ";
        std::cout << "Third: 0x" << std::setw(2) << (static_cast<unsigned int>(checksum) & 0xFF) << " -> ";

        if(calculated_checksum == checksum)
            std::cout << "OK";
        else{
            std::cout << "Wrong";
        }

        ByteStream<std::uint16_t> stream;
        stream << high;
        stream << low;
        if (stream.isReady())
            std::cout << ": " << std::setw(4) << stream.take() << std::endl;

        state = Data_state::WAIT_HIGH;
    }

    std::int32_t loop(Boards::Esp8266::Gpio& gpio) override {
        if(node()->i2c.isDataAvailable()) {
            Byte data = node()->i2c.read();

            if (node()->i2c.ack == Bit::One) { 
                switch (state) {
                case Data_state::WAIT_LOW:
                    handle_wait_low(data);
                    break;
                case Data_state::WAIT_HIGH:
                    handle_wait_high(data);
                    break;
                case Data_state::WAIT_CHECKSUM:
                    handle_wait_checksum(data);
                    break;
                }
            }
        }

        return 0;
    }

    private:
    enum class Data_state
    {
        WAIT_LOW,
        WAIT_HIGH,
        WAIT_CHECKSUM
    };
    Data_state state;
    Byte high;
    Byte low;
    Byte calculated_checksum;
 

};


#endif    // MICROCONTROLLER_H
