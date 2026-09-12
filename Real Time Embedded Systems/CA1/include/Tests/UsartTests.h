#ifndef USART_TESTS_H
#define USART_TESTS_H

// USART tests 
// Enable in `src/main.cpp` by uncommenting the include and return line.

#include <CPS4042/Hardwares/Boards/Esp8266.h>
#include <CPS4042/Hardwares/Comm/Usb.h>
#include <CPS4042/Units/Byte.h>
#include <CPS4042/Wires/Pin.h>

#include <atomic>
#include <chrono>
#include <iomanip>
#include <iostream>
#include <unordered_map>
#include <thread>
#include <vector>

namespace UsartTests
{

namespace detail
{
inline std::uint32_t&
passedCount()
{
    static std::uint32_t v = 0;
    return v;
}
inline std::uint32_t&
failedCount()
{
    static std::uint32_t v = 0;
    return v;
}

inline void
report(const std::string& name, bool ok, const std::string& msg = "")
{
    if(ok)
    {
        passedCount()++;
        std::cout << "  [PASS] " << name << std::endl;
    }
    else
    {
        failedCount()++;
        std::cout << "  [FAIL] " << name;
        if(!msg.empty()) std::cout << "  (" << msg << ")";
        std::cout << std::endl;
    }
}
}    // namespace detail

// Integration: run ESP8266 <-> Usb for a short time and count replies.

inline bool
runUsartScenario(int requiredRoundTrips, int timeoutMillis)
{
    {
        Boards::Esp8266 esp8266;
        Sensors::Usb    usb;

        auto linkRed   = std::make_shared<Link>();
        auto linkBlack = std::make_shared<Link>();
        auto linkTx    = std::make_shared<Link>();
        auto linkRx    = std::make_shared<Link>();

        CPS_SET_OBJECT_NAME(esp8266);
        CPS_SET_OBJECT_NAME(usb);
        CPS_SET_OBJECT_NAME_PTR(linkRed);
        CPS_SET_OBJECT_NAME_PTR(linkBlack);
        CPS_SET_OBJECT_NAME_PTR(linkTx);
        CPS_SET_OBJECT_NAME_PTR(linkRx);

        esp8266.gpio().vdd2.attachLink(linkRed);
        esp8266.gpio().gnd2.attachLink(linkBlack);
        esp8266.gpio().tx.attachLink(linkTx);
        esp8266.gpio().rx.attachLink(linkRx);

        usb.gpio().vdd.attachLink(linkRed);
        usb.gpio().gnd.attachLink(linkBlack);
        usb.gpio().tx.attachLink(linkTx);
        usb.gpio().rx.attachLink(linkRx);

        // Use local sketches that do not write to std::cout (thread-safety).
        struct CountingMicroController : public AbstractSketch<Boards::Esp8266>
        {
            std::atomic<int>* replies;
            UByte             address {0x00};
            bool              awaitingResp {false};

            explicit CountingMicroController(Boards::Esp8266* node,
                                             std::atomic<int>* replies_) :
                AbstractSketch<Boards::Esp8266> {node}, replies {replies_}
            {}

            std::int32_t setup(Boards::Esp8266::Gpio&) override { return 0; }

            std::int32_t loop(Boards::Esp8266::Gpio&) override
            {
                if(!awaitingResp)
                {
                    node()->usart.write(static_cast<Byte>(address));
                    awaitingResp = true;
                }

                if(node()->usart.isDataAvailable())
                {
                    (void)node()->usart.read();
                    ++(*replies);
                    address++;
                    awaitingResp = false;
                }

                return 0;
            }
        };

        struct SilentHardDisk : public AbstractSketch<Sensors::Usb>
        {
            std::unordered_map<Byte, Byte> storage = {
              {static_cast<Byte>(0x00), static_cast<Byte>(0xAD)},
              {static_cast<Byte>(0x05), static_cast<Byte>(0x45)},
              {static_cast<Byte>(0x10), static_cast<Byte>(0xDE)},
            };

            explicit SilentHardDisk(Sensors::Usb* node) :
                AbstractSketch<Sensors::Usb> {node}
            {}

            std::int32_t setup(Sensors::Usb::Gpio&) override { return 0; }

            std::int32_t loop(Sensors::Usb::Gpio&) override
            {
                if(node()->usart.isDataAvailable())
                {
                    Byte address = node()->usart.read();
                    auto it      = storage.find(address);
                    node()->usart.write(it == storage.end()
                                          ? static_cast<Byte>(0x00)
                                          : it->second);
                }
                return 0;
            }
        };

        std::atomic<int> replies {0};
        CountingMicroController micro(&esp8266, &replies);
        SilentHardDisk          disk(&usb);

        micro.start();
        disk.start();

        std::this_thread::sleep_for(std::chrono::milliseconds(timeoutMillis));

        // Stop processor threads before sketches are destroyed (their loop/setup
        // lambdas capture `this`).
        esp8266.stop();
        usb.stop();

        // Make sure we read the final value before destructors run.
        int hits = replies.load();
        std::cout << "  ... observed " << hits << " round-trips (need >= "
                  << requiredRoundTrips << ")" << std::endl;
        return hits >= requiredRoundTrips;
    }

    return false;
}

inline void
testUsartIntegrationBasic()
{
    bool ok = runUsartScenario(/*requiredRoundTrips=*/3,
                               /*timeoutMillis=*/1500);
    detail::report("integration: master receives >=3 replies", ok);
}

inline void
testUsartIntegrationStressed()
{
    bool ok = runUsartScenario(/*requiredRoundTrips=*/10,
                               /*timeoutMillis=*/3000);
    detail::report("integration: master receives >=10 replies", ok);
}

// Runner: comment a single line to skip a test.

inline std::int32_t
runAllTests()
{
    std::cout << "==== USART test suite ====" << std::endl;

    // ---- Integration tests (each spins up the simulator briefly) ----
    testUsartIntegrationBasic();
    testUsartIntegrationStressed();

    std::cout << "==== summary: " << detail::passedCount() << " passed, "
              << detail::failedCount() << " failed ====" << std::endl;

    return detail::failedCount() == 0 ? 0 : 1;
}

}    // namespace UsartTests

#endif    // USART_TESTS_H
