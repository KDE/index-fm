#ifndef INDEX_H
#define INDEX_H

#include <QObject>
#include <QVariantList>
#include <QStringList>
#include <QFileSystemWatcher>

#ifdef STATIC_KIRIGAMI
#include "fm.h"
#else
#include "MauiKit/fm.h"
#endif

class Index : public FM
{
    Q_OBJECT
public:
    explicit Index(QObject *parent = nullptr);

    Q_INVOKABLE static QVariantList getCustomPathContent(const QString &path);
    Q_INVOKABLE static bool isCustom(const QString &path);
    Q_INVOKABLE static bool isApp(const QString &path);
    Q_INVOKABLE void openPaths(const QStringList &paths);
    Q_INVOKABLE static QVariantList getCustomPaths();
       /*KDE*/
    Q_INVOKABLE static void runApplication(const QString &exec, const QString &url);
signals:
    void openPath(QStringList paths);

public slots:
};

#endif // INDEX_H
