#include "udpuploader.h"
#include <QFileInfo>

UdpUploader::UdpUploader(QObject *parent) : QObject(parent) {
    connect(&udpSocket, &QUdpSocket::readyRead, this, &UdpUploader::onReadyRead);
}

void UdpUploader::startUpload(const QString &filePath, const QString &ip, quint16 port, const QStringList &chunkSizes) {
    if (file.isOpen())
        file.close();

    file.setFileName(filePath);

    if (!file.open(QIODevice::ReadOnly)) {
        emit uploadError("Failed to open file");
        return;
    }

    targetFileName = QFileInfo(filePath).fileName();

    serverIp        = ip;
    currentPort     = port;
    chunkSizeList   = chunkSizes;
    currentChunkIndex = 0;
    waitingPunch    = false;

    udpSocket.bind(QHostAddress::AnyIPv4, 5010, QUdpSocket::ShareAddress | QUdpSocket::ReuseAddressHint);

    sendChunk();
}

void UdpUploader::sendChunk() {
    if (!waitingPunch) {
        udpSocket.writeDatagram(QString("PING|").toUtf8(), QHostAddress(serverIp),currentPort);
        waitingPunch = true;
        return;
    }

    waitingPunch = false;

    if (currentChunkIndex >= chunkSizeList.size()) {
        emit uploadFinished();
        file.close();
        return;
    }

    int size = chunkSizeList[currentChunkIndex].toInt();
    QByteArray chunkData = file.read(size);
    bool isLast = (currentChunkIndex == chunkSizeList.size() - 1);

    QByteArray header = QString("UPLOAD_CHUNK|%1|%2|%3|").arg(currentChunkIndex + 1).arg(isLast ? 1 : 0).arg(targetFileName).toUtf8();

    QByteArray message = header + chunkData;
    udpSocket.writeDatagram(message, QHostAddress(serverIp), currentPort);

    currentChunkIndex++;
}

void UdpUploader::onReadyRead() {
    while (udpSocket.hasPendingDatagrams()) {
        QByteArray datagram;
        datagram.resize(int(udpSocket.pendingDatagramSize()));
        QHostAddress sender;
        quint16 senderPort;
        udpSocket.readDatagram(
          datagram.data(),
          datagram.size(),
          &sender,
          &senderPort
        );


        if (QString::fromUtf8(datagram) == "PUNCH") {
            sendChunk();
        }
        
        else if (datagram.startsWith("NEXT|")) {
            auto parts = QString::fromUtf8(datagram).split('|');
            if (parts.size()==2)
                currentPort = parts[1].toUShort();
        }
    }
}




