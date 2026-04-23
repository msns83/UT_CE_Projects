#include "chunkserver.h"
#include "constants.h"
#include <QDir>
#include <QFile>
#include <QDebug>

ChunkServer::ChunkServer(int nodeId,
                         const QString &dirAddr,
                         QObject *parent)
  : QObject(parent),
    nodeId(nodeId),
    chunkManager(15, 8000)
{
    QString root = dirAddr.isEmpty()
                   ? QDir::currentPath()
                   : dirAddr;

    storageDir = QString("%1%2chunk_storage_%3")
                     .arg(root)
                     .arg(QDir::separator())
                     .arg(nodeId);

    QDir d;
    if (!d.exists(storageDir) && !d.mkpath(storageDir)) {
        qCritical() << "Failed to create storage directory:" << storageDir;
    }
}

bool ChunkServer::start()
{
    quint16 port = BASE_PORT + nodeId;
    if (!udpSocket.bind(QHostAddress::AnyIPv4, port)) {
        qCritical() << "Failed to bind UDP socket on port" << port;
        return false;
    }

    connect(&udpSocket, &QUdpSocket::readyRead,
            this, &ChunkServer::onReadyRead);

    qDebug() << "ChunkServer started on port" << port
             << "with ID" << nodeId
             << "storing chunks in" << storageDir;
    return true;
}

void ChunkServer::onReadyRead()
{
    while (udpSocket.hasPendingDatagrams()) {
        QByteArray datagram;
        datagram.resize(int(udpSocket.pendingDatagramSize()));
        QHostAddress sender;
        quint16 senderPort;
        udpSocket.readDatagram(datagram.data(),
                               datagram.size(),
                               &sender,
                               &senderPort);

        int sep = datagram.indexOf('|');
        if (sep < 0) {
            qWarning() << "Malformed packet from"
                       << sender.toString();
            continue;
        }

        QString cmd = QString::fromUtf8(datagram.left(sep));

        if (cmd == "UPLOAD_CHUNK") {
            processUploadChunk(datagram, sender, senderPort);
        }
        else if (cmd == "REQUEST_CHUNK") {
            QList<QByteArray> parts = datagram.split('|');
            processRestoreRequest(parts, sender, senderPort);
        } else if(cmd == "PING") {
            udpSocket.writeDatagram(QString("PUNCH").toUtf8(), sender, senderPort);
        }
        else {
            qWarning() << "Unknown command:" << cmd;
        }
    }
}

void ChunkServer::processUploadChunk(const QByteArray &datagram,
                                     const QHostAddress &sender,
                                     quint16 senderPort) {

    int p1 = datagram.indexOf('|');
    int p2 = datagram.indexOf('|', p1 + 1);
    int p3 = datagram.indexOf('|', p2 + 1);
    int p4 = datagram.indexOf('|', p3 + 1);
    if (p1 < 0 || p2 < 0 || p3 < 0 || p4 < 0) {
        qWarning() << "Invalid UPLOAD_CHUNK header";
        return;
    }

    int chunkIndex = datagram.mid(p1 + 1, p2 - p1 - 1).toInt();
    bool isLast    = datagram.mid(p2 + 1, p3 - p2 - 1).toInt() == 1;
    QString fileName = QString::fromUtf8(
        datagram.mid(p3 + 1, p4 - p3 - 1)
    );

    QByteArray chunkData = datagram.mid(p4 + 1);

    QDir dir(storageDir);
    if (!dir.exists() && !dir.mkpath(storageDir)) {
        qWarning() << "Cannot create storage directory:" << storageDir;
        return;
    }

    QString chunkFileName =
        QString("%1_chunk_%2").arg(fileName).arg(chunkIndex);
    QFile file(dir.filePath(chunkFileName));
    if (!file.open(QIODevice::WriteOnly)) {
        qWarning() << "Failed to open chunk file for writing:"
                   << file.fileName();
        return;
    }
    file.write(chunkData);
    file.close();

    chunkDataMap[chunkFileName] = isLast;

    if (isLast) {
        qDebug() << "Received last chunk" << chunkIndex
                 << "of file" << fileName
                 << "(" << chunkData.size() << " bytes )";
    }

    quint16 nextPort = getNextNodePort();
    udpSocket.writeDatagram(
      QString("NEXT|%1").arg(nextPort).toUtf8(),
      sender, senderPort
    );

    udpSocket.writeDatagram(QString("PUNCH").toUtf8(), sender, senderPort);
}

void ChunkServer::processRestoreRequest(const QList<QByteArray> &parts,
                                        const QHostAddress &sender,
                                        quint16 senderPort)
{
    if (parts.size() < 3) {
        qWarning() << "Invalid REQUEST_CHUNK format";
        return;
    }

    QString fileName = QString::fromUtf8(parts[1]);
    int chunkIdx = parts[2].toInt();

    QDir dir(storageDir);
    QString chunkFile = QString("%1_chunk_%2").arg(fileName).arg(chunkIdx);
    QFile file(dir.filePath(chunkFile));
    if (!file.exists()) {
        qWarning() << "Chunk file not found:" << file.fileName();
        return;
    }
    if (!file.open(QIODevice::ReadOnly)) {
        qWarning() << "Cannot open chunk file:" << file.fileName();
        return;
    }
    QByteArray chunkData = file.readAll();
    file.close();

    bool isLast = chunkDataMap.value(chunkFile, false);

    QByteArray resp = QString("CHUNK_DATA|%1|%2|")
                          .arg(chunkIdx)
                          .arg(isLast ? 1 : 0)
                          .toUtf8();
    resp.append(chunkData);

    resp.append(QString("NEXT_PORT|%1")
                    .arg(BASE_PORT + chunkManager.getNextChunkInDFS(nodeId))
                    .toUtf8());

    udpSocket.writeDatagram(resp, sender, senderPort);
}


quint16 ChunkServer::getNextNodePort()
{
    int nextChunkId = chunkManager.getNextChunkInDFS(nodeId);
    return BASE_PORT + nextChunkId;
}
