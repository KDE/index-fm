#ifndef RECENTFILESMODEL_H
#define RECENTFILESMODEL_H

#include <MauiKit/mauilist.h>

#include <QObject>

namespace FMH
{
class FileLoader;
}
class RecentFilesModel : public MauiList
{
    Q_OBJECT
public:
    RecentFilesModel(QObject * parent = nullptr);

    const FMH::MODEL_LIST &items() const override final;

private:
    FMH::MODEL_LIST m_list;
    FMH::FileLoader * m_loader;
    void setList();

};

#endif // RECENTFILESMODEL_H
