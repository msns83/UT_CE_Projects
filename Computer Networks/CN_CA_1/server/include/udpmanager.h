#ifndef UDPMANAGER_H
#define UDPMANAGER_H

#include <QObject>
#include <QUdpSocket>

class UDPManager : public QObject
{
    Q_OBJECT

public:
    explicit UDPManager(int selectedPlayer, QObject *parent = nullptr);

signals:
    void dataReceived(const QByteArray &data, const QHostAddress &sender, quint16 senderPort);

private slots:
    void onReadyRead();

public slots:
    void sendData(const QByteArray &data, int selectedPlayer);

private:
    QUdpSocket *udpSocket;
};

#endif