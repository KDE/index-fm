#include "recentfilesmodel.h"
#include <MauiKit/fileloader.h>

RecentFilesModel::RecentFilesModel(QObject *parent) :
    MauiList(parent)
  , m_loader(new FMH::FileLoader)
{
    connect(m_loader, &FMH::FileLoader::itemsReady, [&](FMH::MODEL_LIST items)
    {
        emit preItemsAppended(items.size());
        this->m_list << items;
        emit postItemAppended();
    });
}


const FMH::MODEL_LIST &RecentFilesModel::items() const
{
    return m_list;
}

void RecentFilesModel::setList()
{
    m_loader->informer = &FMH::getFileInfoModel;
    m_loader->requestPath({FMH::DownloadsPath, FMH::DocumentsPath, FMH::MusicPath}, true, QStringList(), QDir::Files, 50);
}
