#include "mainwindow.h"
#include "metadatasender.h"
#include "udpuploader.h"
#include "udprestorer.h"
#include <QVBoxLayout>
#include <QPushButton>
#include <QLabel>
#include <QMessageBox>
#include <QFileDialog>
#include <QInputDialog>
#include <QDialog>
#include <QTextEdit>
#include <QDialogButtonBox>
#include <QDebug>

MainWindow::MainWindow(QWidget *parent): QMainWindow(parent) {
    QWidget *centralWidget = new QWidget(this);
    QVBoxLayout *layout = new QVBoxLayout(centralWidget);

    uploadButton = new QPushButton("Upload File", this);
    restoreButton = new QPushButton("Download File", this);
    infoLabel = new QLabel(this);
    infoLabel->setWordWrap(true);

    layout->addWidget(uploadButton);
    layout->addWidget(restoreButton);
    layout->addWidget(infoLabel);

    connect(uploadButton, &QPushButton::clicked, this, &MainWindow::onUploadClicked);
    connect(restoreButton, &QPushButton::clicked, this, &MainWindow::onRestoreClicked);

    setCentralWidget(centralWidget);
    setWindowTitle("Distributed File Manager");
    resize(400, 250);
}

MainWindow::~MainWindow() {}

bool MainWindow::showAllocationInfoDialog(const QString &infoText) {
    QDialog dialog(this);
    dialog.setWindowTitle("Manager Allocation Info");
    QVBoxLayout layout(&dialog);

    QTextEdit *textEdit = new QTextEdit(&dialog);
    textEdit->setReadOnly(true);
    textEdit->setText(infoText);
    layout.addWidget(textEdit);
    dialog.exec();

    return true ;
}


void MainWindow::onUploadClicked() {
    QString filePath = QFileDialog::getOpenFileName(this, "Select a file to upload");
    if (filePath.isEmpty()) return;

    QFileInfo fileInfo(filePath);
    QFile file(filePath);

    if (!file.open(QIODevice::ReadOnly)) {
        QMessageBox::warning(this, "Error", "Failed to open selected file.");
        return;
    }

    Metadata metadata;
    metadata.fileName = fileInfo.fileName();
    metadata.fileSize = QString::number(file.size());
    metadata.fileType = fileInfo.suffix();

    infoLabel->setText(metadata.toDisplay());

    MetadataSender sender;
    QString allocationResponse = sender.sendUploadToManager(metadata);
    if (allocationResponse.isEmpty()) {
        QMessageBox::warning(this, "Error", "Failed to connect to manager node or no response.");
        return;
    }

    QStringList parts = allocationResponse.split('|');
    if (parts.size() < 3) {
        QMessageBox::warning(this, "Error", "Invalid allocation response:\n" + allocationResponse);
        return;
    }

    QString ip = parts[0];
    quint16 port = parts[1].toUShort();
    QStringList chunkSizes = parts[2].split(',');

    QString infoText = QString("Manager allocated:\nIP: %1\nPort: %2\nChunk sizes: %3").arg(ip).arg(port).arg(parts[2]);
    bool proceed = showAllocationInfoDialog(infoText);
    if (!proceed) {
        infoLabel->setText("Upload cancelled by user.");
        return;
    }

    UdpUploader *uploader = new UdpUploader(this);
    
    connect(uploader, &UdpUploader::uploadFinished, this, [this, uploader]() {
        QMessageBox::information(this, "Upload", "File uploaded successfully.");
        uploader->deleteLater();
    });

    connect(uploader, &UdpUploader::uploadError, this, [this, uploader](const QString &err) {
        QMessageBox::warning(this, "Upload Error", err);
        uploader->deleteLater();
    });

    uploader->startUpload(filePath, ip, port, chunkSizes);
}


void MainWindow::onRestoreClicked() {
    bool ok;
    QString fileName = QInputDialog::getText(this, "Restore File",
                                             "Enter file name to restore:",
                                             QLineEdit::Normal, "", &ok);
    if (!ok || fileName.isEmpty()) return;

    MetadataSender sender;
    QString response = sender.sendRestoreToManager(fileName);

    if (response.isEmpty()) {
        QMessageBox::warning(this, "Error", "Failed to connect to manager node or no response.");
        return;
    }

    if (response == "File not found") {
        QMessageBox::warning(this, "Error", "File not found on manager node.");
        return;
    }

    QStringList parts = response.split('|');
    if (parts.size() != 2) {
        QMessageBox::warning(this, "Error", "Invalid response from manager: " + response);
        return;
    }

    QString ip = parts[0];
    quint16 port = parts[1].toUShort();

    QString infoText = QString("Manager allocated:\nIP: %1\nPort: %2").arg(ip).arg(port);
    bool proceed = showAllocationInfoDialog(infoText);
    if (!proceed) {
        infoLabel->setText("Restore cancelled by user.");
        return;
    }

    UdpRestorer *restorer = new UdpRestorer(this);
    connect(restorer, &UdpRestorer::restoreFinished, this, [this, restorer, fileName](const QByteArray &data) {
        QString savePath = QFileDialog::getSaveFileName(this, "Save Restored File", fileName);
        if (!savePath.isEmpty()) {
            QFile file(savePath);
            if (file.open(QIODevice::WriteOnly)) {
                file.write(data);
                file.close();
                QMessageBox::information(this, "Restore", "File restored and saved successfully.");
            } else {
                QMessageBox::warning(this, "Error", "Cannot save file to disk.");
            }
        }
        restorer->deleteLater();
    });

    connect(restorer, &UdpRestorer::restoreError, this, [this, restorer](const QString &error) {
        QMessageBox::warning(this, "Restore Error", error);
        restorer->deleteLater();
    });

    restorer->startRestore(fileName, ip, port);
}
