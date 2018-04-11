#ifndef INDEX_H
#define INDEX_H

#include <QObject>
#include <QVariantList>
#include <QStringList>
#include <QFileSystemWatcher>


class Index : public QObject
{
    Q_OBJECT
public:
    explicit Index(QObject *parent = nullptr);
    Q_INVOKABLE void watchPath(const QString &path);
    Q_INVOKABLE static QVariantList getPathContent(const QString &path);
    Q_INVOKABLE static QVariantList getDefaultPaths();
    Q_INVOKABLE static bool isDefaultPath(const QString &path);
    Q_INVOKABLE static QVariantList getDevices();
    Q_INVOKABLE static QString homePath();
    Q_INVOKABLE static QString parentDir(const QString &path);
    Q_INVOKABLE static bool isDir(const QString &path);
    Q_INVOKABLE static bool openFile(const QString &path);
    Q_INVOKABLE static bool bookmark(const QString &path);
    Q_INVOKABLE static QVariantList getBookmarks();
    Q_INVOKABLE static QVariantList packItems(const QStringList &items, const QString &type);
    Q_INVOKABLE static void saveSettings(const QString &key, const QVariant &value, const QString &group);
    Q_INVOKABLE static QVariant loadSettings(const QString &key, const QString &group, const QVariant &defaultValue);
    Q_INVOKABLE static QVariantMap getDirInfo(const QString &path, const QString &type);

private:
    QFileSystemWatcher *watcher;

signals:
    void pathModified(QString path);

public slots:
};

#endif // INDEX_H
