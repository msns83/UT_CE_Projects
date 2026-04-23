#include "pcnode.h"
#include "router.h"
#include <QString>
#include <QDateTime>

PCNode::PCNode(int id, QObject* parent): QObject(parent), m_id(id) {
    std::random_device rd;
    m_rng.seed(rd());
}

void PCNode::tickGenerate(quint64 tick) {
    m_tick = tick;

    int k = m_poisson(m_rng);

    int candidates[2];
    int c = 0;
    for (int pid = 1; pid <= 3; ++pid)
        if (pid != m_id)
            candidates[c++] = pid;

    std::uniform_int_distribution<int> pick(0, 1);
    int receiverId = candidates[pick(m_rng)];

    for (int i = 0; i < k; ++i) {
        auto pkt = QSharedPointer<Packet>::create();
        pkt->id = (m_id * 1'000'000ull) + m_nextLocalId++;
        pkt->srcId = m_id;
        pkt->dstId = receiverId;

        pkt->createdTick = m_tick;
        m_linkQueue.enqueue(pkt);
    }

    if (k > 0) {
        emit logPc(m_id, QString("[T%1] Generated %2 packets for Pc %3 (on the link= %4)").arg(m_tick).arg(k).arg(receiverId).arg(m_linkQueue.size()));
    } else {
        emit logPc(m_id, QString("[T%1] Generated no packets in this tick (on the link= %4)").arg(m_tick).arg(m_linkQueue.size()));
    }
}

void PCNode::tickSend(Router* router) {

    int sent = 0;
    while (sent < m_linkSpeedToRouter && !m_linkQueue.isEmpty()) {
        if (m_backoffTicks > 0) {
            m_backoffTicks--;
            emit logPc(m_id, QString("[T%1] Congestion waiting... (%2 ticks left)").arg(m_tick).arg(m_backoffTicks));
            return;
        }
        auto pkt = m_linkQueue.dequeue();
        emit logPc(m_id, QString("[T%1] This Pc link: Packet %2 for Pc %3 arrived to Router (on the link= %4)")
                             .arg(m_tick).arg(pkt->id).arg(pkt->dstId).arg(m_linkQueue.size()));
        router->receiveFrom(m_id, pkt);
        sent++;
    }
}

void PCNode::onCongestion(int pcId, int backoffTicks) {
    if (pcId != m_id) return;
    m_backoffTicks = qMax(m_backoffTicks, backoffTicks);
    emit logPc(m_id, QString("[T%1] Received congestion signal from Router: wait for %2 ticks").arg(m_tick).arg(backoffTicks));
}

void PCNode::receiveFromRouter(const QSharedPointer<Packet>& pkt, quint64 tick) {
    emit logPc(m_id, QString("[T%1] Received packet %2 from Pc %3")
                         .arg(tick).arg(pkt->id).arg(pkt->srcId));
}

