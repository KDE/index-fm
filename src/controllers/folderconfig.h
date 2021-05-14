#ifndef FOLDERCONFIG_H
#define FOLDERCONFIG_H

#include <QObject>

#include <MauiKit/FileBrowsing/fmlist.h>
#include <MauiKit/FileBrowsing/fmstatic.h>

class FolderConfig : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QUrl path READ getPath WRITE setPath NOTIFY pathChanged)

    Q_PROPERTY(FMList::SORTBY sortKey READ sortKey WRITE setSortKey NOTIFY sortKeyChanged)
    Q_PROPERTY(FMList::VIEW_TYPE viewType READ viewType WRITE setViewType NOTIFY viewTypeChanged)

    Q_PROPERTY(bool terminalVisible READ terminalVisible WRITE setTerminalVisible NOTIFY terminalVisibleChanged)

public:
    explicit FolderConfig(QObject *parent = nullptr);

    void setSortKey(const FMList::SORTBY &value);
    FMList::SORTBY sortKey() const;

    void setTerminalVisible(const bool &value);
    bool terminalVisible() const;
    QUrl getPath() const;
    void setPath(QUrl path);

    FMList::VIEW_TYPE viewType() const;

public slots:
    void setViewType(FMList::VIEW_TYPE viewType);

private:
    QUrl m_path;
    FMList::SORTBY m_sortKey = FMList::SORTBY::LABEL;
    bool m_terminalVisible = false;
    const QVariantMap dirConf(const QUrl &path);

    FMList::VIEW_TYPE m_viewType =FMList::VIEW_TYPE::ICON_VIEW;

signals:

    void sortKeyChanged();
    void terminalVisibleChanged();
    void pathChanged(QUrl path);
    void viewTypeChanged(FMList::VIEW_TYPE viewType);
};

#endif // FOLDERCONFIG_H
