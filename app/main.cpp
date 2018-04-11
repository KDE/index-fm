#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>
#include <QIcon>
#include <QCommandLineParser>
#include <QFileInfo>
#include <QDebug>
#include <index.h>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QApplication app(argc, argv);

    Index index;

    QQmlApplicationEngine engine;

    auto context = engine.rootContext();

    context->setContextProperty("inx", &index);

    QStringList importPathList = engine.importPathList();
    qDebug()<< QCoreApplication::applicationDirPath() + "/qmltermwidget";
    importPathList.prepend(QCoreApplication::applicationDirPath() + "/qmltermwidget");
    engine.setImportPathList(importPathList);


    engine.load(QUrl(QLatin1String("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
