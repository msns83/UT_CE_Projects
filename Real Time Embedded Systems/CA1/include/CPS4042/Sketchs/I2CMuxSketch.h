#ifndef I2C_MUX_SKETCH_H
#define I2C_MUX_SKETCH_H

#include <CPS4042/Hardwares/Comm/I2CMux.h>
#include <CPS4042/Sketchs/AbstractSketch.h>
#include <iostream>

class I2CMuxSketch : public AbstractSketch<Sensors::I2CMux>
{
    Byte pending_channel = 0;

public:
    explicit I2CMuxSketch(Sensors::I2CMux *node)
        : AbstractSketch<Sensors::I2CMux>{node}
    {
    }

    std::int32_t setup(Sensors::I2CMux::Gpio &gpio) override
    {
        node()->i2c1.init(0x29);
        node()->i2c2.init(0x29);
        node()->i2c3.init(0x29);

        std::cout << "I2C setup completed." << std::endl;

        return 0;
    }

    std::int32_t loop(Sensors::I2CMux::Gpio &gpio) override
    {
        if (pending_channel == 0x00 && node()->usart.isDataAvailable())
        {
            pending_channel = node()->usart.read();

            std::cout << "[MUX] routing to channel " << std::hex << std::setw(1)
                      << std::setfill('0') << static_cast<int>(pending_channel)
                      << std::dec << std::endl;
        }

        if (pending_channel == 0x01)
        {
            if (node()->i2c1.isDataAvailable())
            {
                Byte data = node()->i2c1.read();
                std::cout << "[MUX] reading channel 1: " << static_cast<int>(data) << std::endl;
                node()->usart.write(data);
                pending_channel = 0x00;
            }
        }
        else if (pending_channel == 0x02)
        {
            if (node()->i2c2.isDataAvailable())
            {
                Byte data = node()->i2c2.read();
                std::cout << "[MUX] reading channel 2: " << static_cast<int>(data) << std::endl;
                node()->usart.write(data);
                pending_channel = 0x00;
            }
        }
        else if (pending_channel == 0x03)
        {
            if (node()->i2c3.isDataAvailable())
            {
                Byte data = node()->i2c3.read();
                std::cout << "[MUX] reading channel 3: " << static_cast<char>(data) << std::endl;
                node()->usart.write(data);
                pending_channel = 0x00;
            }
        }
        else if (pending_channel != 0x00)
        {
            pending_channel = 0x00;
        }

        return 0;
    }
};

#endif // I2C_MUX_SKETCH_H
