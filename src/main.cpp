// Copyright 2018-2023 Camilo Higuita <milo.h@aol.com>
// Copyright 2018-2023 Nitrux Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later
#include <QCommandLineParser>
#include <QIcon>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QUrl>

#ifdef Q_OS_ANDROID
#include <QGuiApplication>
#include <MauiKit4/Core/mauiandroid.h>
#else
#include <QApplication>
#endif

#ifdef Q_OS_MACOS
#include <MauiKit4/Core/mauimacos.h>
#endif

#include <MauiKit4/Core/mauiapp.h>
#include <MauiKit4/FileBrowsing/moduleinfo.h>

#include <kio_version.h>
#include <KAboutData>
#include <KLocalizedString>

#include "../index_version.h"

#include "controllers/compressedfile.h"
#include "controllers/filepreviewer.h"
#include "controllers/dirinfo.h"
#include "controllers/folderconfig.h"
#include "controllers/fileproperties.h"
#include "controllers/patharrowbackground.h"

#include "index.h"

#include "models/recentfilesmodel.h"
#include "models/pathlist.h"

#define INDEX_URI "org.maui.index"

Q_DECL_EXPORT int main(int argc, char *argv[])
{

#ifdef Q_OS_WIN32
    qputenv("QT_MULTIMEDIA_PREFERRED_PLUGINS", "w");
#endif

#ifdef Q_OS_ANDROID
    QGuiApplication app(argc, argv);
    if (!MAUIAndroid::checkRunTimePermissions({"android.permission.WRITE_EXTERNAL_STORAGE"}))
        return -1;
#else
    QApplication app(argc, argv);
#endif

    app.setOrganizationName(QStringLiteral("Maui"));
    app.setWindowIcon(QIcon("://assets/index.png"));

    KLocalizedString::setApplicationDomain("index-fm");

    KAboutData about(QStringLiteral("index"),
                     i18n("Index"),
                     INDEX_VERSION_STRING,
                     i18n("Browse, organize and preview your files."),
                     KAboutLicense::LGPL_V3,
                     INDEX_COPYRIGHT_NOTICE,
                     QString(GIT_BRANCH) + "/" + QString(GIT_COMMIT_HASH));

    about.addAuthor(QStringLiteral("Camilo Higuita"), i18n("Developer"), QStringLiteral("milo.h@aol.com"));
    about.addAuthor(QStringLiteral("Gabriel Dominguez"), i18n("Developer"), QStringLiteral("gabriel@gabrieldominguez.es"));
    about.setHomepage("https://mauikit.org");
    about.setProductName("maui/index");
    about.setBugAddress("https://invent.kde.org/maui/index-fm/-/issues");
    about.setOrganizationDomain(INDEX_URI);
    about.setProgramLogo(app.windowIcon());
    about.addComponent("KIO", "", KIO_VERSION_STRING);

    const auto FBData = MauiKitFileBrowsing::aboutData();
    about.addComponent(FBData.name(), MauiKitFileBrowsing::buildVersion(), FBData.version(), FBData.webAddress());

    KAboutData::setApplicationData(about);
    MauiApp::instance()->setIconName("qrc:/assets/index.png");

    QCommandLineOption newWindowOption(QStringList() << "n" << "new", i18n("Open url in a new window."), "url");

    QCommandLineParser parser;

    parser.addOption(newWindowOption);

    parser.setApplicationDescription(about.shortDescription());
    parser.process(app);
    about.processCommandLine(&parser);

    const QStringList args = parser.positionalArguments();
    QStringList paths;
    
    if (!args.isEmpty())
    {
        for(const auto &path : args)
            paths << QUrl::fromUserInput(path).toString();
    }

#if (defined Q_OS_LINUX || defined Q_OS_FREEBSD) && !defined Q_OS_ANDROID

    if(parser.isSet(newWindowOption))
    {
        paths = QStringList() << QUrl::fromUserInput(parser.value(newWindowOption)).toString() ;
    }else
    {        
        if (IndexInstance::attachToExistingInstance(QUrl::fromStringList(paths), false, false))
        {
            // Successfully attached to existing instance of Index
            return 0;
        }
    }

    IndexInstance::registerService();
#endif

    auto index = std::make_unique<Index>(nullptr);

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url, &index](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);

            index->setQmlObject(obj);

        }, Qt::QueuedConnection);

    engine.rootContext()->setContextObject(new KLocalizedContext(&engine));

    engine.rootContext()->setContextProperty("initPaths", paths);

    engine.rootContext()->setContextProperty("inx", index.get());
    qmlRegisterType<CompressedFile>(INDEX_URI, 1, 0, "CompressedFile");
    qmlRegisterType<FilePreviewer>(INDEX_URI, 1, 0, "FilePreviewProvider");
    qmlRegisterType<RecentFilesModel>(INDEX_URI, 1, 0, "RecentFiles");
    qmlRegisterType<DirInfo>(INDEX_URI, 1, 0, "DirInfo");
    qmlRegisterType<PathList>(INDEX_URI, 1, 0, "PathList");
    qmlRegisterType<FolderConfig>(INDEX_URI, 1, 0, "FolderConfig");
    qmlRegisterType<FileProperties>(INDEX_URI, 1, 0, "FileProperties");
    qmlRegisterType<Permission>(INDEX_URI, 1, 0, "Permission");
    qmlRegisterType<PathArrowBackground>(INDEX_URI, 1, 0, "PathArrowBackground");

    engine.load(url);

#ifdef Q_OS_MACOS
    //        MAUIMacOS::removeTitlebarFromWindow();
    //        MauiApp::instance()->setEnableCSD(true); //for now index can not handle cloud accounts
#endif
    return app.exec();
}
