#ifndef INX_H
#define INX_H

#include <QString>
#include <QDebug>
#include <QStandardPaths>

#ifndef STATIC_MAUIKIT
#include "../index_version.h"
#endif

namespace INX
{
Q_NAMESPACE

const static inline QString NotifyDir = QStandardPaths::writableLocation(QStandardPaths::ConfigLocation);
const static inline QString appName = QStringLiteral("Index");
const static inline QString displayName = QStringLiteral("Index");
const static inline QString version = QStringLiteral(INDEX_VERSION_STRING);
const static inline QString description = QStringLiteral("File manager");
const static inline QString orgName = QStringLiteral("Maui");
const static inline QString orgDomain = QStringLiteral("org.maui.index");
}

#endif // INX_H
