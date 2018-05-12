#ifndef INX_H
#define INX_H

#include <QString>
#include <QDebug>
#include <QStandardPaths>
#include <QFileInfo>
#include <QImage>
#include <QTime>
#include <QSettings>
#include <QDirIterator>
#include <QVariantList>
#include <QMimeType>
#include <QMimeData>
#include <QMimeDatabase>
#if defined(Q_OS_ANDROID)
#include "../mauikit/src/android/mauiandroid.h"
#endif

namespace INX
{
Q_NAMESPACE

inline bool isMobile()
{
#if defined(Q_OS_ANDROID)
    return true;
#elif defined(Q_OS_LINUX)
    return false;
#elif defined(Q_OS_WIN32)
    return false;
#elif defined(Q_OS_WIN64)
    return false;
#elif defined(Q_OS_MACOS)
    return false;
#elif defined(Q_OS_IOS)
    return true;
#elif defined(Q_OS_HAIKU)
    return false;
#endif
}

inline bool isAndroid()
{
#if defined(Q_OS_ANDROID)
    return true;
#elif defined(Q_OS_LINUX)
    return false;
#elif defined(Q_OS_WIN32)
    return false;
#elif defined(Q_OS_WIN64)
    return false;
#elif defined(Q_OS_MACOS)
    return false;
#elif defined(Q_OS_IOS)
    return false;
#elif defined(Q_OS_HAIKU)
    return false;
#endif
}

#if defined(Q_OS_ANDROID)
const QString PicturesPath = PATHS::PicturesPath;
const QString DownloadsPath = PATHS::DownloadsPath;
const QString DocumentsPath = PATHS::DocumentsPath;
const QString HomePath = PATHS::HomePath;
const QString MusicPath = PATHS::MusicPath;
const QString VideosPath = PATHS::VideosPath;

const QStringList defaultPaths =
{
    HomePath,
    DocumentsPath,
    PicturesPath,
    MusicPath,
    VideosPath,
    DownloadsPath
};

const QMap<QString, QString> folderIcon
{
    {PicturesPath, "folder-pictures"},
    {DownloadsPath, "folder-download"},
    {DocumentsPath, "folder-documents"},
    {HomePath, "user-home"},
    {MusicPath, "folder-music"},
    {VideosPath, "folder-videos"},
};


#else
const QString PicturesPath = QStandardPaths::writableLocation(QStandardPaths::PicturesLocation);
const QString DownloadsPath = QStandardPaths::writableLocation(QStandardPaths::DownloadLocation);
const QString DocumentsPath = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);
const QString HomePath =  QStandardPaths::writableLocation(QStandardPaths::HomeLocation);
const QString MusicPath = QStandardPaths::writableLocation(QStandardPaths::MusicLocation);
const QString VideosPath = QStandardPaths::writableLocation(QStandardPaths::MoviesLocation);
const QString DesktopPath = QStandardPaths::writableLocation(QStandardPaths::DesktopLocation);
const QString AppsPath = QStandardPaths::writableLocation(QStandardPaths::ApplicationsLocation);
const QString RootPath = "/";
const QStringList defaultPaths =
{
    HomePath,
    DesktopPath,
    DocumentsPath,
    PicturesPath,
    MusicPath,
    VideosPath,
    DownloadsPath
};

const QMap<QString, QString> folderIcon
{
    {PicturesPath, "folder-pictures"},
    {DownloadsPath, "folder-download"},
    {DocumentsPath, "folder-documents"},
    {HomePath, "user-home"},
    {MusicPath, "folder-music"},
    {VideosPath, "folder-videos"},
    {DesktopPath, "user-desktop"},
    {AppsPath, "system-run"},
    {RootPath, "folder-root"}
};

#endif

inline QString getIconName(const QString &path)
{
    if(QFileInfo(path).isDir())
    {
        if(folderIcon.contains(path))
            return folderIcon[path];
        else return "folder";

    }else
    {
        QMimeDatabase mime;
        auto type = mime.mimeTypeForFile(path);

        return isAndroid() ? type.genericIconName() : type.genericIconName();
    }

    return "unkown";
}

enum class MODEL_KEY : uint_fast8_t
{
    ICON,
    LABEL,
    PATH,
    TYPE,
    GROUP,
    OWNER,
    SUFFIX,
    NAME,
    DATE,
    MODIFIED,
    MIME,
    TAGS,
    PERMISSIONS
};

static const QMap<MODEL_KEY, QString> MODEL_NAME =
{
    {MODEL_KEY::ICON, "icon"},
    {MODEL_KEY::LABEL, "label"},
    {MODEL_KEY::PATH, "path"},
    {MODEL_KEY::TYPE, "type"},
    {MODEL_KEY::GROUP, "group"},
    {MODEL_KEY::OWNER, "owner"},
    {MODEL_KEY::SUFFIX, "suffix"},
    {MODEL_KEY::NAME, "name"},
    {MODEL_KEY::DATE, "date"},
    {MODEL_KEY::MODIFIED, "modified"},
    {MODEL_KEY::MIME, "mime"},
    {MODEL_KEY::TAGS, "tags"},
    {MODEL_KEY::PERMISSIONS, "permissions"}
};

enum class CUSTOMPATH : uint_fast8_t
{
    APPS,
    TAGS,
    TRASH
};

static const QMap<CUSTOMPATH, QString> CUSTOMPATH_PATH =
{
    {CUSTOMPATH::APPS, "#apps"},
    {CUSTOMPATH::TAGS, "#tags"},
    {CUSTOMPATH::TRASH, "#trash"}
};

static const QMap<CUSTOMPATH, QString> CUSTOMPATH_NAME =
{
    {CUSTOMPATH::APPS, "Apps"},
    {CUSTOMPATH::TAGS, "Tags"},
    {CUSTOMPATH::TRASH, "Trash"}
};

enum class PATHTYPE_KEY : uint_fast8_t
{
    PLACES,
    DRIVES,
    BOOKMARKS,
    TAGS
};

static const QMap<PATHTYPE_KEY, QString> PATHTYPE_NAME =
{
    {PATHTYPE_KEY::PLACES, "Places"},
    {PATHTYPE_KEY::DRIVES, "Drives"},
    {PATHTYPE_KEY::BOOKMARKS, "Bookmarks"},
    {PATHTYPE_KEY::TAGS, "Tags"}
};

const QString SettingPath = QStandardPaths::writableLocation(QStandardPaths::ConfigLocation)+"/pix/";
const QString CachePath = QStandardPaths::writableLocation(QStandardPaths::GenericCacheLocation)+"/pix/";
const QString NotifyDir = QStandardPaths::writableLocation(QStandardPaths::ConfigLocation);
const QString app = "Index";
const QString version = "0.1.0";
const QString description = "File manager";

inline bool fileExists(const QString &url)
{
    QFileInfo path(url);
    if (path.exists()) return true;
    else return false;
}

inline void saveSettings(const QString &key, const QVariant &value, const QString &group)
{
    QSettings setting("Babe","babe");
    setting.beginGroup(group);
    setting.setValue(key,value);
    setting.endGroup();
}

inline QVariant loadSettings(const QString &key, const QString &group, const QVariant &defaultValue)
{
    QVariant variant;
    QSettings setting("Babe","babe");
    setting.beginGroup(group);
    variant = setting.value(key,defaultValue);
    setting.endGroup();

    return variant;
}
}

#endif // INX_H
