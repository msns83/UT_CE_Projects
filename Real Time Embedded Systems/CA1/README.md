# Group work breakdown

| Member                 | Responsibilities |
| ---------------------- | ---------------- |
| Majid Sadeghi Nejad    | I2C + MUX        |
| Kasra Ghorbani         | MUX              |
| Mohsen Hassanzadeh     | USART            |
| Mohammad Amin Tavanaei | I2C              |

# 1. I2C

## 1. ESP8266 (Microcontroller)

### 1.1 I2C Protocol Implementation (Master Side)

The ESP8266 acts as the I2C master. It initiates communication with the sensor and controls the data flow.

#### Initialization

```cpp
node()->i2c.init(0x29);
```

Explanation:
The microcontroller sets the destination sensor address (0x29).

---

#### State Machine

The I2C protocol is implemented using a state machine:

States:

- IDLE
- SENT_ADDRESS
- RECEIVE_ACK

```cpp
void run(Gpio& gpio) override
{
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
    }
}
```

---

#### Sending Address

```cpp
void handle_idle()
{
    m_board->m_gpio.sda.write(destination_sensor);
    m_buffer.push(destination_sensor);
    state = State::SENT_ADDRESS;
}
```

Explanation:

- The master writes the sensor address on SDA
- Moves to next state

---

#### Receiving ACK

```cpp
void handle_sent_address()
{
    if(m_board->m_gpio.sda.hasBitToRead())
    {
        Bit ack = m_board->m_gpio.sda.readBit();

        if(ack == Bit::One)
        {
            m_buffer.push(0x01);
            state = State::RECEIVE_ACK;
        }
    }
}
```

Explanation:

- Waits for sensor acknowledgment
- If ACK is received → continues communication

---

#### Receiving Data

```cpp
void handle_receive_ack()
{
    ack = Bit::One;
    if(m_board->m_gpio.sda.hasByteToRead())
    {
        Byte data = m_board->m_gpio.sda.read();
        m_buffer.push(data);
    }
}
```

Explanation:

- After ACK, data is received from sensor
- Data is stored in buffer

---

#### Read Function (Master)

```cpp
Byte read() override
{
    Byte data = m_buffer.front();
    m_buffer.pop();
    return data;
}
```

Explanation:

- Reads data from internal buffer
- Used by the sketch (application layer)

---

#### Write Function (Master)

```cpp
void write(Byte byte) override
{
}
```

Explanation:

- Not used in this implementation
- Data sending is handled directly inside the protocol logic (state machine)

---

### 1.2 Microcontroller Sketch (Application Logic)

The sketch processes incoming data from the sensor.

---

#### Data States

- WAIT_LOW
- WAIT_HIGH
- WAIT_CHECKSUM

---

#### Main Loop

```cpp
if(node()->i2c.isDataAvailable())
{
    Byte data = node()->i2c.read();
```

---

#### Processing LOW Byte

```cpp
void handle_wait_low(Byte data)
{
    low = data;
    state = Data_state::WAIT_HIGH;
}
```

---

#### Processing HIGH Byte

```cpp
void handle_wait_high(Byte data)
{
    high = data;

    if(high < low)
        calculated_checksum = low - high;
    else
        calculated_checksum = high - low;

    state = Data_state::WAIT_CHECKSUM;
}
```

---

#### Processing CHECKSUM

```cpp
void handle_wait_checksum(Byte data)
{
    Byte checksum = data;

    if(calculated_checksum == checksum)
        std::cout << "OK" << std::endl;

    state = Data_state::WAIT_LOW;
}
```

Explanation:

- The microcontroller reconstructs the original value
- Validates data using checksum
- Prints "OK" if correct

---

## 2. VL53X Sensor

### 2.1 I2C Protocol Implementation (Slave Side)

The VL53X sensor acts as the I2C slave.

---

#### Sensor Address

```cpp
inline static constexpr Byte address = 0x29;
```

---

#### State Machine

States:

- WAIT_ADDRESS
- SENT_ACK

```cpp
void run(Gpio& gpio) override
{
    switch (state)
    {
    case State::WAIT_ADDRESS:
        handle_wait_address();
        break;
    case State::SENT_ACK:
        handle_sent_ack();
        break;
    }
}
```

---

#### Receiving Address

```cpp
void handle_wait_address()
{
    if(m_board->m_gpio.sda.hasByteToRead())
    {
        Byte sensor_address = m_board->m_gpio.sda.read();
        sensor_address = sensor_address >> 1;

        if(address == sensor_address)
        {
            m_board->m_gpio.sda.write(Bit::One);
            state =  State::SENT_ACK;
        }
    }
}
```

Explanation:

- Reads address from SDA
- Compares with its own address
- Sends ACK if matched

---

#### Sending ACK

```cpp
void handle_sent_ack()
{
    this->ack = Bit::One;
}
```

---

#### Write Function (Sensor)

```cpp
void write(Byte byte) override
{
    m_board->m_gpio.sda.write(byte);
}
```

Explanation:

- Sensor writes data to SDA
- Used to send data to the master

---

#### Read Function (Sensor)

```cpp
Byte read() override
{
    Byte data = m_buffer.front();
    m_buffer.pop();
    return data;
}
```

Explanation:

- Reads incoming data from buffer
- Not heavily used in this scenario

---

### 2.2 Sensor Sketch (Application Logic)

The sensor generates random data and sends it to the microcontroller.

---

#### Data Generation

```cpp
uint16_t value = std::rand() % 4001;
Byte high = (value >> 8);
Byte low = value & 0xFF;
```

Explanation:

- Generates a random number between 0 and 4000
- Splits into two bytes

---

#### Checksum Calculation

```cpp
if(low < high)
    checksum = high - low;
else
    checksum = low - high;
```

---

#### Sending Data

```cpp
node()->i2c.write(low);
node()->i2c.write(high);
node()->i2c.write(checksum);
```

Explanation:

- Sends data in 3 bytes:
  1. LOW
  2. HIGH
  3. CHECKSUM

---

#### Main Loop

```cpp
if(node()->i2c.ack == Bit::One)
{
    if(!node()->i2c.isDataAvailable())
    {
        send_data();
    }
}
```

Explanation:

- Waits for ACK from master
- Sends data only after successful connection

---

### Question 1

What problem occurs if multiple sensors with similar addresses are connected to the I2C bus?

The I2C protocol is a shared bus protocol where all devices are connected to the same SDA and SCL lines. Each slave device must have a unique address. If multiple sensors have the same address, the following problem occurs:

When the master sends an address: All devices with that same address will respond simultaneously and multiple slaves try to drive the SDA line at the same time

if we do this, these issues will result:

1. Data Collision
   Different devices may send different data bits at the same time, causing corrupted communication.

2. Undefined Behavior
   The master cannot distinguish which device is responding.

3. Bus Contention
   Multiple devices writing to SDA can lead to electrical conflicts (in real hardware).

So if two sensors had the same address: both would send ACK, both would send data and The buffer would receive mixed/invalid data

### Question 2

Explain four major simplifications of this I2C implementation compared to the real I2C protocol.

This implementation is a simplified model of the real I2C protocol. Several important features are missing or abstracted.

1. No Start and Stop Conditions

In real I2C: Communication begins with a START condition and Ends with a STOP condition

In this code: There is no explicit start/stop signal and Communication is driven only by state transitions

2. Simplified ACK Handling

In real I2C: ACK is sent after every byte and It is precisely timed with clock cycles

In this code: ACK is represented as a simple Bit variable. No strict timing or bit-level control

3. No Error Handling or Arbitration

In real I2C: Multiple masters can exist, Arbitration logic resolves conflicts

In this implementation: Only one master exists

4. No arbitration or error detection

### Question 3

Explain the purpose of `ByteStream`, `ByteVector`, and `getByte` functions.

- ByteStream: `ByteStream` is used to construct a multi-byte value from a sequence of incoming bytes. It is especially useful when receiving data byte-by-byte over communication protocols. It is capable of: Adding Bytes, Readiness Check: it Returns true when enough bytes are received, Getting the Value, Take and Reset: Returns the value, Clears internal buffer, Overflow Protection: Prevents writing more bytes than the target type can hold

- ByteVector: `ByteVector` is used to split a multi-byte variable into individual bytes. It is useful when sending data over communication protocols. The variable is treated as an array of bytes in memory and No copying is performed (efficient). It is capable of: Size Calculation: Returns number of bytes in the type, Accessing Bytes

- getByte Functions: `getByte` is a helper function to extract a specific byte from a variable at compile time. It is capable of:
  Returns byte at given index, Prevents invalid access during compilation

# 2. USART (Full-Duplex)

## Overview

In this part we simulated a simple **Full-Duplex USART** connection between:

- **Master**: `Boards::Esp8266`
- **Peripheral**: a fake hard-disk implemented as `Sensors::Usb`

The master sends an **address byte** (0–255). The hard-disk receives it and
returns the corresponding **data byte** from its internal table.

## Files implemented/updated

- `include/CPS4042/Hardwares/Comm/Usb.h`: new `Usb` board + `Usb::USART`
- `include/CPS4042/Hardwares/Boards/Esp8266.h`: completed `Esp8266::USART`
- `include/CPS4042/Sketchs/HardDisk.h`: hard-disk sketch (read addr → reply byte)
- `include/CPS4042/Sketchs/Microcontroller.h`: master sketch (send addr → print reply)
- `include/CPS4042/Tests/UsartTests.h`: test cases (unit + integration)
- `src/main.cpp` and `CMakeLists.txt`: wired and added new files

## Wiring

USART uses two separate data lines (full duplex):

```
VDD:  ESP8266.vdd2 <-> Usb.vdd
GND:  ESP8266.gnd2 <-> Usb.gnd
TX :  ESP8266.tx   ->  Usb.tx   (master writes, peripheral reads)
RX :  Usb.rx       ->  ESP8266.rx (peripheral writes, master reads)
```

## How to run

### Run the USART simulation (default)

- Build the project (CMake).
- Run `build/CPS4042.exe`.
- You should see logs like `[MCU] request ...` and `[HardDisk] request ...`.

### Run the test suite

- Open `src/main.cpp`
- Uncomment the two lines (include + `return UsartTests::runAllTests()`).
- Rebuild and run again.

## Implementation notes

### Board configuration

- `Usb` runs with its **own clock** (`Frequency::F320khz`) as required.
- `Usb` uses `BaudRates::NotSpecified` so it can attach to the same link
  baud-rate chosen by the master side.

#### Frame format (USART concept)

In standard USART, a frame is:

- **Start bit** (0)
- **Data bits** (usually 8, LSB first)
- **Parity** (optional, not required in this homework)
- **Stop bit** (1)

In this simulator, we don’t manually push start/stop bits. The framework keeps
the line in an idle state and the USART protocol just waits until a full byte
worth of data bits is available.

### Protocol behavior (what `run()` does)

- The framework already handles the “idle” state; the protocol just waits until
  a full byte is available on the receiver pin.
- In `run()` we check `hasBitToRead() >= 8` and then call `read()` once to
  frame a complete byte into the protocol buffer.

### Master/peripheral behavior

- **Microcontroller (`Microcontroller.h`)**:
  - Sends one address byte on `tx`
  - Waits for one reply byte on `rx`
  - Prints it and increments the address

- **HardDisk (`HardDisk.h`)**:
  - Waits for one address byte from USART
  - Looks it up in `m_storage`
  - Sends the mapped payload byte back
  - If an address is not found, replies `0x00`

### Preventing wrong-direction reads/writes

In this simulator each pin can also try to read from the link. To avoid a
device reading its own transmitted bits, we disable reading on the **write-only**
pin:

- On the master: `ESP8266.tx.setCanRead(false)`
- On the peripheral: `Usb.rx.setCanRead(false)`

This matches the rule in the handout: master never writes on `Rx` and peripheral
never writes on `Tx`.

### Assumptions / simplifications used

- Baud-rate is simplified as requested (baud synchronized with the simulator’s clocking model).
- Parity is not implemented (not required).
- Data is exchanged as **single bytes** (address request → payload response).

## Result

Example output (hex):

```
[MCU] request address 0x00
[HardDisk] request for address 0x00 -> 0xad
[MCU] reply for 0x00 = 0xad
```

## Test cases

The test file is `include/CPS4042/Tests/UsartTests.h`.

### Integration tests (two devices running together)

These tests are intentionally focused on the **USART feature we added** (full-duplex master/peripheral exchange). They instantiate the real boards (`Esp8266` + `Usb`), wire them (`VDD/GND/TX/RX`), start both processors, then **count how many request→reply cycles** complete within a timeout.

- **`integration: master receives >= 3 replies`**:
  - Pass condition: at least 3 successful round-trips within ~1.5 seconds.
  - Purpose: quick “smoke test” that the USART link works end-to-end.

- **`integration: master receives >= 10 replies`**:
  - Pass condition: at least 10 successful round-trips within ~3 seconds.
  - Purpose: a slightly longer run to catch timing / buffering issues that might not show up in the smoke test.

Notes:

- The peripheral replies with `0x00` for unknown addresses, so round-trips should continue even after the request address exceeds the storage table.
- Each integration scenario stops both processor threads at the end, so the test suite exits cleanly and prints a summary.

To run tests, uncomment the two lines in `src/main.cpp` (include + `return`).

## Questions

### 1) Why start/stop bits are not confused with data bits?

Because the line has a known **idle level** and frames have a fixed structure:
the receiver detects a **start condition**, then samples exactly 8 data bits,
and expects a **stop/idle** level again. So frame boundaries come from position
and timing, not from “special values” in the data.

### 2) Without a clock, how does USART detect data?

Both sides agree on a **baud rate** (bit period). The receiver detects the start
of a frame and then samples the line at fixed time intervals (ideally near the
middle of each bit). It re-synchronizes on every new frame.

### 3) Can USART be implemented in software (bit-banging) on MCUs without UART hardware?

Yes, it is possible, but it is more sensitive to timing than I2C. A software
UART needs accurate timers and low jitter (interrupt latency can break sampling),
especially at higher baud rates. That’s why hardware USART is preferred when
available.

# 3. I2C Multiplexer

In this project, we needed to make an ESP8266 communicate with three VL530X sensors. The problem is that the ESP8266 has limited pins and all three sensors have the exact same hardcoded I2C address (0x29). If we connect all of them to the same I2C bus, they will all answer at the same time and the data will be crushed.

To fix this, we created an I2C Multiplexer. The ESP8266 talks to the MUX using USART, and the MUX is connected to the three sensors using three separate I2C channels (sda1/scl1, sda2/scl2, and sda3/scl3).

### The ESP8266 Side (Micro_MuxReader)

The ESP8266 runs a sketch where it loops through channels 1 to 3. It writes the channel number to the USART. Then it waits until data is available on the USART rx pin to read the sensor's answer. When it gets the data, it prints it and moves to the next channel.

### The MUX Side (I2CMuxSketch)

The MUX has one USART protocol to talk to the ESP and three I2C protocols to talk to the sensors. Inside its loop(), it first checks if there is data on the USART. If the ESP asks for channel 1, the MUX sets a pending_channel variable.
Then, relying on this variable, it starts an I2C transaction with the correct sensor. Because hardware takes time to fetch data, the MUX has to wait. It checks node()->i2c1.isDataAvailable(). Once the data from the sensor arrives, the MUX reads it and writes it back to the USART so the ESP8266 can get it. After that, it resets the pending_channel to wait for the next request.

### Bug Fixes and Hardware Logic

During the process, we had to fix some deep hardware simulation issues:

- Asynchronous UART reading: Because UART receives bits one by one over time, the run method in the USART protocol needs to wait until 8 bits are collected (hasBitToRead() >= bitWidth<Byte>()) before pushing them into the buffer as a byte.
- Component Clashing: We had to make sure the MUX properly disables its read action on the TX pin (setCanRead(false)), otherwise the simulation crashes when trying to write to an unmapped buffer.

Overall, the MUX acts like a router, successfully isolating the three identical sensors and passing their data back to the microcontroller via serial communication.

# Questions and Answers

1. Study the reverse function in Byte.h and where it is used. Explain its usage, whether such operation is used in real boards, and what the real-world solution is.

The reverse function takes a byte (like `11001010`) and completely reverses the bit order (making it `01010011`). It does this by looping over all 8 bits, shifting the result left, and adding the bits starting from the lowest index. This happens because of "endianness" in communication protocols. Some protocols (like I2C and SPI) usually send the Most Significant Bit (MSB) first, while others (like typical USART/UART) send the Least Significant Bit (LSB) first. If you connect systems that assume different bit-orders, you have to reverse the bits in software so the data makes sense. In the real world, hardware handles this. Microcontrollers have built-in peripheral registers (like UART and I2C hardware blocks). You configure these blocks during setup (e.g., setting a flag bit in a control register to "MSB_FIRST" or "LSB_FIRST"), and the hardware silicon automatically shifts the bits out in the correct order. Doing bit reversal in software for every single byte is slow and wastes CPU time, so real boards rely on the physical peripheral hardware to send bits correctly.

2. Explain the takeNthBit functions in Bit.h. What is the difference between the two?

The takeNthBit function extracts a specific bit (like the 3rd bit) from a larger variable (like an 8-bit byte). Both versions do the same logic: they create a mask by shifting 1 to the left by n positions, and then use the bitwise AND (&) operator to see if that specific bit is 1 or 0. The difference between the two is how they are processed by C++:

- The first one: `template <typename T> inline constexpr Bit takeNthBit(T value, std::uint8_t n)` is a regular function template. You pass the value and index as normal arguments at runtime.
- The second one: `template <auto byte, std::uint8_t n> inline constexpr Bit takeNthBit()` resolves everything at compile time. Because `byte` and `n` are passed as template parameters, the compiler pre-calculates the bit extraction. When the code runs, there is no math happening, it just uses the hardcoded result.

3. Explain the attachPinToCommunicationClock function in the Board class. (From code and usage perspective)

From a code perspective, this is a heavily templated function that accepts a pinIndex. It gets the specific pin from the board's GPIO tuple and makes sure it is a Digital pin. Then, it connects a lambda function to the m_processor->communicationClockChanged signal. Its usage is to provide a master clock to other slave devices. In protocols like I2C or SPI, there is a master device that generates the clock signal. This function links the processor's internal simulated frequency cycles directly to a physical pin (like `scl`). So every time the master processor ticks, it flips the voltage on this pin. Slaves connected to this pin (who have `Frequency::Drived`) use these voltage edges to know when to run their next cycle and read or write their data.
