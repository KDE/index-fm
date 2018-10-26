#include "index.h"
#include <QFileInfo>
#include <QDir>
#include <QDebug>

#if (defined (Q_OS_LINUX) && !defined (Q_OS_ANDROID))
#include "kde/notify.h"
#endif


Index::Index(QObject *parent) : QObject(parent)
{
}

/* to be called to launch index with opening different paths */
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
