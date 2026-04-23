#ifndef PACKET_H
#define PACKET_H

#include <QtGlobal>

struct Packet {
    quint64 id;
    int srcId;
    int dstId;
    quint64 createdTick;
};

#endif // PACKET_H