#include "compressedfile.h"
#include <KArchive/KZip>
#include <KArchive/KTar>
#include <KArchive/KZip>

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
	qDebug() << "@gadominguez File:fm.cpp Funcion: getEntries  Url:" << url.toString();
	emit this->preListChanged ();
	m_list.clear ();

	KArchive *kArch = CompressedFile::getKArchiveObject(url);
	kArch->open(QIODevice::ReadOnly);
	assert(kArch->isOpen() == true);
	if(kArch->isOpen())
	{
		qDebug() << "@gadominguez File:fm.cpp Funcion: getEntries  Entries:" <<  kArch->directory()->entries();

		for(auto entry : kArch->directory()->entries())
		{
			auto e = kArch->directory()->entry(entry);

			this->m_list << FMH::MODEL {{FMH::MODEL_KEY::LABEL, e->name()}, {FMH::MODEL_KEY::ICON, e->isDirectory() ? "folder" : FMH::getIconName(e->name())}, {FMH::MODEL_KEY::DATE, e->date().toString()}};
		}
		}

					  emit this->postListChanged ();
		}

        void CompressedFile::extract(const QUrl &where, const QString & directory)
		{
			if(!m_url.isLocalFile ())
				return;

            qDebug() << "@gadominguez File:fm.cpp Funcion: extractFile  " << "URL: " << m_url <<  "WHERE: " <<  where.toString() << " DIR: " << directory;

            QString where_ = where.toLocalFile () + "/" + directory;

            auto kArch = CompressedFile::getKArchiveObject(m_url);
			kArch->open(QIODevice::ReadOnly);
			qDebug() << "@gadominguez File:fm.cpp Funcion: extractFile  " <<  kArch->directory()->entries();
			assert(kArch->isOpen() == true);
			if(kArch->isOpen())
			{
				bool recursive = true;
				kArch->directory()->copyTo(where_, recursive);
			}
		}


        /*
         *
         *  CompressTypeSelected is an integer and has to be acorrding with order in Dialog.qml
         *
         */
        void CompressedFile::compress(const QVariantList &files, const QUrl &where, const QString & directory, const int &compressTypeSelected)
        {

            assert(compressTypeSelected >= 0 && compressTypeSelected <= 8);
            for(auto uri : files)
            {
                qDebug() << "@gadominguez File:fm.cpp Funcion: compress  " << QUrl(uri.toString()).toLocalFile() << " " << directory;

                if(!QFileInfo(QUrl(uri.toString()).toLocalFile()).isDir())
                {


                    auto file = QFile(QUrl(uri.toString()).toLocalFile());
                    file.open(QIODevice::ReadWrite);
                    assert(file.isOpen() == true);

                    switch(compressTypeSelected)
                    {
                    case 0: //.ZIP
                    {
                        auto kzip = new KZip(QUrl(where.toString() + "/" + directory + ".zip").toLocalFile());
                        kzip->open(QIODevice::ReadWrite);
                        assert(kzip->isOpen() == true);

                        kzip->writeFile(uri.toString().remove(where.toString(), Qt::CaseSensitivity::CaseSensitive), // Mirror file path in compressed file from current directory
                                        file.readAll(), 0100775, QFileInfo(file).owner(),QFileInfo(file).group(), QDateTime(), QDateTime(), QDateTime());
                        kzip->close();
                        break;
                    }
                    case 1: // .TAR
                    {
                        auto ktar = new KTar(QUrl(where.toString() + "/" + directory + ".tar").toLocalFile());
                        ktar->open(QIODevice::ReadWrite);
                        assert(ktar->isOpen() == true);
                        ktar->writeFile(uri.toString().remove(where.toString(), Qt::CaseSensitivity::CaseSensitive), // Mirror file path in compressed file from current directory
                                        file.readAll(), 0100775, QFileInfo(file).owner(),QFileInfo(file).group(), QDateTime(), QDateTime(), QDateTime());
                        ktar->close();
                        break;
                    }
                    default:
                            qDebug() << "ERROR. COMPRESSED TYPE SELECTED NOT COMPATIBLE";
                        break;
                    }


                }

            }


            //kzip->prepareWriting("Hello00000.txt", "gabridc", "gabridc", 1024, 0100777, QDateTime(), QDateTime(), QDateTime());
            //kzip->writeData("Hello", sizeof("Hello"));
            //kzip->finishingWriting();

        }

		KArchive* CompressedFile::getKArchiveObject(const QUrl &url)
		{
			KArchive *kArch = nullptr;

			/*
			* This checks depends on type COMPRESSED_MIMETYPES in file fmh.h
			*/
			qDebug() << "@gadominguez File: fmstatic.cpp Func: getKArchiveObject MimeType: " <<  FMH::getMime(url);

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
