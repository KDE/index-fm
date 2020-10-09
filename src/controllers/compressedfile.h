#ifndef COMPRESSEDFILE_H
#define COMPRESSEDFILE_H

#include <QObject>

class CompressedFile : public QObject
{
    Q_OBJECT
public:
    explicit CompressedFile(QObject *parent = nullptr);

signals:

};

#endif // COMPRESSEDFILE_H
