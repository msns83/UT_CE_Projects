#ifndef UDPUploader_H
#define UDPUploader_H

#include <QObject>
#include <QUdpSocket>
#include <QFile>
#include <QHostAddress>
#include <QStringList>

class UdpUploader : public QObject {
    Q_OBJECT
public:
    explicit UdpUploader(QObject *parent = nullptr);
    void startUpload(const QString &filePath, const QString &ip, quint16 port, const QStringList &chunkSizes);

signals:
    void uploadFinished();
    void uploadError(const QString &error);

private slots:
    void onReadyRead();

private:
    QUdpSocket udpSocket;
    QFile file;
    QStringList chunkSizeList;
    int currentChunkIndex = 0;
    QString serverIp;
    quint16 currentPort = 0;

    QString targetFileName;

    bool waitingPunch = false;

    void sendChunk();
};

#endif