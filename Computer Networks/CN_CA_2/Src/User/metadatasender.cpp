#include "metadatasender.h"
#include <QTcpSocket>

MetadataSender::MetadataSender(QObject *parent): QObject(parent) {}

QString MetadataSender::sendUploadToManager(const Metadata &metadata, const QString &host, quint16 port) {
    QTcpSocket socket;
    socket.connectToHost(host, port);

    if (!socket.waitForConnected(1000))
        return QString();

    QString data = QString("UPLOAD|%1|%2|%3").arg(metadata.fileName).arg(metadata.fileSize).arg(metadata.fileType);

    socket.write(data.toUtf8());
    socket.flush();

    if (!socket.waitForReadyRead(3000)) {
        socket.disconnectFromHost();
        return QString();
    }

    QByteArray response = socket.readAll();
    socket.disconnectFromHost();

    return QString::fromUtf8(response);
}

QString MetadataSender::sendRestoreToManager(const QString &fileName, const QString &host, quint16 port) {
    QTcpSocket socket;
    socket.connectToHost(host, port);

    if (!socket.waitForConnected(1000)) {
        return QString();
    }

    QString data = QString("RESTORE|%1").arg(fileName);

    socket.write(data.toUtf8());
    socket.flush();

    if (!socket.waitForReadyRead(3000)) {
        socket.disconnectFromHost();
        return QString();
    }

    QByteArray response = socket.readAll();
    socket.disconnectFromHost();

    return QString::fromUtf8(response);
}
