// Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2018-2020 Nitrux Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later

#include "index.h"

#if (defined Q_OS_LINUX || defined Q_OS_FREEBSD) && !defined Q_OS_ANDROID
#include <KTerminalLauncherJob>
#endif

#include <QDebug>
#include <QFileInfo>

#include <MauiKit/Core/fmh.h>
#include <MauiKit/FileBrowsing/fmstatic.h>

Index::Index(QObject *parent)
    : QObject(parent)
{
}

/* to be called to launch index with opening different paths */
void Index::openPaths(const QStringList &paths)
{
    emit this->openPath(std::accumulate(paths.constBegin(), paths.constEnd(), QStringList(), [](QStringList &list, const QString &path) -> QStringList {
                            const auto url = QUrl::fromUserInput(path);
                            if (url.isLocalFile())
                            {
                                if (FMStatic::isDir(url))
                                {
                                    list << url.toString();
                                }
                                else
                                {
                                    list <<  FMStatic::fileDir(url).toString();
                                }
                            }

                            return list;
                        }));
}

void Index::openTerminal(const QUrl &url)
{
#if (defined Q_OS_LINUX || defined Q_OS_FREEBSD) && !defined Q_OS_ANDROID

    auto job = new KTerminalLauncherJob(QString());
    job->setWorkingDirectory(url.toLocalFile());
    job->start();

#else
    Q_UNUSED(url)
#endif
}

QUrl Index::cameraPath()
{
    const static auto paths = QStringList{FMStatic::HomePath + "/DCIM/Camera", FMStatic::HomePath + "/Camera"};

    for (const auto &path : paths) {
        if (FMH::fileExists(path))
            return QUrl(path);
    }

    return QUrl();
}

QUrl Index::screenshotsPath()
{
    const static auto paths = QStringList{FMStatic::HomePath + "/DCIM/Screenshots", FMStatic::HomePath + "/Screenshots"};

    for (const auto &path : paths) {
        if (FMH::fileExists(path))
            return QUrl(path);
    }

    return QUrl();
}
