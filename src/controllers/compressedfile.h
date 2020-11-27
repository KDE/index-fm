#ifndef COMPRESSEDFILE_H
#define COMPRESSEDFILE_H

#include <QObject>

#ifdef STATIC_MAUIKIT
#include "fmh.h"
#include "mauilist.h"
#else
#include <MauiKit/fmh.h>
#include <MauiKit/mauilist.h>
#endif

class KArchive;
class CompressedFileModel : public MauiList
{
    Q_OBJECT
public:
    explicit CompressedFileModel(QObject *parent);
    const FMH::MODEL_LIST &items() const override final;

    void setUrl(const QUrl &url);
private:
    FMH::MODEL_LIST m_list;
};

class CompressedFile : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QUrl url READ url WRITE setUrl NOTIFY urlChanged)
    Q_PROPERTY(CompressedFileModel *model READ model CONSTANT FINAL)

public:
    explicit CompressedFile(QObject *parent = nullptr);
    static KArchive *getKArchiveObject(const QUrl &url);

    void setUrl(const QUrl &url);
    QUrl url() const;

    CompressedFileModel *model() const;

private:
    QUrl m_url;
    CompressedFileModel *m_model;

public slots:
    void extract(const QUrl &where, const QString &directory = QString());
    bool compress(const QVariantList &files, const QUrl &where, const QString & fileName, const int &compressTypeSelected);

signals:
    void urlChanged();

};

#endif // COMPRESSEDFILE_H
