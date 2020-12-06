#ifndef FILEPREVIEWER_H
#define FILEPREVIEWER_H

#include <QObject>

class FilePreviewer : public QObject
{
    Q_OBJECT
public:
    explicit FilePreviewer(QObject *parent = nullptr);

signals:

};

#endif // FILEPREVIEWER_H
