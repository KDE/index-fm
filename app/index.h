#ifndef INDEX_H
#define INDEX_H

#include <QObject>
#include <QVariantList>
#include <QStringList>
#include <QFileSystemWatcher>
#include "fm.h"

class Index : public FM
{
    Q_OBJECT
public:
    explicit Index(QObject *parent = nullptr);

    Q_INVOKABLE static QVariantList getCustomPathContent(const QString &path);
    Q_INVOKABLE static bool isCustom(const QString &path);
    Q_INVOKABLE static bool isApp(const QString &path);
    Q_INVOKABLE static bool openFile(const QString &path);
    Q_INVOKABLE static QVariantList getCustomPaths();
    Q_INVOKABLE static void saveSettings(const QString &key, const QVariant &value, const QString &group);
    Q_INVOKABLE static QVariant loadSettings(const QString &key, const QString &group, const QVariant &defaultValue);
    Q_INVOKABLE static QVariantMap getDirInfo(const QString &path, const QString &type);
    Q_INVOKABLE static QVariantMap getFileInfo(const QString &path);

       /*KDE*/
    Q_INVOKABLE static void runApplication(const QString &exec, const QString &url);
signals:

public slots:
};

#endif // INDEX_H
