# Memory Monitoring and Subscriber Service

This project contains two components:

1. Web Service (Publisher)
2. Subscriber Service

The Web Service monitors its memory usage and publishes an event whenever memory consumption exceeds a configured threshold. The Subscriber receives and logs these events.

---

## Building the Applications

Before building, verify the operating system and CPU architecture of the target VM:

```bash
uname -s
uname -m
```

Examples:

| OS | Architecture | GOOS | GOARCH |
|----|-------------|-------|---------|
| Ubuntu Linux x86_64 | x86_64 | linux | amd64 |
| Ubuntu Linux ARM64 | aarch64 | linux | arm64 |
| Windows x86_64 | x86_64 | windows | amd64 |

### Build Subscriber

For Linux x86_64:

```bash
GOOS=linux GOARCH=amd64 go build -o subscriber subscriber.go
```

For Linux ARM64:

```bash
GOOS=linux GOARCH=arm64 go build -o subscriber subscriber.go
```

### Build Web Service

For Linux x86_64:

```bash
GOOS=linux GOARCH=amd64 go build -o web-server main.go
```

For Linux ARM64:

```bash
GOOS=linux GOARCH=arm64 go build -o web-server main.go
```

---

## Running the Subscriber

Start the subscriber on the target machine:

```bash
./subscriber
```

Expected output:

```text
Subscriber listening on :9000
```

The subscriber listens for memory alert events on port 9000.

---

## Running the Web Service

Configure the service addresses using environment variables.

Example:

```bash
export AUTH_VM_IP="192.168.x.x:8002"
export FILE_VM_IP="192.168.x.x:8003"
export SUBSCRIBER_IP="192.168.x.x:9000"
```

Start the application:

```bash
./web-app
```

Expected output:

```text
Starting Web Service (VM1) on port 8000...
```

---

## Triggering Memory Alerts

The Web Service provides an endpoint that artificially allocates memory:

```text
/consume-memory?mb=<size>
```

Example:

```bash
curl "http://<wb-vm address>:8000/consume-memory?mb=100"
```

This allocates approximately 100 MB of memory.

The operation can be repeated multiple times:

```bash
curl "http://<wb-vm address>:8000/consume-memory?mb=100"
curl "http://<wb-vm address>:8000/consume-memory?mb=100"
curl "http://<wb-vm address>:8000/consume-memory?mb=100"
curl "http://<wb-vm address>:8000/consume-memory?mb=100"
```

Once the configured threshold is exceeded, the Web Service publishes a memory alert event to the Subscriber.

---

## Expected Subscriber Output

When memory usage exceeds the threshold, the Subscriber receives and logs the event:

```text
===================================
MEMORY ALERT RECEIVED
Service: web-server
Memory: 402 MB
Threshold: 300 MB
Time: 2025-08-10T12:00:00Z
===================================
```

---

## Monitoring Behavior

The Web Service periodically checks memory usage using Go's runtime package:

```go
runtime.ReadMemStats(...)
```

When memory usage exceeds the configured threshold (300 MB), a `HIGH_MEMORY_USAGE` event is published to the Subscriber.

---

## Network Ports

| Service | Port |
|----------|------|
| Web Service | 8000 |
| Authentication Service | 8002 |
| File Service | 8003 |
| Subscriber | 9000 |

Ensure that these ports are reachable between the virtual machines.