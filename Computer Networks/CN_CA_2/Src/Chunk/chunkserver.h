#ifndef CHUNKSERVER_H
#define CHUNKSERVER_H

#include <QObject>
#include <QUdpSocket>
#include <QMap>
#include <QHostAddress>
#include <QByteArray>
#include <QList>
#include "chunkmanager.h"
#include "constants.h"

class ChunkServer : public QObject
{
    Q_OBJECT

public:
    explicit ChunkServer(int nodeId,
                         const QString &dirAddr,
                         QObject *parent = nullptr);
    bool start();

private slots:
    void onReadyRead();

private:
    void processUploadChunk(const QByteArray &datagram,
                            const QHostAddress &sender,
                            quint16 senderPort);
    void processRestoreRequest(const QList<QByteArray> &parts,
                               const QHostAddress &sender,
                               quint16 senderPort);
    quint16 getNextNodePort();

    int nodeId;
    QUdpSocket udpSocket;
    ChunkManager chunkManager;
    QString storageDir;
    QMap<QString, bool> chunkDataMap;
};

#endif