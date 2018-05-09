#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
//#include <QQuickStyle>
#include <QIcon>
#include <QCommandLineParser>
#include <QFileInfo>
#include <QDebug>
#include <index.h>
#include "inx.h"

#ifdef Q_OS_ANDROID
#include <QGuiApplication>
#include <QIcon>
#include "../android/android.h"
#else
#include <QApplication>
#endif

#ifdef STATIC_KIRIGAMI
#include "../3rdparty/kirigami/src/kirigamiplugin.h"
#endif

#include "../mauikit/src/mauikit.h"


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
    app.setWindowIcon(QIcon(":/index.png"));

    QCommandLineParser parser;
    parser.setApplicationDescription(INX::description);
    const QCommandLineOption versionOption = parser.addVersionOption();
    parser.addOption(versionOption);
    parser.process(app);

    Index index;

    QQmlApplicationEngine engine;

    auto context = engine.rootContext();

    context->setContextProperty("inx", &index);

#ifdef STATIC_KIRIGAMI
    KirigamiPlugin::getInstance().registerTypes();
#endif

#ifdef Q_OS_ANDROID
    QIcon::setThemeName("Luv");
    Android android;
    context->setContextProperty("android", &android);
#else
    QStringList importPathList = engine.importPathList();
    importPathList.prepend(QCoreApplication::applicationDirPath() + "/kde/qmltermwidget");
    engine.setImportPathList(importPathList);
//    QQuickStyle::setStyle("material");
#endif

#ifdef MAUI_APP
    MauiKit::getInstance().registerTypes();
#endif

    engine.load(QUrl(QLatin1String("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
