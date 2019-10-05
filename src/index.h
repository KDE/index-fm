#ifndef INDEX_H
#define INDEX_H

#include <QObject>
#include <QStringList>

class Index : public QObject
{
    Q_OBJECT
public:
    explicit Index(QObject *parent = nullptr);

    Q_INVOKABLE void openPaths(const QStringList &paths);

signals:
    void openPath(QStringList paths);


public slots:
};

#endif // INDEX_H
