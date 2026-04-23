#include <QCoreApplication>
#include <QCommandLineParser>
#include <QDebug>
#include "chunkserver.h"

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);
    QCoreApplication::setApplicationName("ChunkServer");

    QCommandLineParser parser;
    parser.setApplicationDescription("Chunk server for distributed file system");

    QCommandLineOption idOption(
        QStringList() << "i" << "id",
        "Set node ID (integer).", "id"
    );
    QCommandLineOption storageOption(
        QStringList() << "d" << "storage-dir",
        "Base directory to store chunks.", "dir"
    );

    parser.addOption(idOption);
    parser.addOption(storageOption);
    parser.process(a);

    if (!parser.isSet(idOption)) {
        qCritical() << "Node ID argument is required.";
        return 1;
    }

    bool ok;
    int nodeId = parser.value(idOption).toInt(&ok);
    if (!ok || nodeId < 0) {
        qCritical() << "Invalid node ID.";
        return 1;
    }

    QString baseDir = parser.value(storageOption);
    ChunkServer server(nodeId, baseDir);

    if (!server.start())
        return 1;

    return a.exec();
}