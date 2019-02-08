#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QIcon>
#include <QCommandLineParser>
#include <QFileInfo>
#include <QDebug>
#include "index.h"
#include "inx.h"

#ifdef Q_OS_ANDROID
#include <QGuiApplication>
#include <QIcon>
#else
#include <QApplication>
#endif

#ifdef STATIC_KIRIGAMI
#include "./../3rdparty/kirigami/src/kirigamiplugin.h"
#endif

#ifdef STATIC_MAUIKIT
#include "./../mauikit/src/mauikit.h"
#include "tagging.h"
#include "fm.h"
#else
#include "MauiKit/tagging.h"
#include "MauiKit/fm.h"
#endif

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

#ifdef Q_OS_ANDROID
    QGuiApplication app(argc, argv);
#else
    QApplication app(argc, argv);
#endif

    app.setApplicationName(INX::app);
    app.setApplicationVersion(INX::version);
    app.setApplicationDisplayName(INX::app);
    app.setOrganizationName("org.maui.index");
    app.setWindowIcon(QIcon(":/index.png"));

    QCommandLineParser parser;
    parser.setApplicationDescription(INX::description);
    const QCommandLineOption versionOption = parser.addVersionOption();
    parser.addOption(versionOption);
    parser.process(app);

    const QStringList args = parser.positionalArguments();
    QStringList paths;

    if(!args.isEmpty())
        paths = args;

    Index index;

    QQmlApplicationEngine engine;
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated, [&]()
    {
        if(!paths.isEmpty())
            index.openPaths(paths);
    });

    auto context = engine.rootContext();

    context->setContextProperty("inx", &index);

#ifdef STATIC_KIRIGAMI
    KirigamiPlugin::getInstance().registerTypes();
#endif

#ifdef STATIC_MAUIKIT
    MauiKit::getInstance().registerTypes();
#endif

#ifndef Q_OS_ANDROID
//    QStringList importPathList = engine.importPathList();
//    importPathList.prepend(QCoreApplication::applicationDirPath() + "/kde/qmltermwidget");
//    engine.setImportPathList(importPathList);
//    QQuickStyle::setStyle("material");
#endif

//        QQuickStyle::setStyle("Material");

    engine.load(QUrl(QLatin1String("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
