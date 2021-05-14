#include "folderconfig.h"
#include <KConfig>
#include <QDebug>

FolderConfig::FolderConfig(QObject *parent) : QObject(parent)
{      
    connect(this, &FolderConfig::pathChanged, [this](QUrl path)
    {
        const auto conf = dirConf(path.toString()+"/.directory");

        if(conf.isEmpty())
        {
            return;
        }

        this->m_terminalVisible = conf[FMH::MODEL_NAME[FMH::MODEL_KEY::SHOWTERMINAL]].toBool();
        this->m_sortKey = static_cast<FMList::SORTBY>(conf[FMH::MODEL_NAME[FMH::MODEL_KEY::SORTBY]].toInt());

        emit terminalVisibleChanged();
        emit sortKeyChanged();
    });
}

void FolderConfig::setSortKey(const FMList::SORTBY &value)
{
    if(m_sortKey == value)
    {
        return;
    }

    m_sortKey = value;
    emit sortKeyChanged();
    FMStatic::setDirConf(m_path.toString() + "/.directory", "MAUIFM", "SortBy", this->m_sortKey);
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

    FMStatic::setDirConf(m_path.toString() + "/.directory", "MAUIFM", "ShowTerminal", this->m_terminalVisible);
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

const QVariantMap FolderConfig::dirConf(const QUrl &path)
{
    if (!path.isLocalFile()) {
        qWarning() << "URL recived is not a local file" << path;
        return QVariantMap();
    }

    if (!FMH::fileExists(path))
        return QVariantMap();

    QString showterminal;
    uint sortby = FMH::MODEL_KEY::MODIFIED;

#if defined Q_OS_ANDROID || defined Q_OS_WIN || defined Q_OS_MACOS || defined Q_OS_IOS
    QSettings file(path.toLocalFile(), QSettings::Format::NativeFormat);

    file.beginGroup(QString("MAUIFM"));
    showterminal = file.value("ShowTerminal").toString();
    auto sortValue = file.value("SortBy");
    sortby = sortValue.isValid() ? sortValue.toInt() : m_sortKey;
    file.endGroup();
#else
    KConfig file(path.toLocalFile());
    showterminal = file.entryMap(QString("MAUIFM"))["ShowTerminal"];
    auto sortValue = file.entryMap(QString("MAUIFM"))["SortBy"];
    sortby = !sortValue.isEmpty() ? sortValue.toInt() : m_sortKey;
#endif

    return QVariantMap({
                        {FMH::MODEL_NAME[FMH::MODEL_KEY::SHOWTERMINAL], showterminal.isEmpty() ? "false" : showterminal},
                        {FMH::MODEL_NAME[FMH::MODEL_KEY::SORTBY], sortby}});

}
