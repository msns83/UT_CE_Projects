#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>

class QPushButton;
class QLabel;

class MainWindow : public QMainWindow {
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

private slots:
    void onUploadClicked();
    void onRestoreClicked();

private:
    QPushButton *uploadButton;
    QPushButton *restoreButton;
    QLabel *infoLabel;

    bool showAllocationInfoDialog(const QString &infoText);
};

#endif
