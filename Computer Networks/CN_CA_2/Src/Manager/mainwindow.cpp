#include "mainwindow.h"
#include "managerserver.h"

#include <QVBoxLayout>
#include <QTextEdit>
#include <QWidget>
#include <QMessageBox>

MainWindow::MainWindow(QWidget *parent): QMainWindow(parent) {
    setWindowTitle("Distributed File System Manager");
    resize(500, 400);

    QWidget *central = new QWidget(this);
    QVBoxLayout *layout = new QVBoxLayout(central);

    logView = new QTextEdit(this);
    logView->setReadOnly(true);

    layout->addWidget(logView);
    setCentralWidget(central);

    server = new ManagerServer(this);
    connect(server, &ManagerServer::metadataReceived, this, &MainWindow::displayMetadata);

    if (!server->startListening(2000))
        QMessageBox::critical(this, "Error", "Failed to listen on port 2000");

}

MainWindow::~MainWindow() {}

void MainWindow::displayMetadata(const QString &data) {
    logView->append("Received:\n" + data + "\n---------------------\n");
}
