#ifndef CHUNKMANAGER_H
#define CHUNKMANAGER_H

#include <vector>

class ChunkServer {
public:
    int id;

    ChunkServer(int id);
};

class ChunkManager {
private:
    std::vector<ChunkServer> chunks;
    std::vector<int> dfsOrder;
    int chunkCount;
    int chunkSize;

    void buildDFSOrder(int nodeId);

public:
    ChunkManager(int chunkCount, int chunkSize);
    std::vector<int> allocateChunks(int size, int startChunkId);
    int getChunkCount() const;
    int getNextChunkInDFS(int afterChunkId);
};

#endif
