#include "index.h"
#include <QFileInfo>
#include <QDir>
#include <QDebug>

Index::Index(QObject *parent) : QObject(parent) {}

/* to be called to launch index with opening different paths */
void Index::openPaths(const QStringList &paths)
{
    emit this->openPath(std::accumulate(paths.constBegin(), paths.constEnd(), QStringList(), [](QStringList &list, const QString &path) -> QStringList
    {
        const QFileInfo file(path);
        if(file.isDir())
            list << path;
        else
            list << file.dir().absolutePath();

        return list;
    }));
}
