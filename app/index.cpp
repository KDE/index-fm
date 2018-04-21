#include "index.h"
#include <QFileInfo>
#include <QMimeType>
#include <QDirIterator>
#include <QDesktopServices>
#include <QUrl>
#include <QStorageInfo>

#include "inx.h"

Index::Index(QObject *parent) : QObject(parent)
{
    watcher = new QFileSystemWatcher(this);
    connect(watcher, &QFileSystemWatcher::directoryChanged, [this](const QString &path)
    {
        qDebug()<< " path modified"+path;
        emit pathModified(path);

    });
}

bool Index::isAndroid()
{
    return INX::isAndroid();
}

void Index::watchPath(const QString &path)
{
    watcher->removePaths(watcher->directories());
    watcher->addPath(path);
}

QVariantList Index::getPathContent(const QString &path)
{
    QVariantList content;
    if (QFileInfo(path).isDir())
    {
        QDirIterator it(path, QDir::Files | QDir::AllDirs | QDir::NoDotDot | QDir::NoDot, QDirIterator::NoIteratorFlags);
        while (it.hasNext())
        {
            auto url = it.next();
            QFileInfo file(url);
            QVariantMap item =
            {
                {"iconName", INX::getIconName(url)},
                {"label", file.isDir() ? file.baseName() : file.baseName() + "."+file.suffix()},
                {"path", url}
            };
            content << item;
        }

    }
    return content;
}

QVariantList Index::getDefaultPaths()
{
    return packItems(INX::defaultPaths, "Places");
}

bool Index::isDefaultPath(const QString &path)
{
    return INX::defaultPaths.contains(path);
}

QVariantList Index::getDevices()
{
    QVariantList drives;

    auto devices = QStorageInfo::mountedVolumes();
    for(auto device : devices)
    {
        if(device.isValid() && !device.isReadOnly())
        {
            QVariantMap drive =
            {
                {"iconName", "drive-harddisk"},
                {"label", device.displayName()},
                {"path", device.rootPath()},
                {"type", "Drives"}
            };

            drives << drive;
        }
    }

    //    for(auto device : QDir::drives())
    //    {
    //        QVariantMap drive =
    //        {
    //            {"iconName", "drive-harddisk"},
    //            {"label", device.baseName()},
    //            {"path", device.absoluteFilePath()},
    //            {"type", "Drives"}
    //        };

    //        drives << drive;
    //    }

    return drives;
}

QString Index::homePath()
{
    return INX::HomePath;
}

QString Index::parentDir(const QString &path)
{
    auto dir = QDir(path);
    dir.cdUp();
    return dir.absolutePath();

}

bool Index::isDir(const QString &path)
{
    return QFileInfo(path).isDir();
}

bool Index::openFile(const QString &path)
{
    return QDesktopServices::openUrl(QUrl::fromLocalFile(path));
}

bool Index::bookmark(const QString &path)
{
    auto bookmarks = INX::loadSettings("BOOKMARKS", "INX", QStringList()).toStringList();
    bookmarks.append(path);
    INX::saveSettings("BOOKMARKS", bookmarks, "INX");

    return true;
}

QVariantList Index::getBookmarks()
{
    auto bookmarks = INX::loadSettings("BOOKMARKS", "INX", QStringList()).toStringList();
    return packItems(bookmarks, "Bookmarks");
}

QVariantList Index::packItems(const QStringList &items, const QString &type)
{
    QVariantList data;

    for(auto path : items)
        data << getDirInfo(path, type);


    return data;
}

QVariantMap Index::getDirInfo(const QString &path, const QString &type)
{
    QFileInfo file (path);
    QVariantMap data =
    {
        {"iconName", INX::getIconName(path)},
        {"label", file.baseName()},
        {"path", path},
        {"type", type}
    };

    return data;
}

bool Index::copy(const QStringList &paths, const QString &where)
{
    for(auto path : paths)
    {
        QFile file(path);
        auto state = file.copy(where+"/"+QFileInfo(path).fileName());
        if(!state) return false;
    }

    return true;
}

bool Index::cut(const QStringList &paths, const QString &where)
{
    for(auto path : paths)
    {
        QFile file(path);
        auto state = file.rename(where+"/"+QFileInfo(path).fileName());
        if(!state) return false;
    }

    return true;
}

bool Index::remove(const QString &path)
{

}

bool Index::rename(const QString &path, const QString &name)
{

}

void Index::saveSettings(const QString &key, const QVariant &value, const QString &group)
{
    INX::saveSettings(key, value, group);

}

QVariant Index::loadSettings(const QString &key, const QString &group, const QVariant &defaultValue)
{
    return INX::loadSettings(key, group, defaultValue);
}

