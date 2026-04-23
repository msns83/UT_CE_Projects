#include "../include/ClientManager.h"
#include <QTcpSocket>
ClientManager::ClientManager(QObject *parent)
    : QObject{parent}
{
    setupClient();
}
void ClientManager::setupClient(){
    _socket = new QTcpSocket(this);
    _socket->connectToHost(QHostAddress::LocalHost,4500);
    connect(_socket,&QTcpSocket::readyRead,this,&ClientManager::receiveFromServer);
}
void ClientManager::handleClientEvent(QKeyEvent *event){
    if (event->isAutoRepeat()) return;
    QByteArray data;
    QDataStream stream(&data, QIODevice::WriteOnly);
    stream << event->type();
    stream << event->key();
    stream << event->modifiers();
    stream << event->text();
    _socket->write(data);

}
void ClientManager::receiveFromServer(){
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
    emit serverEventReceived(_event);
}
