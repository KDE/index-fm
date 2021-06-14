#ifndef SESSIONMANAGER_H
#define SESSIONMANAGER_H

#include <QObject>


class SessionManager : public QObject
{
    Q_OBJECT
//    Q_PROPERTY(QVariantList tabs READ tabs NOTIFY tabsChanged FINAL)
public:
    explicit SessionManager(QObject *parent = nullptr);

public slots:

signals:

};

#endif // SESSIONMANAGER_H
