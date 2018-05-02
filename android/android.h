#ifndef ANDROID_H
#define ANDROID_H

#include <QObject>
#include <QString>
#include <QAndroidActivityResultReceiver>
#include <QObject>
#include <QAndroidJniObject>
#include <QAndroidJniEnvironment>
#include <QtAndroid>
#include <QStringList>
#include <QString>

class Android : public QObject
{
    Q_OBJECT
public:
    explicit Android(QObject *parent = nullptr);

    Q_INVOKABLE void statusbarColor(const QString &bg, const bool &light);
    Q_INVOKABLE void shareDialog(const QString &url);
    Q_INVOKABLE static QStringList defaultPaths();
    Q_INVOKABLE static QString homePath();



public slots:
};

namespace PATHS {
const QString HomePath = Android::homePath();
const QString PicturesPath = HomePath+"/"+QAndroidJniObject::getStaticObjectField("android/os/Environment", "DIRECTORY_PICTURES", "Ljava/lang/String;").toString();
const QString DownloadsPath = HomePath+"/"+QAndroidJniObject::getStaticObjectField("android/os/Environment", "DIRECTORY_DOWNLOADS", "Ljava/lang/String;").toString();
const QString DocumentsPath = HomePath+"/"+QAndroidJniObject::getStaticObjectField("android/os/Environment", "DIRECTORY_DOCUMENTS", "Ljava/lang/String;").toString();
const QString MusicPath = HomePath+"/"+QAndroidJniObject::getStaticObjectField("android/os/Environment", "DIRECTORY_MUSIC", "Ljava/lang/String;").toString();
const QString VideosPath = HomePath+"/"+QAndroidJniObject::getStaticObjectField("android/os/Environment", "DIRECTORY_MOVIES", "Ljava/lang/String;").toString();

}

#endif // ANDROID_H
