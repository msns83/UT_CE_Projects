#include "redchartwindow.h"
#include "simulationcontroller.h"
#include "router.h"
#include <QtCharts/QChartView>
#include <QtCharts/QChart>
#include <QtCharts/QBarSet>
#include <QtCharts/QBarSeries>
#include <QtCharts/QBarCategoryAxis>
#include <QtCharts/QValueAxis>
#include <QVBoxLayout>
#include <QtGlobal>

RedChartWindow::RedChartWindow(SimulationController* controller, QWidget* parent)
    : QWidget(parent), m_controller(controller)
{
    auto* layout = new QVBoxLayout(this);
    m_view = new QChartView(this);
    m_view->setRenderHint(QPainter::Antialiasing);
    layout->addWidget(m_view);
    setLayout(layout);
    setWindowTitle("RED Drops Distribution");
    resize(700, 450);
    refresh();
}

void RedChartWindow::refresh() {
    if (!m_controller || !m_controller->router()) return;
    const auto stats = m_controller->router()->dropStats();

    auto* redSet = new QBarSet("RED drop");
    auto* capSet = new QBarSet("store speed limit drop");

    for (int i = 0; i <= 6; ++i) {
        redSet->append(static_cast<qreal>(i < stats.red.size() ? stats.red[i] : 0));
        capSet->append(static_cast<qreal>(i < stats.capacity.size() ? stats.capacity[i] : 0));
    }

    auto* series = new QBarSeries();
    series->append(redSet);
    series->append(capSet);

    auto* chart = new QChart();
    chart->addSeries(series);
    chart->setTitle("Dropped packets per buffer size");

    QStringList categories;
    for (int i = 0; i <= 6; ++i) categories << QString::number(i);
    auto* axX = new QBarCategoryAxis();
    axX->append(categories);
    axX->setTitleText("Buffer size (packets)");

    auto* axY = new QValueAxis();
    axY->setTitleText("Dropped packets (count)");
    axY->setLabelFormat("%d");

    qreal yMax = 1.0;
    for (int i = 0; i <= 6; ++i) {
        yMax = qMax(yMax, redSet->at(i));
        yMax = qMax(yMax, capSet->at(i));
    }
    axY->setRange(0, yMax);

    chart->addAxis(axX, Qt::AlignBottom);
    chart->addAxis(axY, Qt::AlignLeft);
    series->attachAxis(axX);
    series->attachAxis(axY);
    chart->legend()->setVisible(true);
    chart->legend()->setAlignment(Qt::AlignBottom);

    m_view->setChart(chart);
}
