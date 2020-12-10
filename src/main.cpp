// Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2018-2020 Nitrux Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QIcon>

#ifdef Q_OS_ANDROID
#include <QQuickStyle>
#endif

#include <QCommandLineParser>

#include <KAboutData>

#include "index.h"

#ifdef Q_OS_ANDROID
#include <QGuiApplication>
#include "mauiandroid.h"
#else
#include <QApplication>
#endif

#ifdef Q_OS_MACOS
#include "mauimacos.h"
#endif

#include <MauiKit/mauiapp.h>

#if defined Q_OS_MACOS || defined Q_OS_WIN
#include <KF5/KI18n/KLocalizedString>
#else
#include <KI18n/KLocalizedString>
#endif

#include "../index_version.h"

#include "controllers/compressedfile.h"
#include "controllers/filepreviewer.h"

#define INDEX_URI "org.maui.index"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QCoreApplication::setAttribute(Qt::AA_DontCreateNativeWidgetSiblings);
    QCoreApplication::setAttribute(Qt::AA_UseHighDpiPixmaps, true);
    QCoreApplication::setAttribute(Qt::AA_DisableSessionManager, true);

#ifdef Q_OS_WIN32
    qputenv("QT_MULTIMEDIA_PREFERRED_PLUGINS", "w");
#endif

#ifdef Q_OS_ANDROID
    QGuiApplication app(argc, argv);
    QQuickStyle::setStyle("maui-style");

    if (!MAUIAndroid::checkRunTimePermissions({"android.permission.WRITE_EXTERNAL_STORAGE"}))
        return -1;
#else
    QApplication app(argc, argv);
#endif

    app.setOrganizationName(QStringLiteral("Maui"));
    app.setWindowIcon(QIcon(":/index.png"));
    MauiApp::instance()->setHandleAccounts(false); //for now index can not handle cloud accounts
    MauiApp::instance()->setIconName("qrc:/assets/index.svg");

    KLocalizedString::setApplicationDomain("index");
    KAboutData about(QStringLiteral("index"), i18n("Index"), INDEX_VERSION_STRING, i18n("Index allows you to navigate your computer and preview multimedia files."),
                     KAboutLicense::LGPL_V3, i18n("© 2019-2020 Nitrux Development Team"));
    about.addAuthor(i18n("Camilo Higuita"), i18n("Developer"), QStringLiteral("milo.h@aol.com"));
    about.addAuthor(i18n("Gabriel Dominguez"), i18n("Developer"), QStringLiteral("gabriel@gabrieldominguez.es"));
    about.setHomepage("https://mauikit.org");
    about.setProductName("maui/index");
    about.setBugAddress("https://invent.kde.org/maui/index-fm/-/issues");
    about.setOrganizationDomain(INDEX_URI);
    about.setProgramLogo(app.windowIcon());

    KAboutData::setApplicationData(about);

    QCommandLineParser parser;
    parser.process(app);

    about.setupCommandLine(&parser);
    about.processCommandLine(&parser);

    const QStringList args = parser.positionalArguments();
    QStringList paths;

    if(!args.isEmpty())
        paths = args;

    Index index;
    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url, paths, &index](QObject *obj, const QUrl &objUrl)
    {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);

        if(!paths.isEmpty())
            index.openPaths(paths);

    }, Qt::QueuedConnection);

    engine.rootContext()->setContextProperty("inx", &index);
    qmlRegisterType<CompressedFile>(INDEX_URI, 1, 0, "CompressedFile");
    qmlRegisterType<FilePreviewer>(INDEX_URI, 1, 0, "FilePreviewProvider");

    engine.load(url);

#ifdef Q_OS_MACOS
//        MAUIMacOS::removeTitlebarFromWindow();
//        MauiApp::instance()->setEnableCSD(true); //for now index can not handle cloud accounts
#endif
    return app.exec();
}
