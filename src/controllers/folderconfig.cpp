#include "folderconfig.h"
#include <QSettings>

#include <QDebug>

FolderConfig::FolderConfig(QObject *parent) : QObject(parent)
  ,m_settings(nullptr)
{      

}

FolderConfig::~FolderConfig()
{
    if(m_settings)
    {
        m_settings->deleteLater();
    }
}

void FolderConfig::setSortKey(const FMList::SORTBY &value)
{
    if(m_sortKey == value)
    {
        return;
    }

    m_sortKey = value;
    emit sortKeyChanged();

    if(m_enabled)
    {
        setDirConf("SortBy", this->m_sortKey);
    }
}

FMList::SORTBY FolderConfig::sortKey() const
{
    return m_sortKey;
}

void FolderConfig::setTerminalVisible(const bool &value)
{
    if(m_terminalVisible == value)
    {
        return;
    }

    m_terminalVisible = value;
    emit terminalVisibleChanged();

    if(m_enabled)
    {
        setDirConf("ShowTerminal", this->m_terminalVisible);
    }
}

bool FolderConfig::terminalVisible() const
{
    return m_terminalVisible;
}

QUrl FolderConfig::getPath() const
{
    return m_path;
}

void FolderConfig::setPath(QUrl path)
{
    if (m_path == path)
        return;

    m_path = path;
    emit pathChanged(m_path);
}

FMList::VIEW_TYPE FolderConfig::viewType() const
{
    return m_viewType;
}

FMList::SORTBY FolderConfig::fallbackSortKey() const
{
    return m_fallbackSortKey;
}

FMList::VIEW_TYPE FolderConfig::fallbackViewType() const
{
    return m_fallbackViewType;
}

void FolderConfig::setViewType(FMList::VIEW_TYPE viewType)
{
    if (m_viewType == viewType)
        return;

    m_viewType = viewType;
    emit viewTypeChanged(m_viewType);

    if(m_enabled)
    {
        setDirConf( "ViewType", this->m_viewType);
    }
}

void FolderConfig::setFallbackSortKey(FMList::SORTBY fallbackSortKey)
{
    if (m_fallbackSortKey == fallbackSortKey)
        return;

    m_fallbackSortKey = fallbackSortKey;
    emit fallbackSortKeyChanged();
}

void FolderConfig::setFallbackViewType(FMList::VIEW_TYPE fallbackViewType)
{
    if (m_fallbackViewType == fallbackViewType)
        return;

    m_fallbackViewType = fallbackViewType;
    emit fallbackViewTypeChanged();
}

void FolderConfig::setEnabled(bool enabled)
{
    if (m_enabled == enabled)
        return;

    m_enabled = enabled;
    emit enabledChanged();
}

void FolderConfig::setDirConf(const QString &key, const QVariant &value)
{
    if(!m_settings)
        return;

    if (!m_path.isValid() || !m_path.isLocalFile() || !FMH::fileExists(m_path))
    {
        qWarning() << "URL recived is not a local file" << m_path;
        return;
    }

    m_settings->beginGroup("Index");
    m_settings->setValue(key, value);
    m_settings->endGroup();
    m_settings->sync();
}

void FolderConfig::setValues()
{
    if(!m_enabled)
        return;

    if (!m_path.isValid() || !m_path.isLocalFile() || !FMH::fileExists(m_path))
    {
        qWarning() << "URL recived is not a local file" << m_path;
        return;
    }

    bool showterminal = false;
    uint sortby = m_fallbackSortKey;
    uint viewType = m_fallbackViewType;

    auto configUrl = QUrl(m_path.toString()+"/.directory");
     m_settings = new QSettings(configUrl.toLocalFile(), QSettings::Format::NativeFormat);

    if (FMH::fileExists(configUrl) && configUrl.isLocalFile())
    {
        m_settings->beginGroup("Index");

        showterminal = m_settings->value("ShowTerminal", false).toBool();
        sortby= m_settings->value("SortBy", m_fallbackSortKey).toUInt();
        viewType = m_settings->value("ViewType", m_fallbackViewType).toUInt();
        m_settings->endGroup();
    }

    this->m_terminalVisible = showterminal;
    this->m_sortKey = static_cast<FMList::SORTBY>(sortby);
    this->m_viewType = static_cast<FMList::VIEW_TYPE>(viewType);

    Q_EMIT terminalVisibleChanged();
    Q_EMIT sortKeyChanged();
    Q_EMIT viewTypeChanged(m_viewType);
}

void FolderConfig::resetToFallbackValues()
{
    this->m_terminalVisible = false;
    this->m_sortKey = m_fallbackSortKey;
    this->m_viewType = m_fallbackViewType;

    Q_EMIT terminalVisibleChanged();
    Q_EMIT sortKeyChanged();
    Q_EMIT viewTypeChanged(m_viewType);
}

void FolderConfig::classBegin()
{
}

void FolderConfig::componentComplete()
{
    m_sortKey = m_fallbackSortKey;
    m_viewType = m_fallbackViewType;

    connect(this, &FolderConfig::pathChanged, [this](QUrl)
    {
        setValues();
    });

    connect(this, &FolderConfig::fallbackViewTypeChanged, [this]()
    {
        if(!m_enabled)
        {
            this->m_viewType = m_fallbackViewType;
            Q_EMIT viewTypeChanged(m_viewType);
        }
    });

    connect(this, &FolderConfig::fallbackSortKeyChanged, [this]()
    {
        if(!m_enabled)
        {
            this->m_sortKey = m_fallbackSortKey;
            Q_EMIT sortKeyChanged();
        }
    });

    connect(this, &FolderConfig::enabledChanged, [this]()
    {
        if(!m_enabled)
        {
            resetToFallbackValues();
        }else
        {
            setValues();
        }
    });

    setValues();
}

bool FolderConfig::enabled() const
{
    return m_enabled;
}
