#ifndef PCNODE_H
#define PCNODE_H

#include <QObject>
#include <QQueue>
#include <QSharedPointer>
#include <random>
#include "packet.h"

class Router;

class PCNode : public QObject {
    Q_OBJECT
public:
    explicit PCNode(int id, QObject* parent = nullptr);

    void tickGenerate(quint64 tick);
    void tickSend(Router* router);
    void receiveFromRouter(const QSharedPointer<Packet>& pkt, quint64 tick);

signals:
    void logPc(int pcId, const QString& msg);

public slots:
    void onCongestion(int pcId, int backoffTicks);

private:
    int m_id;
    QQueue<QSharedPointer<Packet>> m_linkQueue;
    int m_linkSpeedToRouter = 2;
    int m_backoffTicks = 0;
    quint64 m_nextLocalId = 1;
    quint64 m_tick{0};

    std::mt19937_64 m_rng;
    std::poisson_distribution<int> m_poisson{2.0};
};

#endif // PCNODE_H
