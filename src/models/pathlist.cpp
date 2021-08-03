/*
 * <one line to give the program's name and a brief idea of what it does.>
 * Copyright (C) 2019  camilo <chiguitar@unal.edu.co>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "pathlist.h"
#include <QDebug>

PathList::PathList(QObject *parent) : MauiList(parent)
{
}

void PathList::componentComplete()
{
  connect(this, &PathList::pathChanged, this, &PathList::setList);
  this->setList();
}

QString PathList::getPath() const
{
  return this->m_path;
}

const FMH::MODEL_LIST &PathList::items() const
{
  return this->list;
}

void PathList::setList()
{
  const auto paths = PathList::splitPath(m_path);

  emit this->preListChanged();
  this->list = paths;
  emit this->postListChanged();

  emit this->countChanged();
}

void PathList::setPath(const QString &path)
{
  if (path == this->m_path)
    return;

  this->m_path = path;
  emit this->pathChanged();
}

FMH::MODEL_LIST PathList::splitPath(const QString &path)
{
  FMH::MODEL_LIST res;

  QString _url = path;

  while (_url.endsWith("/"))
    {
      _url.chop(1);
    }

  _url += "/";

  const auto count = _url.count("/");

  for (auto i = 0; i < count; i++)
    {
      _url = QString(_url).left(_url.lastIndexOf("/"));
      auto label = QString(_url).right(_url.length() - _url.lastIndexOf("/") - 1);

      if (label.isEmpty())
        continue;

      if (label.contains(":") && i == count - 1) // handle the protocol
        {
          res << FMH::MODEL {{FMH::MODEL_KEY::LABEL, "/"}, {FMH::MODEL_KEY::PATH, _url + "///"}};
          break;
        }

      res << FMH::MODEL {{FMH::MODEL_KEY::LABEL, label}, {FMH::MODEL_KEY::PATH, _url}};
    }
  std::reverse(res.begin(), res.end());
  return res;
}
