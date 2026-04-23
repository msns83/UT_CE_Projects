#include "router.h"
#include "pcnode.h"
#include <QString>

Router::Router(QObject* parent) : QObject(parent) {
    m_dropStats.red      = QVector<quint64>(7, 0);
    m_dropStats.capacity = QVector<quint64>(7, 0);
}

void Router::startNewTick(quint64 tick) {
    m_tick = tick;
    m_acceptedThisTick = 0;
}

double Router::redDropProb(int size) {
    if (size == 0)
        return 0.0;
    if (size >= 4)
        return 1.0;
    if (size >= 2 && size < 4)
        return 0.3 * size - 0.4;
    return 0.0;
}

void Router::receiveFrom(int pcId, const QSharedPointer<Packet>& pkt) {
    const int bufSize = m_buffer.size();
    const int bucket = qBound(0, bufSize, 6);

    if (m_acceptedThisTick >= m_storeCapacityPerTick) {
        m_dropStats.capacity[bucket]++;
        emit logRouter(QString("[T%1] Only can accept %2 packets per tick! so dropped packet %3 from Pc %4 (buffer size= %5)")
                           .arg(m_tick).arg(m_storeCapacityPerTick).arg(pkt->id).arg(pcId).arg(bufSize));
        int backoff = int(QRandomGenerator::global()->bounded(1, 4));
        emit congestion(pcId, backoff);
        return;
    }

    const double p = redDropProb(bufSize);
    const double r = QRandomGenerator::global()->generateDouble();
    if (r < p) {
        m_dropStats.red[bucket]++;
        emit logRouter(QString("[T%1] RED dropped (probabilty: %2) for packet%3 from Pc %4 (buffer size= %5)")
                           .arg(m_tick).arg(p, 0, 'f', 2).arg(pkt->id).arg(pcId).arg(bufSize));
        int backoff = int(QRandomGenerator::global()->bounded(1, 4));
        emit congestion(pcId, backoff);
        return;
    }

    m_buffer.enqueue(pkt);
    m_acceptedThisTick++;
    emit logRouter(QString("[T%1] Stored packet %2 from Pc %3 it's destination is Pc %4 (buffer size= %5)")
                       .arg(m_tick).arg(pkt->id).arg(pcId).arg(pkt->dstId).arg(m_buffer.size()));
}

void Router::tickOutput() {
    QSet<int> sentTo;
    QQueue<QSharedPointer<Packet>> nextBuffer;

    while (!m_buffer.isEmpty()) {
        auto pkt = m_buffer.dequeue();
        const int dst = pkt->dstId;

        if (!sentTo.contains(dst) && m_peers.contains(dst)) {
            sentTo.insert(dst);
            emit logRouter(QString("[T%1] Forwarded packet %2 to Pc %3, it was from Pc %4 (buffer size= %5)")
                               .arg(m_tick).arg(pkt->id).arg(dst).arg(pkt->srcId).arg(m_buffer.size()));
            m_peers[dst]->receiveFromRouter(pkt, m_tick);
        } else {
            nextBuffer.enqueue(pkt);
        }

        if (sentTo.size() == m_peers.size()) {
            while (!m_buffer.isEmpty()) nextBuffer.enqueue(m_buffer.dequeue());
            break;
        }
    }

    m_buffer = std::move(nextBuffer);
}

void Router::resetStats() {
    std::fill(m_dropStats.red.begin(), m_dropStats.red.end(), 0);
    std::fill(m_dropStats.capacity.begin(), m_dropStats.capacity.end(), 0);
}
