#ifndef INX_H
#define INX_H

#include <QString>
#include <QDebug>
#include <QStandardPaths>

namespace INX
{
Q_NAMESPACE

const QString NotifyDir = QStandardPaths::writableLocation(QStandardPaths::ConfigLocation);
const QString app = "Index";
const QString version = "1.0.0";
const QString description = "File manager";
}

#endif // INX_H
