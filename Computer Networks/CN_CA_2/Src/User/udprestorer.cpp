#include "udprestorer.h"
#include <QDebug>

UdpRestorer::UdpRestorer(QObject *parent)
  : QObject(parent)
{
    connect(&udpSocket,
            &QUdpSocket::readyRead,
            this,
            &UdpRestorer::onReadyRead);
}

void UdpRestorer::startRestore(const QString &fileName,
                               const QString &ip,
                               quint16 port)
{
    chunkMap.clear();
    targetFileName  = fileName;
    serverIp        = ip;
    currentPort     = port;
    currentChunkIndex = 1;
    lastChunkIndex    = 0;
    requestChunk();
}

void UdpRestorer::requestChunk()
{
    QByteArray msg = QString("REQUEST_CHUNK|%1|%2")
                         .arg(targetFileName)
                         .arg(currentChunkIndex)
                         .toUtf8();
    udpSocket.writeDatagram(msg,
                            QHostAddress(serverIp),
                            currentPort);
}

void UdpRestorer::onReadyRead()
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

        int p1 = datagram.indexOf('|');
        int p2 = datagram.indexOf('|', p1 + 1);
        int p3 = datagram.indexOf('|', p2 + 1);
        if (p1 < 0 || p2 < 0 || p3 < 0) {
            emit restoreError("Invalid CHUNK_DATA header");
            return;
        }

        int chunkIndex = datagram.mid(p1 + 1, p2 - p1 - 1).toInt();
        bool isLast = datagram.mid(p2 + 1, p3 - p2 - 1).toInt() == 1;
        int dataOffset = p3 + 1;

        QByteArray marker = "NEXT_PORT|";
        int nextPortPos = datagram.indexOf(marker, dataOffset);

        QByteArray chunkData;
        if (nextPortPos > dataOffset) {
            chunkData = datagram.mid(dataOffset, nextPortPos - dataOffset);
        } else {
            chunkData = datagram.mid(dataOffset);
        }

        chunkMap[chunkIndex] = chunkData;

        if (isLast)
            lastChunkIndex = chunkIndex;

        if (lastChunkIndex > 0 &&
            chunkMap.size() >= lastChunkIndex) {
            QByteArray fullFile;
            for (int i = 1; i <= lastChunkIndex; ++i)
                fullFile.append(chunkMap.value(i));
            emit restoreFinished(fullFile);
            return;
        }

        if (nextPortPos < 0) {
            emit restoreError("Missing NEXT_PORT in response");
            return;
        }
        QByteArray portPart = datagram.mid(nextPortPos + marker.size());
        bool ok = false;
        quint16 nextPort = portPart.trimmed().toUShort(&ok);
        if (!ok) {
            emit restoreError("Invalid NEXT_PORT number");
            return;
        }

        currentPort = nextPort;
        currentChunkIndex++;
        requestChunk();
    }
}
