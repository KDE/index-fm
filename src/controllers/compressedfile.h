#pragma once

#include <QObject>

#include <MauiKit3/Core/fmh.h>
#include <MauiKit3/Core/mauilist.h>

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
    QUrl m_url;
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

public Q_SLOTS:
    void extract(const QUrl &where, const QString &directory = QString());
    bool compress(const QVariantList &files, const QUrl &where, const QString &fileName, const int &compressTypeSelected);

private:
    QUrl m_url;
    CompressedFileModel *m_model;

Q_SIGNALS:
    void urlChanged();
    void extractionFinished(QUrl url);
    void compressionFinished(QUrl url);
};
