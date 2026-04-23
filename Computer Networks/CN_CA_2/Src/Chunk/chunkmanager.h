#ifndef CHUNKMANAGER_H
#define CHUNKMANAGER_H

#include <vector>

class ChunkManager
{
public:
    ChunkManager(int count, int size);

    std::vector<int> allocateChunks(int size, int startChunkId);
    int getNextChunkInDFS(int afterChunkId);
    int getChunkCount() const;

private:
    void buildDFSOrder(int nodeId);

    int chunkCount;
    int chunkSize;
    std::vector<int> dfsOrder;
    std::vector<int> chunks;
};

#endif
