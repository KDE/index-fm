#include "index.h"
#include <QFileInfo>
#include <QMimeType>
#include <QDirIterator>
#include <QDesktopServices>
#include <QUrl>
#include <QDebug>
#include "inx.h"

#if (defined (Q_OS_LINUX) && !defined (Q_OS_ANDROID))
#include "kde/notify.h"
#include "kde/kde.h"
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

void Index::runApplication(const QString &exec, const QString &url)
{
#if (defined (Q_OS_LINUX) && !defined (Q_OS_ANDROID))
    return  KDE::launchApp(exec);
#endif
}
