#ifndef INX_H
#define INX_H

#include <QString>
#include <QDebug>
#include <QStandardPaths>

namespace INX
{
Q_NAMESPACE

const QString NotifyDir = QStandardPaths::writableLocation(QStandardPaths::ConfigLocation);
const QString appName = QStringLiteral("Index");
const QString displayName = QStringLiteral("Index");
const QString version = QStringLiteral("1.0.0");
const QString description = QStringLiteral("File manager");
const QString orgName = QStringLiteral("Maui");
const QString orgDomain = QStringLiteral("org.maui.index");
}

#endif // INX_H
