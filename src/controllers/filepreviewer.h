#pragma once

#include <QObject>

class FilePreviewer : public QObject
{
    Q_OBJECT
public:
    explicit FilePreviewer(QObject *parent = nullptr);
};
