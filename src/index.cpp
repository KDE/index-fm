// Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2018-2020 Nitrux Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later

#include "index.h"

#if (defined Q_OS_LINUX || defined Q_OS_FREEBSD) && !defined Q_OS_ANDROID
#include <KTerminalLauncherJob>
#endif

#include <QGuiApplication>
#include <QQuickWindow>
#include <QQmlApplicationEngine>

#include <QDebug>
#include <QFileInfo>

#include <QProcess>

#include <MauiKit4/Core/fmh.h>
#include <MauiKit4/FileBrowsing/fmstatic.h>

#if (defined Q_OS_LINUX || defined Q_OS_FREEBSD) && !defined Q_OS_ANDROID
#include "indexinterface.h"
#include "indexadaptor.h"

QVector<QPair<QSharedPointer<OrgKdeIndexActionsInterface>, QStringList>> IndexInstance::appInstances(const QString& preferredService)
{
    QVector<QPair<QSharedPointer<OrgKdeIndexActionsInterface>, QStringList>> dolphinInterfaces;

    if (!preferredService.isEmpty())
    {
        QSharedPointer<OrgKdeIndexActionsInterface> preferredInterface(
                    new OrgKdeIndexActionsInterface(preferredService,
                                                    QStringLiteral("/Actions"),
                                                    QDBusConnection::sessionBus()));

        qDebug() << "IS PREFRFRED INTERFACE VALID?" << preferredInterface->isValid() << preferredInterface->lastError().message();
        if (preferredInterface->isValid() && !preferredInterface->lastError().isValid()) {
            dolphinInterfaces.append(qMakePair(preferredInterface, QStringList()));
        }
    }

    // Look for dolphin instances among all available dbus services.
    QDBusConnectionInterface *sessionInterface = QDBusConnection::sessionBus().interface();
    const QStringList dbusServices = sessionInterface ? sessionInterface->registeredServiceNames().value() : QStringList();
    // Don't match the service without trailing "-" (unique instance)
    const QString pattern = QStringLiteral("org.kde.index-");

    // Don't match the pid without leading "-"
    const QString myPid = QLatin1Char('-') + QString::number(QCoreApplication::applicationPid());

    for (const QString& service : dbusServices)
    {
        if (service.startsWith(pattern) && !service.endsWith(myPid))
        {
            qDebug() << "EXISTING INTANCES" << service;

            // Check if instance can handle our URLs
            QSharedPointer<OrgKdeIndexActionsInterface> interface(
                        new OrgKdeIndexActionsInterface(service,
                                                        QStringLiteral("/Actions"),
                                                        QDBusConnection::sessionBus()));
            if (interface->isValid() && !interface->lastError().isValid())
            {
                dolphinInterfaces.append(qMakePair(interface, QStringList()));
            }
        }
    }

    return dolphinInterfaces;
}

bool IndexInstance::attachToExistingInstance(const QList<QUrl>& inputUrls, bool openFiles, bool splitView, const QString& preferredService)
{
    bool attached = false;

    if (inputUrls.isEmpty())
    {
        return false;
    }

    auto dolphinInterfaces = appInstances(preferredService);
    if (dolphinInterfaces.isEmpty())
    {
        return false;
    }

    QStringList newUrls;

    // check to see if any instances already have any of the given URLs open
    const auto urls = QUrl::toStringList(inputUrls);
    for (const QString& url : urls)
    {
        bool urlFound = false;

        for (auto& interface: dolphinInterfaces)
        {
            auto isUrlOpenReply = interface.first->isUrlOpen(url);
            isUrlOpenReply.waitForFinished();

            if (!isUrlOpenReply.isError() && isUrlOpenReply.value())
            {
                interface.second.append(url);
                urlFound = true;
                break;
            }
        }

        if (!urlFound)
        {
            newUrls.append(url);
        }
    }

    for (const auto& interface: std::as_const(dolphinInterfaces))
    {
        auto reply = openFiles ? interface.first->openFiles(newUrls, splitView) : interface.first->openDirectories(newUrls, splitView);
        reply.waitForFinished();

        if (!reply.isError())
        {
            interface.first->activateWindow();
            attached = true;
            break;
        }
    }

    return attached;
}


bool IndexInstance::registerService()
{
    QDBusConnectionInterface *iface = QDBusConnection::sessionBus().interface();

    auto registration = iface->registerService(QStringLiteral("org.kde.index-%1").arg(QCoreApplication::applicationPid()),
                                               QDBusConnectionInterface::ReplaceExistingService,
                                               QDBusConnectionInterface::DontAllowReplacement);

    if (!registration.isValid())
    {
        qWarning("2 Failed to register D-Bus service \"%s\" on session bus: \"%s\"",
                 qPrintable("org.kde.index"),
                 qPrintable(registration.error().message()));
        return false;
    }

    return true;
}

#endif

Index::Index(QObject *parent)
    : QObject(parent)
{
#if (defined Q_OS_LINUX || defined Q_OS_FREEBSD) && !defined Q_OS_ANDROID
    new ActionsAdaptor(this);
    if(!QDBusConnection::sessionBus().registerObject(QStringLiteral("/Actions"), this))
    {
        qDebug() << "FAILED TO REGISTER BACKGROUND DBUS OBJECT";
        return;
    }
#endif
}

void Index::openDirectories(const QStringList &dirs, bool)
{
    openPaths(dirs);
}

void Index::openFiles(const QStringList &files, bool)
{
    openPaths(files);
}

void Index::activateWindow()
{
    if(m_qmlObject)
    {
        auto window = qobject_cast<QQuickWindow *>(m_qmlObject);
        if (window)
        {
            qDebug() << "Trying to raise wndow";
            window->raise();
            window->requestActivate();
        }
    }
}

bool Index::isUrlOpen(const QString &url)
{
    bool value = false;

    QMetaObject::invokeMethod(m_qmlObject, "isUrlOpen",
                              Q_RETURN_ARG(bool, value),
                              Q_ARG(QString, url));

    return value;
}

void Index::pasteIntoFolder()
{

}

void Index::changeUrl(const QUrl &)
{

}

void Index::slotTerminalDirectoryChanged(const QUrl &)
{

}

void Index::quit()
{
    QCoreApplication::quit();
}

void Index::openNewTab(const QUrl &)
{

}

void Index::openNewTabAndActivate(const QUrl &)
{

}

void Index::openNewWindow(const QUrl &url)
{
    QProcess process;
    process.setProgram("index");
    process.setArguments({"-n", url.toString()});
    process.startDetached();
}

/* to be called to launch index with opening different paths */
void Index::openPaths(const QStringList &paths)
{
    QStringList urls = std::accumulate(paths.constBegin(), paths.constEnd(), QStringList(), [](QStringList &list, const QString &path) -> QStringList {
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
});

    if(m_qmlObject)
        QMetaObject::invokeMethod(m_qmlObject, "openDirs",
                                  Q_ARG(QVariant, urls));
}

void Index::setQmlObject(QObject *object)
{
    m_qmlObject = object;
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

QVariantList Index::quickPaths()
{
    FMH::MODEL_LIST paths;

    paths << FMH::MODEL {{FMH::MODEL_KEY::PATH, "overview:///"}, {FMH::MODEL_KEY::ICON, "folder-recent"}, {FMH::MODEL_KEY::LABEL, "Overview"}, {FMH::MODEL_KEY::TYPE, "Quick"}};

    paths << FMH::MODEL {{FMH::MODEL_KEY::PATH, FMStatic::PATHTYPE_URI[FMStatic::PATHTYPE_KEY::TAGS_PATH] + "fav"}, {FMH::MODEL_KEY::ICON, "love"}, {FMH::MODEL_KEY::LABEL, "Favorite"}, {FMH::MODEL_KEY::TYPE, "Quick"}};

paths << FMH::MODEL {{FMH::MODEL_KEY::PATH, "tags:///"}, {FMH::MODEL_KEY::ICON, "tag"}, {FMH::MODEL_KEY::LABEL, "Tags"}, {FMH::MODEL_KEY::TYPE, "Quick"}};

paths << FMStatic::getDefaultPaths();


return FMH::toMapList(paths);
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
