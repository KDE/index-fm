#pragma once

#include <QObject>

#include <MauiKit4/FileBrowsing/fmlist.h>
#include <MauiKit4/FileBrowsing/fmstatic.h>
#include <QQmlParserStatus>

class QSettings;

class FolderConfig : public QObject , public QQmlParserStatus
{
    Q_OBJECT
    Q_INTERFACES(QQmlParserStatus)

    Q_PROPERTY(QUrl path READ getPath WRITE setPath NOTIFY pathChanged)

    Q_PROPERTY(FMList::SORTBY sortKey READ sortKey WRITE setSortKey NOTIFY sortKeyChanged)
    Q_PROPERTY(FMList::SORTBY fallbackSortKey READ fallbackSortKey WRITE setFallbackSortKey NOTIFY fallbackSortKeyChanged)

    Q_PROPERTY(FMList::VIEW_TYPE viewType READ viewType WRITE setViewType NOTIFY viewTypeChanged)
    Q_PROPERTY(FMList::VIEW_TYPE fallbackViewType READ fallbackViewType WRITE setFallbackViewType NOTIFY fallbackViewTypeChanged)

    Q_PROPERTY(bool terminalVisible READ terminalVisible WRITE setTerminalVisible NOTIFY terminalVisibleChanged)

    Q_PROPERTY(bool enabled READ enabled WRITE setEnabled NOTIFY enabledChanged)


public:
    explicit FolderConfig(QObject *parent = nullptr);
~FolderConfig();

    void setSortKey(const FMList::SORTBY &value);
    FMList::SORTBY sortKey() const;

    void setTerminalVisible(const bool &value);
    bool terminalVisible() const;

    QUrl getPath() const;
    void setPath(QUrl path);

    FMList::VIEW_TYPE viewType() const;

    FMList::SORTBY fallbackSortKey() const;

    FMList::VIEW_TYPE fallbackViewType() const;

public Q_SLOTS:
    void setViewType(FMList::VIEW_TYPE viewType);

    void setFallbackSortKey(FMList::SORTBY fallbackSortKey);

    void setFallbackViewType(FMList::VIEW_TYPE fallbackViewType);

    void setEnabled(bool enabled);

private:
    QSettings *m_settings;
    QUrl m_path;
    bool m_terminalVisible = false;

    const QVariantMap dirConf(const QUrl &path);
    void setDirConf(const QString &key, const QVariant &value);

    void setValues();
    void resetToFallbackValues();

    FMList::SORTBY m_sortKey ;
    FMList::SORTBY m_fallbackSortKey;

    FMList::VIEW_TYPE m_fallbackViewType;
    FMList::VIEW_TYPE m_viewType;

    bool m_enabled = false;

Q_SIGNALS:
    void sortKeyChanged();
    void terminalVisibleChanged();
    void pathChanged(QUrl path);
    void viewTypeChanged(FMList::VIEW_TYPE viewType);
    void fallbackSortKeyChanged();
    void fallbackViewTypeChanged();

    void enabledChanged();

public:
    void classBegin() override final;
    void componentComplete() override final;
    bool enabled() const;
};

