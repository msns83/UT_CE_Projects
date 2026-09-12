#ifndef MICRO_MUX_READER_H
#define MICRO_MUX_READER_H

#include <CPS4042/Hardwares/Boards/Esp8266.h>
#include <CPS4042/Sketchs/AbstractSketch.h>
#include <iostream>

class Micro_MuxReader : public AbstractSketch<Boards::Esp8266>
{
    int current_channel = 1 ;

public:
    explicit Micro_MuxReader(Boards::Esp8266 *node) : AbstractSketch<Boards::Esp8266>{node} {}

    std::int32_t setup(Boards::Esp8266::Gpio &gpio) override
    {
        node()->i2c.disable_i2c() ;
        std::cout << "Micro_MuxReader setup completed." << std::endl;
        delay(1000);
        return 0;
    }

    std::int32_t loop(Boards::Esp8266::Gpio &gpio) override
    {
        if (answered){
            node()->usart.write(static_cast<Byte>(current_channel));
            std::cout << "[Micro] asked for channel " << current_channel << std::endl;
            this->answered = false ;
        }
        
        
        if (node()->usart.isDataAvailable())
        {
            answered = true;
            Byte data = node()->usart.read();
            std::cout << "[Micro] Received from channel " << current_channel << ": ";
            if (current_channel == 3) {
                std::cout << (char)data << std::endl;
            } else {
                std::cout << (int)data << std::endl;
            }
        }

        if (answered){
            delay(3000);
            current_channel++;
        }


        if (current_channel > 3) {
            current_channel = 1;
        }
        return 0;
    }
private:
    bool answered = true ;
};

#endif // MICRO_MUX_READER_H