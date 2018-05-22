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

    Q_INVOKABLE static bool isAndroid();

    Q_INVOKABLE void watchPath(const QString &path);
    Q_INVOKABLE QVariantList getPathContent(const QString &path);
    Q_INVOKABLE static QVariantList getCustomPathContent(const QString &path);
    Q_INVOKABLE static QVariantList getDefaultPaths();
    Q_INVOKABLE static bool isDefaultPath(const QString &path);
    Q_INVOKABLE static QVariantList getDevices();
    Q_INVOKABLE static QString homePath();
    Q_INVOKABLE static QString parentDir(const QString &path);
    Q_INVOKABLE static bool isDir(const QString &path);
    Q_INVOKABLE static bool isCustom(const QString &path);
    Q_INVOKABLE static bool isApp(const QString &path);
    Q_INVOKABLE static bool openFile(const QString &path);
    Q_INVOKABLE static bool bookmark(const QString &path);
    Q_INVOKABLE static QVariantList getBookmarks();
    Q_INVOKABLE static QVariantList getCustomPaths();
    Q_INVOKABLE static QVariantList packItems(const QStringList &items, const QString &type);
    Q_INVOKABLE static void saveSettings(const QString &key, const QVariant &value, const QString &group);
    Q_INVOKABLE static QVariant loadSettings(const QString &key, const QString &group, const QVariant &defaultValue);
    Q_INVOKABLE static QVariantMap getDirInfo(const QString &path, const QString &type);
    Q_INVOKABLE static QVariantMap getFileInfo(const QString &path);
    Q_INVOKABLE static bool fileExists(const QString &path);

    /*FILE ACTIONS*/
    Q_INVOKABLE static bool copy(const QStringList &paths, const QString &where);
    static bool copyPath(QString sourceDir, QString destinationDir, bool overWriteDirectory);
    Q_INVOKABLE static bool cut(const QStringList &paths, const QString &where);
    Q_INVOKABLE static bool remove(const QString &path);
    static bool removeDir(const QString &path);
    Q_INVOKABLE static bool rename(const QString &path, const QString &name);
    Q_INVOKABLE static bool createDir(const QString &path, const QString &name);
    Q_INVOKABLE static bool createFile(const QString &path, const QString &name);

    /*KDE*/
    Q_INVOKABLE static void runApplication(const QString &exec, const QString &url);


private:
    QFileSystemWatcher *watcher;

signals:
    void pathModified(QString path);
    void itemReady(QVariantMap item);

public slots:
};

#endif // INDEX_H
