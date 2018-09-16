#include "index.h"
#include <QFileInfo>
#include <QMimeType>
#include <QDirIterator>
#include <QDesktopServices>
#include <QUrl>
#include <QDebug>
#include "inx.h"

#if (defined (Q_OS_LINUX) && !defined (Q_OS_ANDROID))
#include "../kde/notify.h"
#include "../kde/kde.h"
#endif


Index::Index(QObject *parent) : FM(parent)
{

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

void Index::openPaths(const QStringList &paths)
{
    QStringList urls;
    for(auto path : paths)
    {
        QFileInfo file(path);
        if(file.isDir())
            urls << path;
        else
            urls << file.dir().absolutePath();
    }

    emit this->openPath(urls);
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
    auto mime = FMH::getMime(path);

    QVariantMap res =
    {
        {INX::MODEL_NAME[INX::MODEL_KEY::GROUP], file.group()},
        {INX::MODEL_NAME[INX::MODEL_KEY::OWNER], file.owner()},
        {INX::MODEL_NAME[INX::MODEL_KEY::SUFFIX], file.completeSuffix()},
        {INX::MODEL_NAME[INX::MODEL_KEY::LABEL], file.completeBaseName()},
        {INX::MODEL_NAME[INX::MODEL_KEY::NAME], file.fileName()},
        {INX::MODEL_NAME[INX::MODEL_KEY::DATE], file.birthTime().toString()},
        {INX::MODEL_NAME[INX::MODEL_KEY::MODIFIED], file.lastModified().toString()},
        {INX::MODEL_NAME[INX::MODEL_KEY::MIME], mime },
        {INX::MODEL_NAME[INX::MODEL_KEY::ICON], INX::getIconName(path)}
    };

    return res;
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

