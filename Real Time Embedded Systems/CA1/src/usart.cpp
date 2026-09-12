#include <CPS4042/Hardwares/Boards/Esp8266.h>
#include <CPS4042/Hardwares/Comm/Usb.h>
#include <CPS4042/Sketchs/HardDisk.h>
#include <CPS4042/Sketchs/Micro_DiskReader.h>
#include <CPS4042/Units/Bit.h>
#include <CPS4042/Units/Byte.h>
#include <CPS4042/Wires/Pin.h>
#include <CPS4042/main.h>

// To run tests, uncomment the include + return below.
// #include <Tests/UsartTests.h>

std::int32_t
main()
{
    // return UsartTests::runAllTests();

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

    MicroController_DiskReader micro(&esp8266);
    HardDisk disk(&usb);

    micro.start();
    disk.start();

    return Application::exec();
}
