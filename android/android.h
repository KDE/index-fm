#ifndef ANDROID_H
#define ANDROID_H

#include <QObject>
#include <QString>
#include <QAndroidActivityResultReceiver>
#include <QObject>
#include <QAndroidJniObject>
#include <QAndroidJniEnvironment>
#include <QtAndroid>

class Android : public QObject
{
    Q_OBJECT
public:
    explicit Android(QObject *parent = nullptr);

    Q_INVOKABLE void statusbarColor(const QString &bg, const bool &light);
    Q_INVOKABLE void shareDialog(const QString &url);

signals:

public slots:
};

#endif // ANDROID_H
