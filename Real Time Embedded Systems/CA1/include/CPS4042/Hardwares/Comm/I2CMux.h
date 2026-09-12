#ifndef I2C_MUX_H
#define I2C_MUX_H

#include <CPS4042/Hardwares/Board.h>
#include <CPS4042/Protocols/Protocol.h>
#include <CPS4042/Units/BaudRate.h>
#include <CPS4042/Wires/Pin.h>
#include <boost/pfr.hpp>
#include <iostream>

namespace Sensors
{

    using I2CMuxVoltage = VoltageLevel3_3v;

    template <BaudRate BR, BitRate BTR, typename WorkingVoltageTp>
        requires std::is_base_of_v<AbstractVoltageLevel, WorkingVoltageTp>
    struct I2CMuxGpio
    {
    public:
        Pins::Vdd<WorkingVoltageTp> vdd{BR, BTR, "I2CMux::vdd"};
        Pins::Gnd<WorkingVoltageTp> gnd{BR, BTR, "I2CMux::gnd"};

        Pins::Rx<WorkingVoltageTp> rx{BR, BTR, "I2CMux::rx"};
        Pins::Tx<WorkingVoltageTp> tx{BR, BTR, "I2CMux::tx"};

        Pins::Sda<WorkingVoltageTp> sda1{BR, BTR, "I2CMux::sda1"};
        Pins::Scl<WorkingVoltageTp> scl1{BR, BTR, "I2CMux::scl1"};

        Pins::Sda<WorkingVoltageTp> sda2{BR, BTR, "I2CMux::sda2"};
        Pins::Scl<WorkingVoltageTp> scl2{BR, BTR, "I2CMux::scl2"};

        Pins::Sda<WorkingVoltageTp> sda3{BR, BTR, "I2CMux::sda3"};
        Pins::Scl<WorkingVoltageTp> scl3{BR, BTR, "I2CMux::scl3"};
    };

    class I2CMux : public Board<BaudRates::NotSpecified,
                                BitRates::same(BaudRates::NotSpecified),
                                Frequency::F320khz, I2CMuxVoltage, I2CMuxGpio>
    {
    public:
        explicit I2CMux() : Parent{"I2CMux::processor"},
                            i2c1(this, &m_gpio.sda1, &m_gpio.scl1),
                            i2c2(this, &m_gpio.sda2, &m_gpio.scl2),
                            i2c3(this, &m_gpio.sda3, &m_gpio.scl3)
        {
            m_processor->installProtocol(&usart);
            m_processor->installProtocol(&i2c1);
            m_processor->installProtocol(&i2c2);
            m_processor->installProtocol(&i2c3);

            m_processor->communicationClockChanged.connect(
                [this](Bit edge)
                {
                    m_gpio.scl1.nextEdge(edge);
                    m_gpio.scl2.nextEdge(edge);
                    m_gpio.scl3.nextEdge(edge);
                });

            std::cout << "one instance of I2CMux created." << std::endl;
        }

        ~I2CMux()
        {
            if (m_processor)
                m_processor->stopAndJoin();
        }

        class USART : public Protocols::AbstractUsart<I2CMux, Gpio>
        {
        public:
            explicit USART(I2CMux *b) : Protocols::AbstractUsart<I2CMux, Gpio>{b}
            {
                b->gpio().rx.setCanRead(false);
            }

            void write(Byte byte) override
            {
                m_board->gpio().rx.write(byte);
            }

            Byte read() override
            {
                if (AbstractProtocol<Gpio>::m_buffer.empty())
                {
                    return 0;
                }
                Byte byte = AbstractProtocol<Gpio>::m_buffer.front();
                AbstractProtocol<Gpio>::m_buffer.pop();
                return byte;
            }

            void run(Gpio &gpio) override
            {
                if (gpio.tx.hasBitToRead() >= bitWidth<Byte>())
                {
                    Byte byte = gpio.tx.read();
                    AbstractProtocol<Gpio>::m_buffer.push(byte);
                }
            }
        } mutable usart{this};

        class I2CChannel : public Protocols::AbstractI2C<I2CMux, Gpio>
        {
            Pins::Sda<I2CMuxVoltage> *m_sda;
            Pins::Scl<I2CMuxVoltage> *m_scl;
            enum class State
            {
                IDLE,
                SENT_ADDRESS,
                RECEIVE_ACK,
                READ_DATA
            };
            State state;
            Byte destination_sensor;

        public:
            explicit I2CChannel(I2CMux *b, Pins::Sda<I2CMuxVoltage> *sda, Pins::Scl<I2CMuxVoltage> *scl) : Protocols::AbstractI2C<I2CMux, Gpio>{b}, m_sda(sda), m_scl(scl)
            {
                state = State::IDLE;
            }

            Byte get_sensor_address() { return destination_sensor; }

            void init(Byte address) override
            {
                destination_sensor = address;
                state = State::IDLE;
            }

            void write(Byte byte) override
            {
                m_sda->write(byte);
            }

            Byte read() override
            {
                if (m_buffer.empty())
                    return 0;
                Byte data = m_buffer.front();
                m_buffer.pop();
                return data;
            }

            void handle_idle()
            {
                m_sda->write(destination_sensor);
                state = State::SENT_ADDRESS;
            }

            void handle_sent_address()
            {
                if (m_sda->hasBitToRead())
                {
                    Bit ack = m_sda->readBit();
                    if (ack == Bit::One)
                    {
                        state = State::RECEIVE_ACK;
                    }
                }
            }

            void handle_receive_ack()
            {
                if (m_sda->hasByteToRead())
                {
                    Byte data = m_sda->read();
                    m_buffer.push(data);
                }
            }

            void run(Gpio &gpio) override
            {
                if (state == State::IDLE)
                    handle_idle();
                else if (state == State::SENT_ADDRESS)
                    handle_sent_address();
                else if (state == State::RECEIVE_ACK)
                    handle_receive_ack();
            }

            void startCommunication() { m_started = true; }
            void stopCommunication()
            {
                m_started = false;
                state = State::IDLE;
            }
        };

        mutable I2CChannel i2c1;
        mutable I2CChannel i2c2;
        mutable I2CChannel i2c3;

    protected:
        inline void startModule() override {}
    };

} // namespace Sensors

#endif // I2C_MUX_H