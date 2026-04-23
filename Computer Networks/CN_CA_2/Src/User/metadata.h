#ifndef METADATA_H
#define METADATA_H

#include <QString>

class Metadata {
public:
    QString fileName;
    QString fileSize;
    QString fileType;

    QString toString() const {
        return QString("%1|%2|%3").arg(fileName).arg(fileSize).arg(fileType);
    }

    QString toDisplay() const {
        return QString("File Name: %1\nFile Size: %2 bytes\nFile Type: %3").arg(fileName).arg(fileSize).arg(fileType);
    }
};

#endif
