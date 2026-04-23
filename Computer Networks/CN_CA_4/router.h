#ifndef ROUTER_H
#define ROUTER_H

#include <QObject>
#include <QQueue>
#include <QSharedPointer>
#include <QRandomGenerator>
#include <QHash>
#include <QSet>
#include <QVector>
#include "packet.h"

class PCNode;

class Router : public QObject {
    Q_OBJECT
public:
    struct DropStats {
        QVector<quint64> red;
        QVector<quint64> capacity;
    };

    explicit Router(QObject* parent = nullptr);

    void startNewTick(quint64 tick);
    void receiveFrom(int pcId, const QSharedPointer<Packet>& pkt);
    void tickOutput();

    static double redDropProb(int size);

    void registerPc(int id, PCNode* pc) { m_peers[id] = pc; }

    DropStats dropStats() const { return m_dropStats; }
    void resetStats();

signals:
    void logRouter(const QString& msg);
    void congestion(int pcId, int backoffTicks);

private:
    QQueue<QSharedPointer<Packet>> m_buffer;
    quint64 m_tick{0};
    int m_acceptedThisTick{0};

    const int m_storeCapacityPerTick = 2;
    const int m_outLinkSpeedPerPc = 1;

    QHash<int, PCNode*> m_peers;

    DropStats m_dropStats;
};

#endif // ROUTER_H
