#ifndef METADATASENDER_H
#define METADATASENDER_H

#include "metadata.h"
#include <QObject>
#include <QString>

class MetadataSender : public QObject {
    Q_OBJECT

public:
    explicit MetadataSender(QObject *parent = nullptr);
    QString sendUploadToManager(const Metadata &metadata, const QString &host = "127.0.0.1", quint16 port = 2000);
    QString sendRestoreToManager(const QString &fileName, const QString &host = "127.0.0.1", quint16 port = 2000);
};

#endif
