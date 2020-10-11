#include "compressedfile.h"
#include <KArchive/KZip>
#include <KArchive/KTar>
#include <KArchive/k7zip.h>
#include <KArchive/kcompressiondevice.h>

CompressedFile::CompressedFile(QObject *parent) : QObject(parent)
  ,m_model(new CompressedFileModel(this))
{

}

CompressedFileModel::CompressedFileModel(QObject * parent) : MauiList(parent)
{

}

FMH::MODEL_LIST CompressedFileModel::items() const
{
    return m_list;
}

void CompressedFileModel::setUrl(const QUrl & url)
{
    qDebug() << "@gadominguez File:compressedfile.cpp Funcion: setUrl  Url:" << url.toString();
    emit this->preListChanged ();
    m_list.clear ();

    KArchive *kArch = CompressedFile::getKArchiveObject(url);
    kArch->open(QIODevice::ReadOnly);
    assert(kArch->isOpen() == true);
    if(kArch->isOpen())
    {
        qDebug() << "@gadominguez File:fmcompressedfilecpp Funcion: setUrl  Entries:" <<  kArch->directory()->entries();

        for(auto entry : kArch->directory()->entries())
        {
            auto e = kArch->directory()->entry(entry);

            this->m_list << FMH::MODEL {{FMH::MODEL_KEY::LABEL, e->name()}, {FMH::MODEL_KEY::ICON, e->isDirectory() ? "folder" : FMH::getIconName(e->name())}, {FMH::MODEL_KEY::DATE, e->date().toString()}};
        }
        }

                            emit this->postListChanged ();
        }

        void CompressedFile::extract(const QUrl &where)
        {
            if(!m_url.isLocalFile ())
                return;

            qDebug() << "@gadominguez File:compressedfile.cpp Funcion: extract  " << where.toString() << " localFile: " << where.toLocalFile() + "/" +m_url.fileName().section(".",0,0);


            KArchive *kArch = CompressedFile::getKArchiveObject(m_url);
            kArch->open(QIODevice::ReadOnly);
            qDebug() << "@gadominguez File:compressedfile.cpp Funcion: extract  " <<  kArch->directory()->entries();
            assert(kArch->isOpen() == true);
            if(kArch->isOpen())
            {
                bool recursive = true;
                kArch->directory()->copyTo(where.toLocalFile() + "/" +  m_url.fileName().section(".",0,0), recursive);
            }
        }

        KArchive* CompressedFile::getKArchiveObject(const QUrl &url)
        {
            KArchive *kArch = nullptr;

            /*
            * This checks depends on type COMPRESSED_MIMETYPES in file fmh.h
            */
            qDebug() << "@gadominguez File: compressedfile.cpp Func: getKArchiveObject MimeType: " <<  FMH::getMime(url);

            if(FMH::getMime(url).contains("application/x-xz-compressed-tar") ||
                    FMH::getMime(url).contains("application/x-compressed-tar") ||
                    FMH::getMime(url).contains("application/x-compressed-tar") ||
                    FMH::getMime(url).contains("application/x-gtar") ||
                    FMH::getMime(url).contains("application/x-tar") ||
                    FMH::getMime(url).contains("application/x-bzip") ||
                    FMH::getMime(url).contains("application/x-xz") ||
                    FMH::getMime(url).contains("application/x-gzip"))

            {
                kArch = new KTar(url.toString().split(QString("file://"))[1]);
            }
            else if(FMH::getMime(url).contains("application/zip"))
            {
                kArch = new KZip(url.toString().split(QString("file://"))[1]);
            }
            else
            {
                qDebug() << "ERROR. COMPRESSED FILE TYPE UNKOWN " << url.toString();
            }

            return kArch;
        }

        void CompressedFile::setUrl(const QUrl & url)
        {
            if(m_url == url)
                return;

            m_url = url;
            emit this->urlChanged();

            m_model->setUrl (m_url);
        }

        QUrl CompressedFile::url() const
        {
            return m_url;
        }

        CompressedFileModel * CompressedFile::model() const
        {
            return m_model;
        }
