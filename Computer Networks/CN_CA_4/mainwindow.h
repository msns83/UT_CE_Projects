#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>

class SimulationController;
class RedChartWindow;
class QTextEdit;

QT_BEGIN_NAMESPACE
namespace Ui { class MainWindow; }
QT_END_NAMESPACE

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

private slots:
    void onStart();
    void onStop();
    void onClear();
    void onReset();
    void onOpenChart();
    void onMultiSenderToggled(bool checked);
    void handlePcLog(int pcId, const QString& msg);
    void handleRouterLog(const QString& msg);


private:
    void appendLog(QTextEdit* edit, const QString& msg);

    Ui::MainWindow *ui;
    SimulationController* m_controller{nullptr};
    RedChartWindow* m_chart{nullptr};
    bool multisender_s{false};
};

#endif // MAINWINDOW_H
