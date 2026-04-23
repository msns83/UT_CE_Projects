#include "chunkmanager.h"

ChunkManager::ChunkManager(int count, int size)
    : chunkCount(count), chunkSize(size)
{
    for (int i = 0; i < chunkCount; ++i) {
        chunks.push_back(i);
    }
    buildDFSOrder(0);
}

void ChunkManager::buildDFSOrder(int nodeId)
{
    if (nodeId >= chunkCount) return;
    dfsOrder.push_back(nodeId);
    buildDFSOrder(2 * nodeId + 1);
    buildDFSOrder(2 * nodeId + 2);
}

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

int ChunkManager::getChunkCount() const
{
    return chunkCount;
}

int ChunkManager::getNextChunkInDFS(int afterChunkId)
{
    for (std::size_t i = 0; i < dfsOrder.size(); ++i) {
        if (dfsOrder[i] == afterChunkId) {
            return dfsOrder[(i + 1) % dfsOrder.size()];
        }
    }
    return dfsOrder[0];
}
