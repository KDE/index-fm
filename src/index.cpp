#include "index.h"
#include <QFileInfo>
#include <QDir>
#include <QDebug>
#include <QUrl>

Index::Index(QObject *parent) : QObject(parent) {}

/* to be called to launch index with opening different paths */
void Index::openPaths(const QStringList &paths)
{
    emit this->openPath(std::accumulate(paths.constBegin(), paths.constEnd(), QStringList(), [](QStringList &list, const QString &path) -> QStringList
    {
                            const auto url = QUrl::fromUserInput(path);
                            if(url.isLocalFile())
                            {
                                const QFileInfo file(url.toLocalFile());
                                if(file.isDir())
                                list << url.toString();
                                else
                                list << QUrl::fromLocalFile(file.dir().absolutePath()).toString();
                            }else
                            list << url.toString();

                            return list;
                        }));
}
