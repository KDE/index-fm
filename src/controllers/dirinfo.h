#ifndef DIRINFO_H
#define DIRINFO_H

#include <QObject>
#include <QUrl>
#include <QQmlParserStatus>

class DirInfo : public QObject
{
//    Q_INTERFACES(QQmlParserStatus)

    Q_OBJECT
    Q_PROPERTY(QUrl url READ url WRITE setUrl NOTIFY urlChanged)
    Q_PROPERTY(quint64 size READ size NOTIFY sizeChanged FINAL)
    Q_PROPERTY(QString sizeString READ sizeString NOTIFY sizeChanged FINAL)

    Q_PROPERTY(quint64 filesCount READ filesCount NOTIFY filesCountChanged FINAL)
    Q_PROPERTY(quint64 dirCount READ dirCount NOTIFY dirsCountChanged FINAL)

    Q_PROPERTY(quint64 avaliableSpace READ avaliableSpace NOTIFY avaliableSpaceChanged FINAL)
    Q_PROPERTY(quint64 totalSpace READ totalSpace NOTIFY totalSpaceChanged FINAL)

    Q_PROPERTY(QString avaliableSpaceString READ avaliableSpaceString NOTIFY avaliableSpaceChanged FINAL)
    Q_PROPERTY(QString totalSpaceString READ totalSpaceString NOTIFY totalSpaceChanged FINAL)

public:
    explicit DirInfo(QObject *parent = nullptr);

    QUrl url() const;

    quint64 size() const;

    quint64 dirCount() const;

    quint64 filesCount() const;

    QString sizeString() const;

    quint64 avaliableSpace() const;

    quint64 totalSpace() const;

    QString avaliableSpaceString() const;

    QString totalSpaceString() const;

public slots:
    void setUrl(QUrl url);

private:
    void getSize();

    QUrl m_url;
    quint64 m_size = 0;
    quint64 m_filesCount = 0;
    quint64 m_dirCount = 0;

    quint64 m_avaliableSpace = 0;

    quint64 m_totalSpace = 0;

signals:
    void urlChanged(QUrl url);
    void sizeChanged(quint64 size);
    void dirsCountChanged(quint64 dirCount);
    void filesCountChanged(quint64 filesCount);

    void avaliableSpaceChanged(quint64 avaliableSpace);
    void totalSpaceChanged(quint64 totalSpace);
};

#endif // DIRINFO_H
