# Replicated Key-Value Store: Consistency Models in Distributed Systems

## 1. Why Replication?

Replication is a fundamental technique in distributed systems where the same data is stored on multiple nodes. It provides three key benefits:

**Fault Tolerance**: When one replica fails due to hardware malfunction, network partition, or software crash, other replicas continue to serve requests. The system remains operational despite individual node failures. For example, if replica1 crashes, clients can still read and write to replica2 and replica3.

**Availability**: By maintaining multiple copies of data, the system can serve requests even when some nodes are unreachable. This is critical for applications requiring high uptime, such as e-commerce platforms, banking systems, and content delivery networks.

**Scalability**: Multiple replicas can serve read requests in parallel, distributing the load across the system. This horizontal scaling approach allows the system to handle more concurrent users than a single server could manage.

## 2. Replication for Performance vs Fault Tolerance

Replication serves two distinct purposes with different design considerations:

**Performance-Oriented Replication**:
- Primary goal: Reduce read latency by serving data from the nearest replica
- Design: Typically uses asynchronous replication (eventual consistency)
- Tradeoff: May serve slightly stale data for better performance
- Example: CDN edge servers replicating content from origin servers

**Fault Tolerance-Oriented Replication**:
- Primary goal: Ensure data availability despite node failures
- Design: May use synchronous or quorum-based replication (strong consistency)
- Tradeoff: Higher write latency due to coordination overhead
- Example: Database replication for disaster recovery

In practice, most systems balance both goals. This project demonstrates both approaches through its two consistency modes.

## 3. Consistency Problem

When data is replicated across multiple nodes, maintaining consistency becomes challenging:

**Divergence Sources**:
1. **Network Partitions**: Messages between replicas may be delayed, lost, or arrive out of order
2. **Concurrent Writes**: Multiple clients may update the same key simultaneously on different replicas
3. **Replication Delays**: Asynchronous replication creates windows where replicas hold different values
4. **Node Failures**: A failing node may miss updates and fall behind

**Consistency Definition**:
Consistency in this context means that all replicas agree on the current state of the data. Without explicit consistency guarantees, replicas may temporarily (or permanently) disagree on the value of a key.

**Example from this project**:
In eventual consistency mode, after writing `x=10` to replica1, immediately reading `x` from replica2 may return the old value (or a "key not found" error). Only after replication completes do all replicas converge.

## 4. Strong Consistency vs Eventual Consistency

### Strong Consistency

**Definition**: After a write completes, all subsequent reads from any replica return the written value (or a newer one). The system behaves as if there is a single copy of the data.

**Advantages**:
- No stale reads; always returns the most recent data
- Simpler application logic (no need to handle stale data)
- Required for applications with correctness requirements (banking, inventory)

**Disadvantages**:
- Higher write latency (must wait for majority acknowledgment)
- Lower availability (system rejects writes if majority is unreachable)
- Reduced throughput due to synchronization overhead

### Eventual Consistency

**Definition**: If no new updates are made, all replicas will eventually converge to the same value. There is no guarantee about how long convergence takes.

**Advantages**:
- Low write latency (returns immediately after local write)
- High availability (writes succeed even during partial failures)
- Better throughput (no synchronization overhead)

**Disadvantages**:
- Temporary stale reads after writes
- Application must handle inconsistency (read-your-writes issues)
- Longer convergence time during network delays

## 5. Read-Your-Writes Consistency

**Definition**: A user who writes a value should always be able to read their own writes, even if other replicas haven't caught up.

**In this project**: The implementation does NOT guarantee read-your-writes consistency across replicas. If a client writes to replica1 and reads from replica2, it may not see its own write until replication completes. However, reading from the same replica (replica1) that handled the write will always return the latest value because the local store is updated before returning success.

**Real-world examples**:
- Social media: After posting a comment, you expect to see it immediately
- E-commerce: After adding an item to cart, refreshing should show the updated cart
- Cloud storage: After uploading a file, it should appear in your file list

## 6. Monotonic Reads

**Definition**: If a client reads a value at version N, subsequent reads should never return a value with version less than N.

**In this project**: Monotonic reads are guaranteed for single-replica reads. Once a replica receives version N of a key, it will never serve version N-1 (version checking prevents stale overwrites). However, reading from different replicas may temporarily show different versions during propagation.

**Real-world importance**:
- Prevents "time travel" effects where users see older data after seeing newer data
- Essential for user experience in collaborative applications
- Prevents confusion in financial dashboards

## 7. CAP Theorem

The CAP theorem (Brewer's theorem) states that a distributed system can provide at most two of three guarantees:

**Consistency (C)**: Every read receives the most recent write or an error. All nodes see the same data at the same time.

**Availability (A)**: Every request receives a (non-error) response, without guarantee that it contains the most recent write.

**Partition Tolerance (P)**: The system continues to operate despite network partitions (messages lost between nodes).

**Tradeoffs in this project**:

| Mode | Choice | Reason |
|------|--------|--------|
| Eventual | AP | Prioritizes availability and partition tolerance over strong consistency |
| Strong | CP | Prioritizes consistency and partition tolerance over availability |

In practice, network partitions are inevitable, so distributed systems must choose between CP and AP:
- **CP systems** (Strong Consistency): Reject requests during partitions to maintain consistency
- **AP systems** (Eventual Consistency): Accept requests during partitions but may return stale data

This project demonstrates both choices through its two consistency modes.

## 8. Architecture

### Component Descriptions

1. **Config**: Loads replica identity, port, and peer addresses from JSON files
2. **Store**: Thread-safe in-memory map with version tracking
3. **ConsistencyManager**: Handles client requests, enforces consistency rules
4. **Replicator**: Manages peer-to-peer communication (async for eventual, sync for strong)
5. **Metrics**: Tracks PUT/GET latency, convergence time, stale reads

### Data Flow

**PUT Request (Eventual)**:
1. Client sends PUT to any replica
2. ConsistencyManager updates local store
3. Replicator sends async replication to peers
4. Success returned immediately

**PUT Request (Strong)**:
1. Client sends PUT to coordinator replica
2. Coordinator replicates synchronously to peers
3. Waits for majority acknowledgment
4. Updates local store and returns success
5. Returns failure if majority unavailable

**GET Request**:
1. Client sends GET to any replica
2. ConsistencyManager reads from local store
3. Returns the value and version

## 9. Eventual Consistency Implementation

### Mechanism

1. Client sends PUT to replica1
2. Replica1 immediately updates its local store
3. Replica1 spawns goroutines to replicate to all peers
4. PUT returns success immediately (before peers are updated)
5. Each peer receives the update asynchronously and applies it


### Configurable Delay

An artificial delay can be added to simulate network latency:
```bash
go run main.go -config ... -mode eventual -delay 500
```

This delay occurs before sending replication messages, creating a longer window of inconsistency.

### Expected Behavior

- Immediately after PUT, other replicas may return stale data
- After sufficient time, all replicas converge
- Write latency is low (no waiting for peers)
- Read latency is low (local read only)

## 10. Strong Consistency Implementation

### Mechanism

1. Client sends PUT to coordinator replica
2. Coordinator sends replication messages to all peers synchronously
3. Collects acknowledgments from peers
4. Requires majority (2 of 3) to succeed
5. If majority achieved: commits write locally and returns success
6. If majority not achieved: returns failure


### Majority Calculation

For N replicas, majority = floor(N/2) + 1:
- 3 replicas → majority = 2
- 5 replicas → majority = 3
- 7 replicas → majority = 4

### GET Behavior

GET requests read from the local store, which is kept consistent through the synchronous replication protocol. After a successful PUT (majority acks), all replicas that acknowledged have the updated value.

### Expected Behavior

- Write latency is higher (waiting for peers)
- No stale reads after successful PUT
- Writes fail when majority is unreachable
- Lower availability during network issues

## 11. Versioning

### Version Numbers

Each key-value pair includes a monotonically increasing version number:
```
x=10  version=1  (first write)
x=15  version=2  (second write)
x=20  version=3  (third write)
```

### Version-Based Update Rules

When a replica receives a replication message:
1. Compare the incoming version with the current version for that key
2. If incoming > current: accept the update (newer data)
3. If incoming <= current: reject the update (stale data)

### Benefits

- Prevents stale overwrites (an older update never replaces newer data)
- Enables conflict detection (concurrent writes have same version)
- Supports convergence (replicas agree on the version after propagation)

## 12. Conflict Resolution

### Last-Write-Wins (LWW)

When two concurrent writes create conflicting values for the same key:

```
Replica1: x=100, version=1, timestamp=T1
Replica2: x=200, version=1, timestamp=T2 (T2 > T1)
```

Resolution process:
1. Versions are equal (both version 1) → conflict detected
2. Compare timestamps: T2 > T1
3. Replica2's write wins: x=200
4. Both replicas converge to x=200

### Implementation

```go
// In replication handling:
if incomingRecord.Timestamp > currentRecord.Timestamp {
    // Accept the update (Last-Write-Wins)
    store.Put(incomingRecord)
}
```

### Tradeoffs

**Advantages**:
- Simple to implement
- Always converges (no permanent conflicts)
- Deterministic (same inputs produce same outcome)

**Disadvantages**:
- May silently discard updates (the "losing" write is lost)
- Clock skew can affect which write wins
- Not suitable for applications requiring all updates to be preserved
- Does not handle semantic conflicts (e.g., two different operations on the same data)

## 13. Scenario Results

### Scenario 1: Temporary Inconsistency

**Objective**: Demonstrate that eventual consistency allows brief stale reads.

**Setup**: 3 replicas, eventual mode, 500ms delay.

**Steps**:
1. Write `x=10` to replica1
2. Immediately read `x` from replica2
3. Wait 3 seconds
4. Read `x` from replica2 again

**Observations**:
- Immediate read from replica2 returned "Key 'x' not found" (stale)
- After waiting 3 seconds, replica2 returned the correct value `x=10` version=1
- All replicas eventually converge to the same state

**Key Insight**: Eventual consistency trades immediate consistency for higher availability and lower latency. Applications must tolerate temporary inconsistency.

### Scenario 2: Replica Failure

**Objective**: Compare behavior when a replica fails in both consistency modes.

**Setup**: Stop replica3, attempt PUT.

**Eventual Consistency Result**:
- PUT `y=20` to replica1: **SUCCEEDED**
- GET `y` from replica1: `value=20 version=1`
- GET `y` from replica2 (immediately): Key 'y' not found (stale)
- GET `y` from replica2 (after 3s): `value=20 version=1`
- Even with replica3 down, the write was accepted and replicated to replica2
- Reason: Eventual consistency does not require all peers

**Strong Consistency Result**:
- PUT `z=30` to replica1: **SUCCEEDED** (replica2 reachable, majority=2 achieved)
- GET `z` from replica1: `value=30 version=1`
- GET `z` from replica2: `value=30 version=1` (consistent immediately)
- With 2 of 3 replicas running, majority is achievable
- If replica2 also failed: PUT would fail (cannot reach majority)

**Key Insight**: Strong consistency provides stronger guarantees but lower availability during failures. Eventual consistency maintains availability even with partial failures.

### Scenario 3: Concurrent Conflict

**Objective**: Demonstrate Last-Write-Wins conflict resolution.

**Setup**: Simultaneously write different values to same key from two replicas.

**Steps**:
1. Write `conflict=100` to replica1
2. Write `conflict=200` to replica2 (simultaneously)
3. Wait 5 seconds for replication
4. Check final values on all replicas

**Observations**:
- Both writes were accepted locally (different replicas) with version=1
- Replication messages crossed in transit
- Conflict resolution compared timestamps (LWW)
- All replicas converged to `conflict=200` (the write with later timestamp won)
- Final state: all 3 replicas have `conflict=200` version=1

**Key Insight**: LWW provides deterministic convergence but may lose data. For applications requiring all updates to be preserved, alternative strategies (vector clocks, CRDTs) are needed.

### Scenario 4: Network Delay

**Objective**: Measure the impact of replication delay on performance and consistency.

**Setup**: Test with 0ms, 500ms, and 2000ms delays.

**Results**:

| Delay | Mode | PUT Latency | Stale Reads | Convergence |
|-------|------|-------------|-------------|-------------|
| 0ms | Eventual | ~17ms | None | Near-instant |
| 500ms | Eventual | ~21ms | Yes | ~500ms |
| 2000ms | Eventual | ~55ms | Yes | ~2000ms |
| 0ms | Strong | ~28ms | None | Instant |

**Key Insight**: Higher delays increase convergence time and stale reads for eventual consistency. Strong consistency eliminates stale reads at the cost of higher write latency.

## 14. Metrics Table

| Scenario | Consistency Model | PUT Latency (avg) | GET Latency (avg) | Convergence Time | Stale Reads |
|----------|------------------|-------------------|-------------------|------------------|-------------|
| Scenario 1 | Eventual (500ms) | ~17ms | ~12ms | ~500ms | 1 |
| Scenario 2 (Eventual) | Eventual | ~17ms | ~12ms | N/A | 0 |
| Scenario 2 (Strong) | Strong | ~28ms | ~12ms | Instant | 0 |
| Scenario 3 | Eventual (500ms) | ~21ms | ~12ms | ~500ms | 0 |
| Scenario 4 (0ms) | Eventual | ~17ms | ~12ms | Instant | 0 |
| Scenario 4 (500ms) | Eventual | ~21ms | ~14ms | ~500ms | 1 |
| Scenario 4 (2000ms) | Eventual | ~55ms | ~15ms | ~2000ms | 1 |
| Scenario 4 (0ms) | Strong | ~28ms | ~15ms | Instant | 0 |

*Note: Values obtained from experimental runs. Actual values depend on system load and may vary between runs.*

## 15. Comparison Between Eventual and Strong Consistency

### Latency

| Aspect | Eventual | Strong |
|--------|----------|--------|
| Write Latency | Low (local write + async replication) | High (sync replication + majority wait) |
| Read Latency | Low (local read) | Low (local read, but guaranteed consistent) |
| Throughput | Higher (no sync overhead) | Lower (coordination overhead) |

### Availability

| Aspect | Eventual | Strong |
|--------|----------|--------|
| During Normal Operation | High | High |
| During Partial Failure | High (write succeeds locally) | Lower (may fail if majority unreachable) |
| During Network Partition | High (continues with available replicas) | Low (rejects writes to maintain consistency) |

### Stale Reads

| Aspect | Eventual | Strong |
|--------|----------|--------|
| Probability | Possible during convergence window | None after successful write |
| Duration | Depends on replication delay | N/A |
| Impact on Application | Must handle stale data | Simple application logic |

### Convergence

| Aspect | Eventual | Strong |
|--------|----------|--------|
| After Normal Write | ~100ms to seconds | Instant (synchronous) |
| After Conflict | Deterministic (LWW) | N/A (prevented by majority) |
| After Partition Recovery | Automatic (anti-entropy) | Requires manual sync |

### Summary

| Criteria | Eventual Wins | Strong Wins |
|----------|--------------|-------------|
| Write Performance | x | |
| Availability | x | |
| Read Consistency | | x |
| Simplicity | | x |
| Fault Tolerance | | |

## 16. Limitations

This implementation has several limitations that should be noted:

1. **No Persistent Storage**: All data is stored in memory. If all replicas restart, all data is lost.

2. **No Leader Election**: The strong consistency mode uses a static coordinator. Real systems use leader election (Raft, Paxos) to handle coordinator failures.

3. **No Quorum Reads**: GET requests read from a single replica. True quorum reads would contact multiple replicas for consistency guarantees.

4. **No Byzantine Fault Tolerance**: The system assumes replicas are honest and follow the protocol. Byzantine fault tolerance requires additional mechanisms (digital signatures, consensus protocols).

5. **Simplified Strong Consistency**: The implementation uses majority acknowledgment but does not implement a full consensus protocol like Raft or Paxos.

6. **No Split-Brain Prevention**: During network partitions, multiple coordinators may operate independently, leading to split-brain scenarios.

7. **No Read Repair**: After detecting stale reads, the system does not automatically repair them (anti-entropy with Merkle trees).

8. **Clock Dependency**: LWW conflict resolution depends on accurate clock synchronization across replicas. In practice, NTP or logical clocks should be used.

9. **No Client-Aware Consistency**: The system does not track which replicas a client has read from/written to (required for read-your-writes and monotonic reads guarantees).

10. **Educational Implementation**: This project is designed for learning purposes, not production use. Production systems require extensive testing, monitoring, and additional features.
