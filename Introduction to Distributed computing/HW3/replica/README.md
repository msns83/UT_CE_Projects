# Replica Server

## Internal Architecture

The replica server consists of four main components:

1. **Config** (`config.go`) - Loads replica configuration from JSON files
2. **Store** (`store.go`) - Thread-safe in-memory key-value store
3. **Replicator** (`replication.go`) - Handles peer-to-peer data synchronization
4. **ConsistencyManager** (`consistency.go`) - Enforces consistency rules for PUT/GET operations
5. **Metrics** (`versioning.go`) - Tracks performance metrics
6. **Models** (`models.go`) - Data structures (Record, Request/Response types)

## Replication Mechanism

### Eventual Consistency
- After a local write, the replica spawns goroutines to replicate to all peers
- An optional artificial delay simulates network latency
- The PUT returns immediately without waiting for peer acknowledgment
- Replication is "fire and forget" with logging for observability

### Strong Consistency (Simplified)
- After receiving a PUT, the coordinator replicates synchronously to all peers
- Collects acknowledgments from peers
- Requires majority (2 of 3) acks before committing the local write
- If majority is not reached, returns failure to the client

## Versioning

Every key-value pair includes a monotonically increasing version number:
- Each PUT increments the version
- When a replica receives a replication message, it compares versions
- If the incoming version is less than or equal to the current version, the update is rejected
- This prevents stale overwrites

## Conflict Resolution: Last-Write-Wins (LWW)

When concurrent writes create conflicts (same key, different values):
1. Compare version numbers
2. If versions differ, the higher version wins
3. If versions are equal (concurrent writes), compare timestamps
4. The record with the larger timestamp wins
5. All replicas converge to the same value after replication

## Majority Protocol (Strong Consistency)

For 3 replicas, majority = 2 replicas.

The coordinator (replica receiving the client PUT) must:
1. Send replication request to all peers (2 peers)
2. Wait for acknowledgments
3. If at least 1 peer responds (total = 2 including self), achieve majority
4. If majority cannot be achieved, reject the PUT
5. GET requests always read from local store (which is consistent after successful PUT)

## Data Model

```go
type Record struct {
    Key       string `json:"key"`
    Value     string `json:"value"`
    Version   int64  `json:"version"`
    UpdatedBy string `json:"updated_by"`
    Timestamp int64  `json:"timestamp"`
}
```

- `Key` - The stored key
- `Value` - The stored value
- `Version` - Monotonically increasing version number
- `UpdatedBy` - ID of the replica that last updated this record
- `Timestamp` - Nanosecond Unix timestamp for LWW conflict resolution
