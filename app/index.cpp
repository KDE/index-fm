#include "index.h"
#include <QFileInfo>
#include <QMimeType>
#include <QDirIterator>
#include <QDesktopServices>
#include <QUrl>
#include <QStorageInfo>
#include <QDebug>
#include "inx.h"

#if (defined (Q_OS_LINUX) && !defined (Q_OS_ANDROID))
#include "../kde/notify.h"
#include "../kde/kde.h"
#endif


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
    if(!watcher->directories().isEmpty())
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
            auto item = QVariantMap {
            {INX::MODEL_NAME[INX::MODEL_KEY::ICON], INX::getIconName(url)},
            {INX::MODEL_NAME[INX::MODEL_KEY::LABEL], file.isDir() ? file.baseName() :
                                                                    file.fileName()},
                {INX::MODEL_NAME[INX::MODEL_KEY::PATH], url}
            };

            content << item;
            emit this->itemReady(item);
        }
    }
    return content;
}

QVariantList Index::getCustomPathContent(const QString &path)
{
    QVariantList res;
#if (defined (Q_OS_LINUX) && !defined (Q_OS_ANDROID))
    if(path.startsWith(INX::CUSTOMPATH_PATH[INX::CUSTOMPATH::APPS]+"/"))
        return KDE::getApps(QString(path).replace(INX::CUSTOMPATH_PATH[INX::CUSTOMPATH::APPS]+"/",""));
    else
        return KDE::getApps();

#endif
    return res;
}

QVariantList Index::getDefaultPaths()
{
    return packItems(INX::defaultPaths, INX::PATHTYPE_NAME[INX::PATHTYPE_KEY::PLACES]);
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
                {INX::MODEL_NAME[INX::MODEL_KEY::ICON], "drive-harddisk"},
                {INX::MODEL_NAME[INX::MODEL_KEY::LABEL], device.displayName()},
                {INX::MODEL_NAME[INX::MODEL_KEY::PATH], device.rootPath()},
                {INX::MODEL_NAME[INX::MODEL_KEY::TYPE], INX::PATHTYPE_NAME[INX::PATHTYPE_KEY::DRIVES]}
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

bool Index::isCustom(const QString &path)
{
    return path.startsWith("#");
}

bool Index::isApp(const QString &path)
{
    return /*QFileInfo(path).isExecutable() ||*/ path.endsWith(".desktop");
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
    return packItems(bookmarks, INX::PATHTYPE_NAME[INX::PATHTYPE_KEY::BOOKMARKS]);
}

QVariantList Index::getCustomPaths()
{
#ifdef Q_OS_ANDROID
    return QVariantList();
#endif
    return QVariantList
    {
        QVariantMap
        {
            {INX::MODEL_NAME[INX::MODEL_KEY::ICON], "system-run"},
            {INX::MODEL_NAME[INX::MODEL_KEY::LABEL], INX::CUSTOMPATH_NAME[INX::CUSTOMPATH::APPS]},
            {INX::MODEL_NAME[INX::MODEL_KEY::PATH], INX::CUSTOMPATH_PATH[INX::CUSTOMPATH::APPS]},
            {INX::MODEL_NAME[INX::MODEL_KEY::TYPE], INX::PATHTYPE_NAME[INX::PATHTYPE_KEY::PLACES]}
        }
    };
}

QVariantList Index::packItems(const QStringList &items, const QString &type)
{
    QVariantList data;

    for(auto path : items)
        if(INX::fileExists(path))
            data << getDirInfo(path, type);

    return data;
}

QVariantMap Index::getDirInfo(const QString &path, const QString &type)
{
    QFileInfo file (path);
    QVariantMap data =
    {
        {INX::MODEL_NAME[INX::MODEL_KEY::ICON], INX::getIconName(path)},
        {INX::MODEL_NAME[INX::MODEL_KEY::LABEL], file.baseName()},
        {INX::MODEL_NAME[INX::MODEL_KEY::PATH], path},
        {INX::MODEL_NAME[INX::MODEL_KEY::TYPE], type}
    };

    return data;
}

QVariantMap Index::getFileInfo(const QString &path)
{
    QFileInfo file(path);
    if(!file.exists()) return QVariantMap();
    QMimeDatabase mimedb;
    auto mime = mimedb.mimeTypeForFile(path);

    QVariantMap res =
    {
        {INX::MODEL_NAME[INX::MODEL_KEY::GROUP], file.group()},
        {INX::MODEL_NAME[INX::MODEL_KEY::OWNER], file.owner()},
        {INX::MODEL_NAME[INX::MODEL_KEY::SUFFIX], file.completeSuffix()},
        {INX::MODEL_NAME[INX::MODEL_KEY::LABEL], file.completeBaseName()},
        {INX::MODEL_NAME[INX::MODEL_KEY::NAME], file.fileName()},
        {INX::MODEL_NAME[INX::MODEL_KEY::DATE], file.birthTime().toString()},
        {INX::MODEL_NAME[INX::MODEL_KEY::MODIFIED], file.lastModified().toString()},
        {INX::MODEL_NAME[INX::MODEL_KEY::MIME], mime.name()},
        {INX::MODEL_NAME[INX::MODEL_KEY::ICON], INX::getIconName(path)}
    };

    return res;
}

bool Index::fileExists(const QString &path)
{
    return QFile(path).exists();
}

bool Index::copy(const QStringList &paths, const QString &where)
{
    for(auto path : paths)
    {
        if(QFileInfo(path).isDir())
        {
            QDir dir(path);
            auto state = copyPath(path, where+"/"+QFileInfo(path).fileName(), false);
            if(!state) return false;

        }else
        {
            QFile file(path);

            auto state = file.copy(where+"/"+QFileInfo(path).fileName());
            if(!state) return false;
        }
    }

    return true;
}

bool Index::copyPath(QString sourceDir, QString destinationDir, bool overWriteDirectory)
{
    QDir originDirectory(sourceDir);

    if (! originDirectory.exists())
    {
        return false;
    }

    QDir destinationDirectory(destinationDir);

    if(destinationDirectory.exists() && !overWriteDirectory)
    {
        return false;
    }
    else if(destinationDirectory.exists() && overWriteDirectory)
    {
        destinationDirectory.removeRecursively();
    }

    originDirectory.mkpath(destinationDir);

    foreach (QString directoryName, originDirectory.entryList(QDir::Dirs | \
                                                              QDir::NoDotAndDotDot))
    {
        QString destinationPath = destinationDir + "/" + directoryName;
        originDirectory.mkpath(destinationPath);
        copyPath(sourceDir + "/" + directoryName, destinationPath, overWriteDirectory);
    }

    foreach (QString fileName, originDirectory.entryList(QDir::Files))
    {
        QFile::copy(sourceDir + "/" + fileName, destinationDir + "/" + fileName);
    }

    /*! Possible race-condition mitigation? */
    QDir finalDestination(destinationDir);
    finalDestination.refresh();

    if(finalDestination.exists())
    {
        return true;
    }

    return false;
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
    if(QFileInfo(path).isDir())
        return removeDir(path);
    else return QFile(path).remove();
}

bool Index::removeDir(const QString &path)
{
    bool result = true;
    QDir dir(path);

    if (dir.exists(path))
    {
        Q_FOREACH(QFileInfo info, dir.entryInfoList(QDir::NoDotAndDotDot | QDir::System | QDir::Hidden  | QDir::AllDirs | QDir::Files, QDir::DirsFirst))
        {
            if (info.isDir())
            {
                result = removeDir(info.absoluteFilePath());
            }
            else
            {
                result = QFile::remove(info.absoluteFilePath());
            }

            if (!result)
            {
                return result;
            }
        }
        result = dir.rmdir(path);
    }

    return result;
}

bool Index::rename(const QString &path, const QString &name)
{

}

bool Index::createDir(const QString &path, const QString &name)
{
    return QDir(path).mkdir(name);
}

bool Index::createFile(const QString &path, const QString &name)
{
    QFile file(path + "/" + name);

    if(file.open(QIODevice::ReadWrite))
    {
        file.close();
        return true;
    }

    return false;
}

void Index::runApplication(const QString &exec, const QString &url)
{
#if (defined (Q_OS_LINUX) && !defined (Q_OS_ANDROID))
    return  KDE::launchApp(exec);
#endif
}

void Index::saveSettings(const QString &key, const QVariant &value, const QString &group)
{
    INX::saveSettings(key, value, group);

}

QVariant Index::loadSettings(const QString &key, const QString &group, const QVariant &defaultValue)
{
    return INX::loadSettings(key, group, defaultValue);
}

