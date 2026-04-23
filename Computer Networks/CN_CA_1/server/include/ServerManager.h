#ifndef SERVERMANAGER_H
#define SERVERMANAGER_H

#include <QObject>
#include <QTcpServer>
#include <QKeyEvent>
class ServerManager : public QObject
{
    Q_OBJECT
public:
    explicit ServerManager(ushort port = 4500 ,QObject *parent = nullptr);

signals:
    void clientEventReceived(QKeyEvent *_event);
private:
    void setupServer(ushort port);

private:
    QTcpServer *_server;
    QTcpSocket *_socket;

private slots:
    void clientJoined();
    
public slots:
    void handleServerEvent(QKeyEvent *event);
    void receiveFromClient();

};

#endif // SERVERMANAGER_H
