#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QIcon>
#include <QCommandLineParser>
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
#include "3rdparty/kirigami/src/kirigamiplugin.h"
#endif

#ifdef STATIC_MAUIKIT
#include "3rdparty/mauikit/src/mauikit.h"
#endif


//#if defined (Q_OS_ANDROID)
//#include <QtAndroid>

//bool requestAndroidPermissions(){
//    //Request requiered permissions at runtime

//    const QVector<QString> permissions({"android.permission.WRITE_EXTERNAL_STORAGE"});

//    for(const QString &permission : permissions){
//        auto result = QtAndroid::checkPermission(permission);
//        if(result == QtAndroid::PermissionResult::Denied){
//            auto resultHash = QtAndroid::requestPermissionsSync(QStringList({permission}));
//            if(resultHash[permission] == QtAndroid::PermissionResult::Denied)
//                return false;
//        }
//    }

//    return true;
//}
//#endif

#ifdef Q_OS_ANDROID
#include <QtAndroid>


// Taken from https://bugreports.qt.io/browse/QTBUG-50759
bool check_permission() {

    qDebug() << "CHECHKIGN PERMISSIONS";

    QtAndroid::PermissionResult r = QtAndroid::checkPermission("android.permission.WRITE_EXTERNAL_STORAGE");
    if(r == QtAndroid::PermissionResult::Denied) {
        QtAndroid::requestPermissionsSync( QStringList() << "android.permission.WRITE_EXTERNAL_STORAGE" );
        r = QtAndroid::checkPermission("android.permission.WRITE_EXTERNAL_STORAGE");
        if(r == QtAndroid::PermissionResult::Denied) {
            qDebug() << "Permission denied";
            return false;
        }
    }

    qDebug() << "Permissions granted!";
    return true;
}

#endif
int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

#ifdef Q_OS_ANDROID
    QGuiApplication app(argc, argv);
#else
    QApplication app(argc, argv);
#endif

//#if defined (Q_OS_ANDROID)
//    if(!requestAndroidPermissions())
//        return -1;
//#endif

    if (!check_permission())
            return -1;


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

#ifdef STATIC_KIRIGAMI
    KirigamiPlugin::getInstance().registerTypes();
#endif

#ifdef STATIC_MAUIKIT
    MauiKit::getInstance().registerTypes();
#endif


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

    const auto context = engine.rootContext();
    context->setContextProperty("inx", &index);
    engine.load(url);
    return app.exec();
}
