# FIFO Calculator – Interface & Worker

## Overview

This project implements a simple client–worker architecture using **FIFO named pipes** in Go.  
Two separate processes communicate with each other:

- **Interface**: Reads commands from the user and sends requests.
- **Worker**: Receives requests, validates them, performs calculations, and sends back responses.

Communication is done through two named pipes:

- `/tmp/request.pipe` – Interface → Worker  
- `/tmp/response.pipe` – Worker → Interface

---

# Running the Worker

First compile the worker:

```
go build worker.go
```

Run the worker:

```
./worker
```

When the worker starts, it creates the required FIFO pipes if they do not already exist:

```
/tmp/request.pipe
/tmp/response.pipe
```

Example startup message:

```
Worker started...
```

---

# Running the Interface

Compile the interface program:

```
go build interface.go
```

Run it:

```
./interface
```

If the worker is not running, the interface will print:

```
ERROR: Waiting for worker...
```

and will retry automatically until the worker becomes available.

---

# Correct Execution Order

The recommended order is:

1. Start the **Worker**
2. Start the **Interface**
3. Enter commands in the interface

However, the interface can also start first. In that case it will wait until the worker becomes available.

---

# Supported Operations

The worker supports the following operations:

- ADD
- SUB
- MUL
- DIV
- MIN

Each command must follow this format:

```
OPERATION number1 number2
```

Example:

```
ADD 4 7
```

---

# Example Inputs and Outputs

### Normal calculation

```
Please write your operation: ADD 5 3
RESULT: 8
```

```
Please write your operation: MUL 4 6
RESULT: 24
```

```
Please write your operation: MIN 9 2
RESULT: 2
```

---
### Invalid Arguments Count


```
Please write your operation: ADD 5
ERROR: Invalid arguments count
```

---
### Invalid operation

```
Please write your operation: POW 2 3
ERROR: Invalid operation
```

---

### Division by zero

```
Please write your operation: DIV 10 0
ERROR: Division by zero
```

---

### Invalid argument type

```
Please write your operation: ADD 5 x
ERROR: Second argument is not a number
```

---

### Interface started before Worker

If the interface starts while the worker is not running, it waits and retries until the worker becomes available.

Example output:

```
ERROR: Waiting for worker...
ERROR: Waiting for worker...
```

When the worker starts:

```
Connected to worker
Please write your operation:
```

---

### Worker stops while Interface is running

If the worker process stops unexpectedly during communication, the interface detects the disconnection and attempts to reconnect.

Example output in the interface:

```
ERROR: Worker disconnected
Reconnecting...
ERROR: Waiting for worker...
```

When the worker starts again:

```
Connected to worker
```

---

### Interface stops while Worker is running

If the interface process closes unexpectedly, the worker detects the disconnection.

Example worker output:

```
Interface connected
Received: ADD 5 3
ERROR: Interface disconnected
```

The worker then waits for a new interface connection.

---

# Message Exchange Protocol

The communication protocol between Interface and Worker is simple and text-based.

### Request Format

Requests sent from the interface to the worker follow this format:

```
OPERATION ARG1 ARG2
```

Example:

```
ADD 4 5
```

Each request is sent as a single line through `/tmp/request.pipe`.

---

### Worker Processing

The worker performs the following steps:

1. Reads a request from the request pipe.
2. Validates the parameters:
   - Exactly three arguments must exist.
   - Operation must be one of: ADD, SUB, MUL, DIV, MIN.
   - Arguments must be valid integers.
   - Division by zero is not allowed.
3. If validation fails, an error message is returned.
4. If validation succeeds, the calculation is performed.

---

### Response Format

Responses are sent as a single line through `/tmp/response.pipe`.

Possible responses include:

Successful result:

```
RESULT: <value>
```

Example:

```
RESULT: 15
```

Error message:

```
ERROR: <description>
```

Example:

```
ERROR: Invalid operation
```

---

# Connection Behavior

- If the **worker stops unexpectedly**, the interface detects the disconnection and attempts to reconnect automatically.
- If the **interface disconnects**, the worker closes the connection and waits for a new interface connection.
- Both processes continue running and support automatic reconnection.
