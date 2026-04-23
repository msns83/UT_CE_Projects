#ifndef UDPRESTORER_H
#define UDPRESTORER_H

#include <QObject>
#include <QUdpSocket>
#include <QByteArray>
#include <QString>
#include <QMap>

class UdpRestorer : public QObject {
    Q_OBJECT
public:
    explicit UdpRestorer(QObject *parent = nullptr);
    void startRestore(const QString &fileName,
                      const QString &ip,
                      quint16 port);

signals:
    void restoreFinished(const QByteArray &fileData);
    void restoreError(const QString &error);

private slots:
    void onReadyRead();

private:
    QUdpSocket udpSocket;
    QMap<int,QByteArray> chunkMap;
    QString targetFileName;
    QString serverIp;
    quint16 currentPort = 0;
    int currentChunkIndex = 1;
    int lastChunkIndex = 0;

    void requestChunk();
};

#endif