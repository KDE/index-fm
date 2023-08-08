#include "dirinfo.h"

#if (defined Q_OS_LINUX || defined Q_OS_FREEBSD) && !defined Q_OS_ANDROID
#include <KIO/DirectorySizeJob>
#include <KIO/FileSystemFreeSpaceJob>
#endif

#include <QDebug>
#include <MauiKit3/FileBrowsing/fmstatic.h>

DirInfo::DirInfo(QObject *parent) : QObject(parent)
{
#if (defined Q_OS_LINUX || defined Q_OS_FREEBSD) && !defined Q_OS_ANDROID
    auto m_free =  KIO::fileSystemFreeSpace (QUrl("file:///"));
    connect(m_free, &KIO::FileSystemFreeSpaceJob::result, [this, m_free](KJob *, KIO::filesize_t size, KIO::filesize_t available)
    {
        qDebug() << "got dir size info FREEE" << size << available;

        m_totalSpace = size;
        m_avaliableSpace = available;

        emit this->avaliableSpaceChanged(m_avaliableSpace);
        emit this->totalSpaceChanged(m_totalSpace);

        m_free->deleteLater();

    });
#endif
}

QUrl DirInfo::url() const
{
    return m_url;
}

quint64 DirInfo::size() const
{
    return m_size;
}

quint64 DirInfo::dirCount() const
{
    return m_dirCount;
}

quint64 DirInfo::filesCount() const
{
    return m_filesCount;
}

QString DirInfo::sizeString() const
{
    QLocale m_locale;
    return m_locale.formattedDataSize(m_size);
}

quint64 DirInfo::avaliableSpace() const
{
    return m_avaliableSpace;
}

quint64 DirInfo::totalSpace() const
{
    return m_totalSpace;
}

QString DirInfo::avaliableSpaceString() const
{
    QLocale m_locale;
    return m_locale.formattedDataSize(m_avaliableSpace);
}

QString DirInfo::totalSpaceString() const
{
    QLocale m_locale;
    return m_locale.formattedDataSize(m_totalSpace);
}

void DirInfo::setUrl(QUrl url)
{
    if (m_url == url)
        return;

    m_url = url;
    this->getSize();
    emit urlChanged(m_url);
}

void DirInfo::getSize()
{
    if(!m_url.isValid() || m_url.isEmpty() || !m_url.isLocalFile())
        return;
    qDebug() << "Askign for dir size" << m_url;

#if (defined Q_OS_LINUX || defined Q_OS_FREEBSD) && !defined Q_OS_ANDROID
    auto m_job = KIO::directorySize(m_url);

    //    connect(m_job, &KIO::DirectorySizeJob::percent, [this, m_job](KJob *, unsigned long percent)
    //    {
    //        qDebug() << "got dir size info percent" << percent;
    //    });

//    connect(m_job, &KIO::DirectorySizeJob::processedSize, [this, m_job](KJob *, qulonglong size)
//    {
//        qDebug() << "got dir size info processed size" << size;
//    });

    connect(m_job, &KIO::DirectorySizeJob::result, [this, m_job](KJob *)
    {
        qDebug() << "got dir size info" << m_job->totalSize();
        m_size = m_job->totalSize();
        m_filesCount = m_job->totalFiles();
        m_dirCount = m_job->totalSubdirs();

        emit this->sizeChanged(m_size);
        emit this->filesCountChanged(m_filesCount);
        emit this->dirsCountChanged(m_dirCount);

    });

#endif
}

