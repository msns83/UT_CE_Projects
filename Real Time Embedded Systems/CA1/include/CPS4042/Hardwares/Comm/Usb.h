#ifndef USB_H
#define USB_H

#include <CPS4042/Hardwares/Board.h>
#include <CPS4042/Protocols/Protocol.h>
#include <CPS4042/Units/BaudRate.h>
#include <CPS4042/Wires/Pin.h>
#include <boost/pfr.hpp>
#include <iostream>

namespace Sensors
{

using UsbVoltage = VoltageLevel3_3v;

template <BaudRate BR, BitRate BTR, typename WorkingVoltageTp>
requires std::is_base_of_v<AbstractVoltageLevel, WorkingVoltageTp>
struct UsbGpio
{
public:
    Pins::Vdd<WorkingVoltageTp> vdd {BR, BTR, "Usb::vdd"};    // Pin 0
    Pins::Gnd<WorkingVoltageTp> gnd {BR, BTR, "Usb::gnd"};    // Pin 1

    // read from `tx`, write to `rx`.
    Pins::Tx<WorkingVoltageTp>  tx {BR, BTR, "Usb::tx"};      // Pin 2 (read-only)
    Pins::Rx<WorkingVoltageTp>  rx {BR, BTR, "Usb::rx"};      // Pin 3 (write-only)
};

class Usb : public Board<BaudRates::NotSpecified,
                         BitRates::same(BaudRates::NotSpecified),
                         Frequency::F320khz, UsbVoltage, UsbGpio>
{
public:
    explicit Usb() :
        Parent {"Usb::processor"}
    {
        m_processor->installProtocol(&usart);
        std::cout << "one instance of Usb" << " created." << std::endl;
    }

    ~Usb() {
        if(m_processor) m_processor->stopAndJoin();
    }

    class USART : public Protocols::AbstractUsart<Usb, Gpio>
    {
    public:
        explicit USART(Usb* b) :
            Protocols::AbstractUsart<Usb, Gpio> {b}
        {
            b->gpio().rx.setCanRead(false);
        }

        void
        write(Byte byte) override
        {
            m_board->gpio().rx.write(byte);
        }

        Byte
        read() override
        {
            if(AbstractProtocol<Gpio>::m_buffer.empty()) return 0;

            auto byte = AbstractProtocol<Gpio>::m_buffer.front();
            AbstractProtocol<Gpio>::m_buffer.pop();
            return byte;
        }

        void
        run(Gpio& gpio) override
        {
            if(gpio.tx.hasBitToRead() >= bitWidth<Byte>())
            {
                Byte byte = gpio.tx.read();
                AbstractProtocol<Gpio>::m_buffer.push(byte);
            }
        }

    } mutable usart {this};

protected:
    inline void
    startModule() override
    {}
};

}    // namespace Sensors

#endif    // USB_H
