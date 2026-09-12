# Client

## Overview

A simple CLI client for interacting with the distributed key-value store.

## Usage

```bash
# Store a key-value pair
go run main.go put <key> <value> <host:port>

# Retrieve a value by key
go run main.go get <key> <host:port>

# Show help
go run main.go help
```

## Examples

```bash
# Write to replica1
go run main.go put x 10 localhost:8001

# Read from replica2
go run main.go get x localhost:8002

# Write different values to different replicas
go run main.go put y 20 localhost:8001
go run main.go put y 30 localhost:8002
```

## Notes

- The client is stateless; each command is an independent HTTP request
- Target any replica to read/write; the system handles replication
- The client shows error messages for failed operations
