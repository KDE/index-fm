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

namespace INX
{
Q_NAMESPACE


inline QString getNameFromLocation(const QString &str)
{
    QString ret;
    int index = 0;

    for(int i = str.size() - 1; i >= 0; i--)
        if(str[i] == '/')
        {
            index = i + 1;
            i = -1;
        }

    for(; index < str.size(); index++)
        ret.push_back(str[index]);

    return ret;
}

const QString PicturesPath = QStandardPaths::writableLocation(QStandardPaths::PicturesLocation);
const QString DownloadsPath = QStandardPaths::writableLocation(QStandardPaths::DownloadLocation);
const QString DocumentsPath = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);
const QString HomePath = QStandardPaths::writableLocation(QStandardPaths::HomeLocation);
const QString MusicPath = QStandardPaths::writableLocation(QStandardPaths::MusicLocation);
const QString VideosPath = QStandardPaths::writableLocation(QStandardPaths::MoviesLocation);
const QString DesktopPath = QStandardPaths::writableLocation(QStandardPaths::DesktopLocation);
const QStringList defaultPaths = {HomePath, DocumentsPath, MusicPath, VideosPath,PicturesPath, DownloadsPath, DesktopPath};


const QMap<QString, QString> folderIcon
{
    {PicturesPath, "folder-pictures"},
    {DownloadsPath, "folder-download"},
    {DocumentsPath, "folder-documents"},
    {HomePath, "user-home"},
    {MusicPath, "folder-music"},
    {VideosPath, "folder-videos"},
    {DesktopPath, "user-desktop"}

};


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
        qDebug()<< type.genericIconName();
        return type.iconName();
    }
    return "text-css";

}

const QString SettingPath = QStandardPaths::writableLocation(QStandardPaths::ConfigLocation)+"/pix/";
const QString CachePath = QStandardPaths::writableLocation(QStandardPaths::GenericCacheLocation)+"/pix/";
const QString NotifyDir = QStandardPaths::writableLocation(QStandardPaths::ConfigLocation);
const QString App = "Index";
const QString version = "1.0";




inline QString ucfirst(const QString &str)/*uppercase first letter*/
{
    if (str.isEmpty()) return "";

    QStringList tokens;
    QStringList result;
    QString output;

    if(str.contains(" "))
    {
        tokens = str.split(" ");

        for(auto str : tokens)
        {
            str = str.toLower();
            str[0] = str[0].toUpper();
            result<<str;
        }

        output = result.join(" ");
    }else output = str;

    return output.simplified();
}

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

}

#endif // INX_H
