#ifndef MICROCONTROLLER_H
#define MICROCONTROLLER_H

#include <CPS4042/Hardwares/Boards/Esp8266.h>
#include <CPS4042/Sketchs/AbstractSketch.h>
#include <CPS4042/Utils/ByteStream.h>
#include <CPS4042/Utils/Wave.h>
#include <bitset>
#include <iomanip>

class MicroController_DiskReader : public AbstractSketch<Boards::Esp8266>
{
public:
    explicit MicroController_DiskReader(Boards::Esp8266 *node) : AbstractSketch<Boards::Esp8266>{node}
    {
    }

    std::int32_t
    setup(Boards::Esp8266::Gpio &gpio) override
    {
        std::cout << "ESP8266 setup completed." << std::endl;
        return 0;
    }

    std::int32_t
    loop(Boards::Esp8266::Gpio &gpio) override
    {
        static UByte address = 0x00;
        static bool awaitingResp = false;

        if (!awaitingResp)
        {
            std::cout << "[Micro] request address 0x" << std::hex << std::setw(2)
                      << std::setfill('0') << static_cast<int>(address)
                      << std::dec << std::endl;

            node()->usart.write(static_cast<Byte>(address));
            awaitingResp = true;
        }

        if (node()->usart.isDataAvailable())
        {
            Byte data = node()->usart.read();

            std::cout << "[Micro] reply for 0x" << std::hex << std::setw(2)
                      << std::setfill('0') << static_cast<int>(address)
                      << " = 0x" << std::setw(2) << std::setfill('0')
                      << static_cast<int>(static_cast<UByte>(data)) << std::dec
                      << std::endl;

            address++;
            awaitingResp = false;
        }

        

        return 0;
    }
};

#endif // MICROCONTROLLER_H
