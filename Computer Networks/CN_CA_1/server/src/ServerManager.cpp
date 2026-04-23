#include "../include/ServerManager.h"
#include <QTcpSocket>
#include <QKeyEvent>

ServerManager::ServerManager(ushort port,QObject *parent)
    : QObject{parent}
{
    setupServer(port);
}
void ServerManager::setupServer(ushort port){
    _server = new QTcpServer(this);
    _server->listen(QHostAddress::Any,port);


    connect(_server,&QTcpServer::newConnection,this,&ServerManager::clientJoined);

}
void ServerManager::handleServerEvent(QKeyEvent *event){
    if (event->isAutoRepeat()) return;
    QByteArray data;
    QDataStream stream(&data, QIODevice::WriteOnly);
    stream << event->type();
    stream << event->key();
    stream << event->modifiers();
    stream << event->text();
    _socket->write(data);

}
void ServerManager::clientJoined(){
    auto client = _server->nextPendingConnection();
    _socket = client;
    connect(_socket,&QTcpSocket::readyRead,this,&ServerManager::receiveFromClient);
}
void ServerManager::receiveFromClient(){
    QByteArray data = _socket->readAll();
    QDataStream stream(&data, QIODevice::ReadOnly);
    QEvent::Type type;
    int key;
    Qt::KeyboardModifiers modifiers;
    QString text;
    stream >> type;
    stream >> key;
    stream >> modifiers;
    stream >> text;
    QKeyEvent *_event = new QKeyEvent(type, key, modifiers, text);
    emit clientEventReceived(_event);
}
