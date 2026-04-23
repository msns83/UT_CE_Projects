#ifndef CLIENTMANAGER_H
#define CLIENTMANAGER_H

#include <QObject>
#include <QTcpServer>
#include <QTcpSocket>
#include <QKeyEvent>
class ClientManager : public QObject
{
    Q_OBJECT
public:
    explicit ClientManager(QObject *parent = nullptr);

signals:
    void serverEventReceived(QKeyEvent *_event);
public slots:
    void handleClientEvent(QKeyEvent *event);
    void receiveFromServer();
private:
    QTcpSocket *_socket;
private:
    void setupClient();


};

#endif // CLIENTMANAGER_H
