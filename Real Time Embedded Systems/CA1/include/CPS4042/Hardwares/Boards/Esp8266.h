#ifndef ESP8266_H
#define ESP8266_H

#include <CPS4042/Hardwares/Board.h>
#include <CPS4042/Protocols/Protocol.h>
#include <CPS4042/Units/BaudRate.h>
#include <CPS4042/Wires/Pin.h>
#include <boost/pfr.hpp>

namespace Boards
{

    using Esp8266Voltage = VoltageLevel3_3v;

    template <BaudRate BR, BitRate BTR, typename WorkingVoltageTp>
        requires std::is_base_of_v<AbstractVoltageLevel, WorkingVoltageTp>
    struct Esp8266Gpio
    {
    public:
        Pins::Vdd<WorkingVoltageTp> vdd1{BR, BTR, "Esp8266::vdd1"}; // Pin 0
        Pins::Gnd<WorkingVoltageTp> gnd1{BR, BTR, "Esp8266::gnd1"}; // Pin 1

        Pins::Vdd<WorkingVoltageTp> vdd2{BR, BTR, "Esp8266::vdd2"}; // Pin 2
        Pins::Gnd<WorkingVoltageTp> gnd2{BR, BTR, "Esp8266::gnd2"}; // Pin 3

        Pins::Vdd<WorkingVoltageTp> vdd3{BR, BTR, "Esp8266::vdd3"}; // Pin 4
        Pins::Gnd<WorkingVoltageTp> gnd3{BR, BTR, "Esp8266::gnd3"}; // Pin 5

        Pins::Rx<WorkingVoltageTp> rx{BR, BTR, "Esp8266::rx"}; // Pin 6
        Pins::Tx<WorkingVoltageTp> tx{BR, BTR, "Esp8266::tx"}; // Pin 7

        Pins::Sda<WorkingVoltageTp> sda{BR, BTR, "Esp8266::sda"}; // Pin 8
        Pins::Scl<WorkingVoltageTp> scl{BR, BTR, "Esp8266::scl"}; // Pin 9

        Pins::Digital<WorkingVoltageTp> d0{BR, BTR, "Esp8266::d0"}; // Pin 10
        Pins::Digital<WorkingVoltageTp> d1{BR, BTR, "Esp8266::d1"}; // Pin 11
        Pins::Digital<WorkingVoltageTp> d2{BR, BTR, "Esp8266::d2"}; // Pin 12
        Pins::Digital<WorkingVoltageTp> d3{BR, BTR, "Esp8266::d3"}; // Pin 13
        Pins::Digital<WorkingVoltageTp> d4{BR, BTR, "Esp8266::d4"}; // Pin 14
        Pins::Digital<WorkingVoltageTp> d5{BR, BTR, "Esp8266::d5"}; // Pin 15
        Pins::Analog<WorkingVoltageTp> a0{BR, BTR, "Esp8266::a1"};  // Pin 16
    };

    class Esp8266
        : public Board<BaudRates::B115200, BitRates::same(BaudRates::B115200),
                       Frequency::F320khz, Esp8266Voltage, Esp8266Gpio>
    {
    public:
        explicit Esp8266() : Parent{"Esp8266::Processor"}
        {
            m_processor->communicationClockChanged.connect(
                [this](Bit edge)
                { m_gpio.scl.nextEdge(edge); });

            m_processor->installProtocol(&i2c);
            m_processor->installProtocol(&usart);

            std::cout << "one instance of Esp8266" << " created." << std::endl;
        };

        ~Esp8266()
        {
            if (m_processor)
                m_processor->stopAndJoin();
        }

        class I2C : public Protocols::AbstractI2C<Esp8266, Gpio>
        {
        public:
            explicit I2C(Esp8266 *b) : Protocols::AbstractI2C<Esp8266, Gpio>{b}
            {
                state = State::IDLE;
                ack = Bit::Zero;
            }

            Byte get_sensor_address()
            {
                return destination_sensor;
            }

            void init(Byte address) override
            {
                destination_sensor = address;
            }

            void disable_i2c()
            {
                this->dis_i2c = 1;
            }

            void write(Byte byte) override
            {
                m_board->m_gpio.sda.write(byte);
            }

            Byte read() override
            {
                Byte data = m_buffer.front();
                m_buffer.pop();
                return data;
            }

            void handle_idle()
            {
                m_board->m_gpio.sda.write(destination_sensor);
                state = State::SENT_ADDRESS;
            }

            void handle_sent_address()
            {
                if (m_board->m_gpio.sda.hasBitToRead())
                {
                    Bit ack = m_board->m_gpio.sda.readBit();

                    if (ack == Bit::One)
                    {
                        state = State::RECEIVE_ACK;
                        std::cout << std::hex << std::uppercase << std::setfill('0');
                        std::cout << "[Micro] Acknowledge fetched from 0x" << std::setw(2) << (static_cast<unsigned int>(destination_sensor) & 0xFF) << " sensor." << std::endl;
                        std::cout << std::dec;
                    }
                }
            }

            void handle_receive_ack()
            {
                ack = Bit::One;
                if (m_board->m_gpio.sda.hasByteToRead())
                {
                    Byte data = m_board->m_gpio.sda.read();
                    m_buffer.push(data);
                }
            }

            void run(Gpio &gpio) override
            {
                if (dis_i2c)
                    return;

                switch (state)
                {
                case State::IDLE:
                    handle_idle();
                    break;
                case State::SENT_ADDRESS:
                    handle_sent_address();
                    break;
                case State::RECEIVE_ACK:
                    handle_receive_ack();
                    break;
                default:
                    break;
                }
            }

            Bit ack;
            int dis_i2c = 0;

        private:
            enum class State
            {
                IDLE,
                SENT_ADDRESS,
                RECEIVE_ACK
            };
            State state;
            Byte destination_sensor;
        } mutable i2c{this};

        class USART : public Protocols::AbstractUsart<Esp8266, Gpio>
        {
        public:
            explicit USART(Esp8266 *b) : Protocols::AbstractUsart<Esp8266, Gpio>{b}
            {
                b->gpio().tx.setCanRead(false);
            }

            void
            write(Byte byte) override
            {
                m_board->gpio().tx.write(byte);
            }

            Byte
            read() override
            {
                if (AbstractProtocol<Gpio>::m_buffer.empty())
                    return 0;

                auto byte = AbstractProtocol<Gpio>::m_buffer.front();
                AbstractProtocol<Gpio>::m_buffer.pop();
                return byte;
            }

            void
            run(Gpio &gpio) override
            {
                if (gpio.rx.hasBitToRead() >= bitWidth<Byte>())
                {
                    Byte byte = gpio.rx.read();
                    AbstractProtocol<Gpio>::m_buffer.push(byte);
                }
            }

        } mutable usart{this};

    protected:
        inline void
        startModule() override
        {
        }
    };
} // namespace Boards

#endif // ESP8266_H
