#include <CPS4042/Hardwares/Boards/Esp8266.h>
#include <CPS4042/Hardwares/Comm/I2CMux.h>
#include <CPS4042/Hardwares/Sensors/VL530X.h>
#include <CPS4042/Sketchs/I2CMuxSketch.h>
#include <CPS4042/Sketchs/Micro_MuxReader.h>
#include <CPS4042/Sketchs/CustomSensors.h>
#include <CPS4042/Sketchs/Sensor.h>
#include <CPS4042/Units/Bit.h>
#include <CPS4042/Units/Byte.h>
#include <CPS4042/Wires/Pin.h>
#include <CPS4042/main.h>

std::int32_t main()
{
    Boards::Esp8266 esp8266;
    Sensors::I2CMux i2cmux;
    Sensors::Vl530x vl1;
    Sensors::Vl530x vl2;
    Sensors::Vl530x vl3;

    auto linkVddusrt = std::make_shared<Link>();
    auto linkGndusrt = std::make_shared<Link>();
    auto linkVddi2c1 = std::make_shared<Link>();
    auto linkGndi2c1 = std::make_shared<Link>();
    auto linkVddi2c2 = std::make_shared<Link>();
    auto linkGndi2c2 = std::make_shared<Link>();
    auto linkVddi2c3 = std::make_shared<Link>();
    auto linkGndi2c3 = std::make_shared<Link>();

    auto linkTx = std::make_shared<Link>();
    auto linkRx = std::make_shared<Link>();

    auto sda1 = std::make_shared<Link>();
    auto scl1 = std::make_shared<Link>();

    auto sda2 = std::make_shared<Link>();
    auto scl2 = std::make_shared<Link>();

    auto sda3 = std::make_shared<Link>();
    auto scl3 = std::make_shared<Link>();
    auto unusedSda = std::make_shared<Link>();
    auto unusedScl = std::make_shared<Link>();

    CPS_SET_OBJECT_NAME(esp8266);
    CPS_SET_OBJECT_NAME(i2cmux);
    CPS_SET_OBJECT_NAME(vl1);
    CPS_SET_OBJECT_NAME(vl2);
    CPS_SET_OBJECT_NAME(vl3);

    esp8266.gpio().vdd1.attachLink(linkVddusrt);
    esp8266.gpio().gnd1.attachLink(linkGndusrt);
    esp8266.gpio().sda.attachLink(unusedSda);
    esp8266.gpio().scl.attachLink(unusedScl);
    i2cmux.gpio().vdd.attachLink(linkVddusrt);
    i2cmux.gpio().gnd.attachLink(linkGndusrt);
    vl1.gpio().vdd.attachLink(linkVddi2c1);
    vl1.gpio().gnd.attachLink(linkGndi2c1);
    vl2.gpio().vdd.attachLink(linkVddi2c2);
    vl2.gpio().gnd.attachLink(linkGndi2c2);
    vl3.gpio().vdd.attachLink(linkVddi2c3);
    vl3.gpio().gnd.attachLink(linkGndi2c3);

    esp8266.gpio().tx.attachLink(linkTx);
    i2cmux.gpio().tx.attachLink(linkTx);
    esp8266.gpio().rx.attachLink(linkRx);
    i2cmux.gpio().rx.attachLink(linkRx);

    i2cmux.gpio().sda1.attachLink(sda1);
    i2cmux.gpio().scl1.attachLink(scl1);
    vl1.gpio().sda.attachLink(sda1);
    vl1.gpio().scl.attachLink(scl1);

    i2cmux.gpio().sda2.attachLink(sda2);
    i2cmux.gpio().scl2.attachLink(scl2);
    vl2.gpio().sda.attachLink(sda2);
    vl2.gpio().scl.attachLink(scl2);

    i2cmux.gpio().sda3.attachLink(sda3);
    i2cmux.gpio().scl3.attachLink(scl3);
    vl3.gpio().sda.attachLink(sda3);
    vl3.gpio().scl.attachLink(scl3);

    Micro_MuxReader micro(&esp8266);
    I2CMuxSketch mux(&i2cmux);
    Sensor_0_20 sen1(&vl1);
    Sensor_50_100 sen2(&vl2);
    Sensor_Text sen3(&vl3);

    micro.start();
    mux.start();
    sen1.start();
    sen2.start();
    sen3.start();

    return Application::exec();
}
