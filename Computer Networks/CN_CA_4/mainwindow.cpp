#include "mainwindow.h"
#include "ui_mainwindow.h"
#include "simulationcontroller.h"
#include "redchartwindow.h"
#include <QTextEdit>
#include <QPushButton>

MainWindow::MainWindow(QWidget *parent): QMainWindow(parent) , ui(new Ui::MainWindow)
    , m_controller(new SimulationController(this))
{
    ui->setupUi(this);

    connect(ui->startButton, &QPushButton::clicked, this, &MainWindow::onStart);
    connect(ui->stopButton,  &QPushButton::clicked, this, &MainWindow::onStop);
    connect(ui->clearButton, &QPushButton::clicked, this, &MainWindow::onClear);
    connect(ui->resetButton, &QPushButton::clicked, this, &MainWindow::onReset);
    connect(ui->openChartButton, &QPushButton::clicked, this, &MainWindow::onOpenChart);
    connect(ui->multiSenderCheck, &QCheckBox::toggled, this, &MainWindow::onMultiSenderToggled);

    connect(m_controller, &SimulationController::logPc, this, &MainWindow::handlePcLog);
    connect(m_controller, &SimulationController::logRouter, this, &MainWindow::handleRouterLog);
}

void MainWindow::onStart() {
    m_controller->start(1500);
}

void MainWindow::onStop() {
    m_controller->stop();
}

void MainWindow::onClear() {
    ui->pc1Log->clear();
    ui->pc2Log->clear();
    ui->pc3Log->clear();
    ui->routerLog->clear();
}

void MainWindow::onReset() {
    delete m_controller;
    delete m_chart;

    m_controller = new SimulationController(this);
    m_chart = nullptr ;

    connect(m_controller, &SimulationController::logPc, this, &MainWindow::handlePcLog);
    connect(m_controller, &SimulationController::logRouter, this, &MainWindow::handleRouterLog);
    m_controller->toggleMultiSender(multisender_s);

    this->onClear();
}

void MainWindow::onMultiSenderToggled(bool checked) {
    multisender_s = checked ;
    m_controller->toggleMultiSender(multisender_s);
}

void MainWindow::appendLog(QTextEdit* edit, const QString& msg) {
    edit->append(msg);
}

void MainWindow::handlePcLog(int pcId, const QString& msg) {
    switch (pcId) {
    case 1:
        appendLog(ui->pc1Log, msg);
        break;
    case 2:
        appendLog(ui->pc2Log, msg);
        break;
    case 3:
        appendLog(ui->pc3Log, msg);
        break;
    default:
        break;
    }
}

void MainWindow::handleRouterLog(const QString& msg) {
    appendLog(ui->routerLog, msg);
}

void MainWindow::onOpenChart() {
    if (!m_chart)
        m_chart = new RedChartWindow(m_controller, nullptr);
    m_chart->refresh();
    m_chart->show();
    m_chart->raise();
    m_chart->activateWindow();
}

MainWindow::~MainWindow() {
    delete ui;
}
