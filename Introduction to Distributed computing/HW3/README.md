# Distributed Key-Value Store with Replication

A replicated key-value store demonstrating consistency models in distributed systems. Implements three independent replicas communicating over HTTP/JSON with support for **Eventual Consistency** and **Simplified Strong Consistency**.

## Project Objective

This project explores fundamental distributed systems concepts:
- Data replication across multiple nodes
- Eventual vs. strong consistency tradeoffs
- Version-based conflict resolution (Last-Write-Wins)
- The impact of network delays and failures on consistency

## Architecture


Each replica runs as an **independent process** with its own HTTP server, in-memory store, and configuration. Replicas communicate peer-to-peer via HTTP POST requests.

## APIs

### Client APIs

**PUT** - Store a key-value pair
```
PUT /put
Body: {"key": "x", "value": "10"}
Response: {"success": true}
```

**GET** - Retrieve a value
```
GET /get?key=x
Response: {"key": "x", "value": "10", "version": 3}
```

### Internal APIs

**Replicate** - Synchronize data between replicas
```
POST /replicate
Body: {"key": "x", "value": "10", "version": 3, "updated_by": "replica1", "timestamp": 123456789}
Response: {"success": true}
```

**Health Check**
```
GET /health
Response: {"status": "ok", "id": "replica1", "mode": "eventual"}
```

## Configuration

Each replica has a JSON configuration file in `configs/`:

```json
{
  "id": "replica1",
  "port": 8001,
  "peers": ["http://localhost:8002", "http://localhost:8003"]
}
```

## Compilation and Running

### Build the replica
```bash
cd replica
go build -o replica .
```

### Start replicas

**Eventual Consistency (no delay):**
```bash
bash scripts/start_replicas.sh eventual 0
```

**Eventual Consistency (500ms delay):**
```bash
bash scripts/start_replicas.sh eventual 500
```

**Strong Consistency:**
```bash
bash scripts/start_replicas.sh strong 0
```

### Stop all replicas
```bash
bash scripts/stop_replicas.sh
```

### Run individual replicas manually
```bash
cd replica
go run main.go -config ../configs/replica1.json -mode eventual -delay 0
go run main.go -config ../configs/replica2.json -mode eventual -delay 0
go run main.go -config ../configs/replica3.json -mode eventual -delay 0
```

## Using the Client

```bash
cd client

# PUT operations
go run main.go put x 10 localhost:8001
go run main.go put y 20 localhost:8002
go run main.go put x 30 localhost:8003

# GET operations
go run main.go get x localhost:8001
go run main.go get y localhost:8002

# Help
go run main.go help
```

## Consistency Modes

### Eventual Consistency
- Writes return immediately
- Replication happens asynchronously in the background
- Short window of inconsistency after writes
- Highly available even during partial failures

```bash
bash scripts/start_replicas.sh eventual 0
```

### Strong Consistency
- Writes block until majority (2 of 3) replicas acknowledge
- Guaranteed consistent reads after successful PUT
- Lower availability when replicas are slow or down

```bash
bash scripts/start_replicas.sh strong 0
```

## Executing Scenarios

Each scenario builds dedicated temporary binaries, starts three verified replica
processes, captures the live HTTP responses in `results/scenarioN.txt`, and
updates `results/metrics.txt` with measurements from that execution. The
measurements exclude Go compilation time.

### Scenario 1: Temporary Inconsistency
Demonstrates that eventual consistency allows brief stale reads.
```bash
bash scripts/scenario1.sh
```

### Scenario 2: Replica Failure
Compares behavior when a replica goes down in both consistency modes.
```bash
bash scripts/scenario2.sh
```

### Scenario 3: Concurrent Conflict
Shows Last-Write-Wins conflict resolution with simultaneous writes.
```bash
bash scripts/scenario3.sh
```

### Scenario 4: Network Delay
Measures the impact of artificial replication delays on performance.
```bash
bash scripts/scenario4.sh
```

## Collecting Metrics

Scenario scripts automatically generate results in `results/`:
- `scenario1.txt` through `scenario4.txt` - Captured live scenario output
- `metric_scenario1.tsv` through `metric_scenario4.tsv` - Machine-readable measured rows
- `metrics.txt` - Combined measured PUT latency, GET latency, convergence time, stale reads, updated replicas, and outcomes

Run all scenarios at least once to produce a complete table:

```bash
bash scripts/scenario1.sh
bash scripts/scenario2.sh
bash scripts/scenario3.sh
bash scripts/scenario4.sh
cat results/metrics.txt
```

The scripts measure HTTP round-trip latency with `curl` and poll the live
replicas to observe convergence. Exact values vary with system load.

## Project Structure

```
HW3/
├── README.md              # This file
├── go.mod                 # Go module definition
├── replica/               # Replica server
│   ├── main.go            # Entry point, HTTP server setup
│   ├── server.go          # (reserved for future extensions)
│   ├── store.go           # In-memory key-value store
│   ├── replication.go     # Replication logic (async/sync)
│   ├── consistency.go     # Consistency manager (PUT/GET handlers)
│   ├── versioning.go      # Versioning and metrics
│   ├── models.go          # Data structures
│   ├── config.go          # Configuration loading
│   └── README.md          # Replica documentation
├── client/                # CLI client
│   ├── main.go            # Client entry point
│   └── README.md          # Client documentation
├── configs/               # Replica configurations
│   ├── replica1.json
│   ├── replica2.json
│   └── replica3.json
├── scripts/               # Automation scripts
│   ├── common.sh          # Shared process management and metric helpers
│   ├── start_replicas.sh
│   ├── stop_replicas.sh
│   ├── scenario1.sh
│   ├── scenario2.sh
│   ├── scenario3.sh
│   └── scenario4.sh
├── results/               # Experiment outputs
│   ├── scenario1.txt
│   ├── scenario2.txt
│   ├── scenario3.txt
│   ├── scenario4.txt
│   └── metrics.txt
└── report/                # Written report
    └── report.md
```

## Requirements

- Go 1.21 or later
- No external dependencies (standard library only)
