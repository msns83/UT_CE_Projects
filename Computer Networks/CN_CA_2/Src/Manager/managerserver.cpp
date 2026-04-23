#include "managerserver.h"
#include <QTcpSocket>
#include <QDebug>


ManagerServer::ManagerServer(QObject *parent): QTcpServer(parent), chunkManager(15,8000) {}

bool ManagerServer::startListening(quint16 port) {
    if (!listen(QHostAddress::Any, port)) {
        qWarning() << "Cannot listen on port" << port;
        return false;
    }
    qDebug() << "Manager Listens on port" << port;
    return true;
}

void ManagerServer::incomingConnection(qintptr socketDescriptor) {
    QTcpSocket *socket = new QTcpSocket(this);
    socket->setSocketDescriptor(socketDescriptor);

    connect(socket, &QTcpSocket::readyRead, [this, socket]() {

        QString data = QString::fromUtf8(socket->readAll());
        emit metadataReceived(data);

        QStringList parts = data.split('|');
        if (parts.isEmpty()) {
            socket->write("Invalid request");
            socket->flush();
            socket->close();
            return;
        }

        QString command = parts[0].toUpper();

        if (command == "UPLOAD") {
            if (parts.size() < 4) {
                socket->write("Invalid UPLOAD format");
                socket->flush();
                socket->close();
                return;
            }

            QString fileName = parts[1];
            int fileSize = parts[2].toInt();

            int startChunk = chunkManager.getNextChunkInDFS(lastUsedChunkId);
            auto allocatedChunks = chunkManager.allocateChunks(fileSize, startChunk);

            if (allocatedChunks.empty()) {
                socket->write("No allocation available");
                socket->flush();
                socket->close();
                return;
            }

            lastUsedChunkId = allocatedChunks.back();

            fileLastChunkMap[fileName] = allocatedChunks.front();

            int firstChunkId = allocatedChunks.front();
            int port = basePort + firstChunkId;

            int chunkSize = 8000;
            int remainingSize = fileSize;
            QStringList chunkSizes;
            for (int i = 0; i < (int)allocatedChunks.size(); ++i) {
                int sizeToSend = (remainingSize > chunkSize) ? chunkSize : remainingSize;
                chunkSizes << QString::number(sizeToSend);
                remainingSize -= sizeToSend;
            }

            QString sizesJoined = chunkSizes.join(",");

            QString response = QString("%1|%2|%3").arg(chunkServerIp).arg(port).arg(sizesJoined);

            socket->write(response.toUtf8());
            socket->flush();
            socket->close();

        } else if (command == "RESTORE") {
            if (parts.size() < 2) {
                socket->write("Invalid RESTORE format");
                socket->flush();
                socket->close();
                return;
            }

            QString fileName = parts[1];

            if (!fileLastChunkMap.contains(fileName)) {
                socket->write("File not found");
                socket->flush();
                socket->close();
                return;
            }

            int lastChunkId = fileLastChunkMap[fileName];
            int port = basePort + lastChunkId;

            QString response = QString("%1|%2").arg(chunkServerIp).arg(port);

            socket->write(response.toUtf8());
            socket->flush();
            socket->close();

        } else {
            socket->write("Unknown command");
            socket->flush();
            socket->close();
        }
    });

    connect(socket, &QTcpSocket::disconnected, socket, &QTcpSocket::deleteLater);
}

