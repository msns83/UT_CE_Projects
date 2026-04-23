#include "simulationcontroller.h"
#include <algorithm>
#include <random>

SimulationController::SimulationController(QObject* parent)
    : QObject(parent)
{
    m_router = new Router(this);

    for (int i = 1; i <= 3; ++i) {
        auto pc = new PCNode(i, this);
        m_pcs.push_back(pc);
        m_router->registerPc(i, pc);

        connect(pc, &PCNode::logPc, this, &SimulationController::logPc);
        connect(m_router, &Router::congestion, pc, &PCNode::onCongestion);
    }

    connect(m_router, &Router::logRouter, this, &SimulationController::logRouter);
    connect(&m_timer, &QTimer::timeout, this, &SimulationController::onTick);
}

SimulationController::~SimulationController() = default;

void SimulationController::start(int intervalMs) {
    if (!m_timer.isActive())
        m_timer.start(intervalMs);
}

void SimulationController::stop() {
    if (m_timer.isActive())
        m_timer.stop();
}

bool SimulationController::isRunning() const {
    return m_timer.isActive();
}

void SimulationController::onTick() {
    m_tick++;
    m_router->startNewTick(m_tick);

    auto order = m_pcs;
    static thread_local std::mt19937_64 rng{std::random_device{}()};
    std::shuffle(order.begin(), order.end(), rng);

    if(m_multiSender){
        for (auto* pc : order)
            pc->tickGenerate(m_tick);
        for (auto* pc : order)
            pc->tickSend(m_router);
    } else {
        auto* pc = order[0];
        pc->tickGenerate(m_tick);
        pc->tickSend(m_router);
    }


    m_router->tickOutput();
}
