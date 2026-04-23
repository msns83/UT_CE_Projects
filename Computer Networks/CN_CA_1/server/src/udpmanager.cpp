#include "../include/udpmanager.h"

UDPManager::UDPManager(int selectedPlayer, QObject *parent) : QObject(parent), udpSocket(new QUdpSocket(this)) {
    connect(udpSocket, &QUdpSocket::readyRead, this, &UDPManager::onReadyRead);
    quint16 port = (selectedPlayer == 1) ? 12345 : 12346;
    if (!udpSocket->bind(port))
        qWarning() << "Failed to bind UDP socket on port" << port;
    
}

void UDPManager::sendData(const QByteArray &data, int selectedPlayer) {
    QHostAddress address = QHostAddress("127.0.0.1");
    quint16 port = (selectedPlayer == 1) ? 12346 : 12345;
    udpSocket->writeDatagram(data, address, port);
}

void UDPManager::onReadyRead() {
    while (udpSocket->hasPendingDatagrams()) {
        QByteArray buffer;
        buffer.resize(udpSocket->pendingDatagramSize());
        QHostAddress sender;
        quint16 senderPort;

        udpSocket->readDatagram(buffer.data(), buffer.size(), &sender, &senderPort);
        emit dataReceived(buffer, sender, senderPort);
    }
}
