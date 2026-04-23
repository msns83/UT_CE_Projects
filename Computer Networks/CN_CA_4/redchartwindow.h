#ifndef REDCHARTWINDOW_H
#define REDCHARTWINDOW_H

#include <QWidget>

class QChartView;
class SimulationController;

class RedChartWindow : public QWidget {
    Q_OBJECT
public:
    explicit RedChartWindow(SimulationController* controller, QWidget* parent = nullptr);
    void refresh();

private:
    QChartView* m_view{nullptr};
    SimulationController* m_controller{nullptr};
};

#endif // REDCHARTWINDOW_H
