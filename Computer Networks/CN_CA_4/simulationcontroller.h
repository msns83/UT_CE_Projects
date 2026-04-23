#ifndef SIMULATIONCONTROLLER_H
#define SIMULATIONCONTROLLER_H

#include <QObject>
#include <QVector>
#include <QTimer>
#include "router.h"
#include "pcnode.h"

class SimulationController : public QObject {
    Q_OBJECT
public:
    explicit SimulationController(QObject* parent = nullptr);
    ~SimulationController();

    void start(int intervalMs = 500);
    void stop();
    bool isRunning() const;
    void toggleMultiSender(bool checked) {m_multiSender = checked ;}
    Router* router() const { return m_router; }

signals:
    void logPc(int pcId, const QString& msg);
    void logRouter(const QString& msg);

private slots:
    void onTick();

private:
    QTimer m_timer;
    quint64 m_tick{0};
    Router* m_router{nullptr};
    QVector<PCNode*> m_pcs;
    bool m_multiSender{false};
};

#endif // SIMULATIONCONTROLLER_H
