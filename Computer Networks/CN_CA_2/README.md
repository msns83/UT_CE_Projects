# CN_CA_2

```
pkill -f ChunkServer
```
```
pgrep -fl ChunkServer 
```
```
for p in $(seq 3000 3014); do
  lsof -nP -iUDP:$p
done
```

# Vision

In this project we build a distributed file system.  
Main parts of this system is: **User**, **Manager** and **Chunk Servers**.  
System can do two action:

1. Upload a file  
2. Restore a file

When user want to upload file, he send request to manager.  
Manager use the chunk servers topology and file size to tell user how to upload file in distributed way.

In restore operation, user send a restore request to manager.  
Manager return the locations of file in the system and then user connect to system and take the file.

The manager and user code is run in one computer, and the chunk servers are run in another computer.  
All of them are in same LAN and can talk to each other.


# System Architecture

Our system is designed for storing files by splitting them into small parts called chunks. These chunks are stored on multiple chunk servers.

## Chunk Servers Structure

Chunk servers are organized as a full binary tree and numbered using Depth-First Search (DFS) order. This numbering helps to find the next chunk server in a structured way.

```cpp
void ChunkManager::buildDFSOrder(int nodeId)
{
    if (nodeId >= chunkCount) return;
    dfsOrder.push_back(nodeId);
    buildDFSOrder(2 * nodeId + 1);
    buildDFSOrder(2 * nodeId + 2);
}
````

## Metadata Storage

The manager stores metadata for each file including:

* File name
* File type
* First chunk server where the first chunk of the file is stored

## Communication Protocol

* User to manager communication uses TCP for reliability.
* User to chunk servers communication uses UDP for faster data transfer.

## File Chunks

Files are divided into chunks of 8 KB each.

## Chunk Allocation Strategy

Chunks are allocated to chunk servers in a round robin manner, starting from the last chunk server used to store a previous file. The DFS order is used to traverse the chunk servers.

```cpp
std::vector<int> ChunkManager::allocateChunks(int size, int startChunkId)
{
    std::vector<int> allocatedChunks;
    int totalChunksNeeded = (size + chunkSize - 1) / chunkSize;

    int startIndex = 0;
    while (startIndex < (int)dfsOrder.size() && dfsOrder[startIndex] != startChunkId) {
        ++startIndex;
    }

    for (int i = 0; i < totalChunksNeeded; ++i) {
        int idx = (startIndex + i) % dfsOrder.size();
        allocatedChunks.push_back(dfsOrder[idx]);
    }

    return allocatedChunks;
}
```

The manager keeps track of the last used chunk server with:

```cpp
QMap<QString, int> fileLastChunkMap;
int lastUsedChunkId = 14;
```

This design combines TCP's reliability for control and metadata, with UDP's speed for file chunk transfer. The DFS numbering and round robin chunk allocation help to balance storage load across chunk servers.


# Upload Process

### System Overview

1. **Chunk Server Structure**  
   The chunk servers are arranged in a **complete binary tree**. Each server is assigned an ID using **Breadth-First Search (BFS)** numbering. However, to find the next chunk server, the system uses **Depth-First Search (DFS)** order traversal.

2. **Metadata Management in Manager**  
   The manager stores metadata for each file, including:
   - File name  
   - File type  
   - The **first chunk server** where the first chunk of the file is stored  
   This information is used later for restoration.

3. **Communication**  
   - **User ↔ Manager**: Communication is over **TCP**  
   - **User ↔ Chunk Servers**: Communication is over **UDP**

4. **Chunk Size and Storage**  
   Files are split into chunks of **8 KB**.  
   The chunk servers store chunks using **round-robin** allocation.  
   The manager remembers the **last used chunk ID** and chooses the next one in DFS order for new uploads.

---

### User ↔ Manager Communication

When the user wants to upload a file, it sends a **TCP message** to the manager containing:
- File name  
- File type  
- File size  

After receiving this, the manager:
- Checks which was the last used chunk server.
- Finds the **next server in DFS order**.
- Stores this as the starting server for the new file.
- Sends the user:
  - IP and port of the first chunk server
  - Chunking method (e.g. chunk size)

**Relevant Code:**

```cpp
void ManagerServer::incomingConnection(qintptr socketDescriptor) {
    QTcpSocket *clientSocket = new QTcpSocket(this);
    clientSocket->setSocketDescriptor(socketDescriptor);
    connect(clientSocket, &QTcpSocket::readyRead, this, [=]() {
        QByteArray data = clientSocket->readAll();
        QString message = QString::fromUtf8(data);
        QStringList parts = message.split('|');
        QString cmd = parts[0];

        if (cmd == "UPLOAD") {
            QString fileName = parts[1];
            int fileSize = parts[2].toInt();
            QString fileType = parts[3];

            int startChunkId = (lastUsedChunkId + 1) % chunkManager.getChunkCount();
            std::vector<int> allocatedChunks = chunkManager.allocateChunks(fileSize, startChunkId);
            lastUsedChunkId = allocatedChunks.back();
            fileLastChunkMap[fileName] = allocatedChunks[0];

            int firstChunkId = allocatedChunks[0];
            QString response = QString("ALLOC|%1|%2").arg(chunkServerIp).arg(basePort + firstChunkId);
            clientSocket->write(response.toUtf8());
        }
    });
}
````

---

### User ↔ Chunk Server Communication

After receiving the IP and port of the first chunk server, the user splits the file into 8 KB chunks and sends them using **UDP**.

For each chunk, the user sends a datagram containing:

* `"UPLOAD_CHUNK"` command
* Chunk index (e.g., 0, 1, 2, …)
* Boolean indicating if this is the **last chunk**
* File name
* The chunk data itself

After receiving a chunk:

* The chunk server saves it to disk.
* If it's the last chunk, it logs it.
* Then, it sends back the **port number of the next chunk server**, based on DFS traversal.
* The user uses this port to send the next chunk.

This continues until all chunks are sent.

**Relevant Code:**

```cpp
void ChunkServer::processUploadChunk(const QByteArray &datagram,
                                     const QHostAddress &sender,
                                     quint16 senderPort) {
    int p1 = datagram.indexOf('|');
    int p2 = datagram.indexOf('|', p1 + 1);
    int p3 = datagram.indexOf('|', p2 + 1);
    int p4 = datagram.indexOf('|', p3 + 1);

    int chunkIndex = datagram.mid(p1 + 1, p2 - p1 - 1).toInt();
    bool isLast = datagram.mid(p2 + 1, p3 - p2 - 1).toInt() == 1;
    QString fileName = QString::fromUtf8(datagram.mid(p3 + 1, p4 - p3 - 1));
    QByteArray chunkData = datagram.mid(p4 + 1);

    QString chunkFileName = QString("%1_chunk_%2").arg(fileName).arg(chunkIndex);
    QFile file(storageDir + "/" + chunkFileName);
    file.open(QIODevice::WriteOnly);
    file.write(chunkData);
    file.close();

    quint16 nextPort = getNextNodePort();
    udpSocket.writeDatagram(QString("NEXT|%1").arg(nextPort).toUtf8(), sender, senderPort);
}
```
---

# File Restore Process

## Part 1: User ↔ Manager Communication

When the user wants to **restore** a file, it sends a **restore request** to the **manager** over **TCP**.  
The manager checks its metadata, which includes:
- File name
- File type
- First chunk server's **port**

It then replies to the user with the **port of the first chunk server** where the file's first chunk is stored.

**Relevant Code:**

```cpp
if (cmd == "RESTORE") {
    QString fileName = parts[1];
    if (fileLastChunkMap.contains(fileName)) {
        int chunkId = fileLastChunkMap[fileName];
        QString response = QString("RESTORE_START|%1|%2").arg(chunkServerIp).arg(basePort + chunkId);
        clientSocket->write(response.toUtf8());
    }
}
````

---

## Part 2: User ↔ Chunk Servers

After receiving the port of the first chunk server, the user starts contacting chunk servers using **UDP**.

It sends a **restore request** with:

* `"RESTORE_REQUEST"` command
* File name
* Chunk index (starting from 0)

Each chunk server:

1. Checks if the chunk exists for that index and file name.
2. If it exists:

   * Sends the chunk data
   * Indicates whether it is the **last chunk**
   * Provides the **next chunk server's port**
3. The user:

   * Saves the chunk in memory
   * Checks if it's the last chunk
   * If not, sends the next request to the next chunk server
4. Once all chunks are received, the user:

   * Combines them
   * Trims any extra data
   * Writes the final file to disk

**Relevant Code:**

```cpp
void ChunkServer::processRestoreRequest(const QList<QByteArray> &parts,
                                        const QHostAddress &sender,
                                        quint16 senderPort) {
    QString fileName = QString::fromUtf8(parts[1]);
    int chunkIndex = parts[2].toInt();

    QString chunkFileName = QString("%1_chunk_%2").arg(fileName).arg(chunkIndex);
    QFile file(storageDir + "/" + chunkFileName);

    if (file.exists() && file.open(QIODevice::ReadOnly)) {
        QByteArray data = file.readAll();
        file.close();
        bool isLast = (chunkDataMap.contains(chunkIndex)) && chunkDataMap[chunkIndex].endsWith("LAST");
        quint16 nextPort = getNextNodePort();

        QByteArray response = "CHUNK_DATA|" + QByteArray::number(chunkIndex) + "|" +
                              QByteArray::number(isLast ? 1 : 0) + "|" +
                              QByteArray::number(nextPort) + "|" + data;

        udpSocket.writeDatagram(response, sender, senderPort);
    }
}
```



# Question
1. **How are noise and transmission errors handled in networks?**

   * During data transmission, noise and errors can occur due to interference, signal degradation, or hardware issues. These errors are typically handled using techniques such as **error detection (e.g., checksums, CRC)** and **error correction protocols (e.g., forward error correction, retransmission via ARQ)**. Reliable transport protocols like **TCP** automatically detect and request retransmission of corrupted packets.

2. **Why do video streaming platforms use UDP despite its unreliability, and how do they handle errors?**

   * Video streaming platforms prioritize **low latency** over guaranteed delivery, making **UDP** suitable since it avoids retransmission delays. To manage errors and data loss:

     * They use **adaptive bitrate streaming** to adjust video quality.
     * **Forward Error Correction (FEC)** may be used to reconstruct missing data.
     * **Buffering** and **interleaving** help smooth playback.
     * **Packet loss concealment** techniques fill in missing frames/audio segments.

3. **How are storage-time noise and corruption (data is stored but may become damaged) handled, and what advantages do distributed file systems offer?**

   * Errors after storage can result from hardware failure, bit rot, or corruption. These are mitigated using:

     * **Checksums or hash verification** for integrity checking.
     * **Redundancy and parity blocks** for reconstruction.
     * **Error-correcting codes** (ECC) in memory and storage.
     * Distributed file systems offer **data replication**, **automated rebalancing**, and **self-healing mechanisms**, increasing reliability and availability.

4. **Based on the noise and denoise parameters stored, what percentage of transmitted data is, on average, unrecoverable? How much of the errors are undetectable?**

   * This depends on the channel characteristics and error handling methods. Typically:

     * With strong error correction (e.g., ECC + CRC), **less than 1%** of data might be unrecoverable in poor conditions.
     * **Undetectable errors** are rare and usually below **0.01%**, assuming robust detection like CRC-32 or SHA-based integrity checks.
     * In practice, most errors are either corrected or detected and managed.

5. **Do distributed file systems prevent all types of data corruption? What is the role of replicas in these systems?**

   * Distributed file systems **reduce the risk** of data loss or corruption but cannot guarantee **absolute immunity**. However, they are designed to **detect, isolate, and recover** from failures.

     * **Replicas** are multiple copies of data stored on different nodes or servers.
     * They provide:

       * **High availability**
       * **Fault tolerance**
       * **Data recovery after node failures**
       * Load distribution during read operations

6. **How can distributed file systems eliminate bottlenecks?**

   * They **distribute both data and workload** across multiple servers, avoiding central points of failure.

     * Benefits include:

       * **Parallel processing** of requests
       * **Load balancing**
       * **Dynamic scaling**
     * Metadata servers and chunk storage nodes are often separated to prevent bottlenecks in large-scale systems.

7. **Compare CDNs (Content Delivery Networks) and Distributed File Systems. How do CDNs reduce user access time and what role do distributed file systems play in this?**

   * **CDNs** are designed to **cache and deliver static content** (like videos, images, and scripts) from edge servers close to the user, reducing latency and improving speed.
   * **Distributed File Systems (DFS)** are optimized for **data redundancy, availability, and scalability** in storage.
   * CDNs:

     * Reduce latency by serving content from nearby locations.
     * Handle high traffic efficiently.
   * DFS:

     * Provides backend data resilience and availability.
     * Can serve as a **storage backbone** for CDNs.
     * Useful in dynamically generating or storing large datasets for distribution.


