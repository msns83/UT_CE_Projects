#ifndef MANAGERSERVER_H
#define MANAGERSERVER_H

#include <QTcpServer>
#include <QMap>
#include "chunkmanager.h"

class ManagerServer : public QTcpServer {
    Q_OBJECT

public:
    explicit ManagerServer(QObject *parent = nullptr);
    bool startListening(quint16 port = 2000);

protected:
    void incomingConnection(qintptr socketDescriptor) override;

signals:
    void metadataReceived(const QString &data);
    void allocationSent(const QString &data);

private:
    ChunkManager chunkManager;

    QMap<QString, int> fileLastChunkMap; 
    int lastUsedChunkId = 14;              
    QString chunkServerIp = "172.30.49.243";
    int basePort = 3000;
};

#endif
