#include "fileproperties.h"
#include <QFile>
#include <QFileInfo>

#include <KUser>
#include <QDebug>

// Only maxentries users are listed in the plugin
// increase if you need more
#define MAXENTRIES 1000

FileProperties::FileProperties(QObject *parent) : QObject(parent)
{
  connect(this, &FileProperties::urlChanged, [this]()
  {
    this->setData ();
  });
}

const QUrl &FileProperties::url() const
{
  return m_url;
}

void FileProperties::setUrl(const QUrl &newUrl)
{
  if (m_url == newUrl)
    return;
  m_url = newUrl;
  emit urlChanged();
}

bool Permission::checkPermission(const QUrl &url, const Permission::UserType &user, const Permission::PermissionType &type)
{
  qDebug() << "Checkign permissions" <<url << user << type;

  if(!url.isValid () || url.isEmpty () || !url.isLocalFile ())
    {
      return false;
    }

  qDebug() << "Checkign permissions" << user << type;

  QFile file(url.toLocalFile ());

  auto permissions = file.permissions ();

  switch(user)
    {
    case UserType::OWNER:
      switch(type)
        {
        case WRITE:
          return true;
        case READ:
          return permissions & QFileDevice::ReadOwner;
        case EXECUTE:
          return permissions & QFileDevice::ExeOwner;
        default: return false;
        }
      break;
    case UserType::GROUP:
      switch(type)
        {
        case WRITE:
          return ((permissions & QFileDevice::WriteGroup) == QFileDevice::WriteGroup);
        case READ:
          return ((permissions & QFileDevice::ReadGroup) == QFileDevice::ReadGroup);
        case EXECUTE:
          return ((permissions & QFileDevice::ExeGroup) == QFileDevice::ExeGroup);
        default: return false;
        }
      break;
    case UserType::OTHER:
      switch(type)
        {
        case WRITE:
          return ((permissions & QFileDevice::WriteOther) == QFileDevice::WriteOther);
        case READ:
          return ((permissions & QFileDevice::ReadOther) == QFileDevice::ReadOther);
        case EXECUTE:
          return ((permissions & QFileDevice::ExeOther) == QFileDevice::ExeOther);
        default: return false;
        }
      break;
    }

  return false;
}

void FileProperties::setData()
{
  if(!m_url.isValid () || m_url.isEmpty () || !m_url.isLocalFile ())
    {
      return;
    }

  QFileInfo file(m_url.toLocalFile ());
  m_group = file.group ();
  m_owner = file.owner ();

  emit groupChanged ();
  emit ownerChanged ();


 m_users = KUser::allUserNames (MAXENTRIES);
m_groups = KUser().groupNames (MAXENTRIES);
  // sort both lists
  m_users.sort();
  m_groups.sort();

  emit groupsChanged ();
  emit usersChanged ();
}

const QString &FileProperties::group() const
{
  return m_group;
}

void FileProperties::setGroup(const QString &newGroup)
{
  if (m_group == newGroup)
    return;
  m_group = newGroup;
  emit groupChanged();
}

const QStringList &FileProperties::groups() const
{
  return m_groups;
}

const QString &FileProperties::owner() const
{
  return m_owner;
}

void FileProperties::setOwner(const QString &newOwner)
{
  if (m_owner == newOwner)
    return;
  m_owner = newOwner;
  emit ownerChanged();
}

const QStringList &FileProperties::users() const
{
  return m_users;
}

Permission::Permission(QObject *parent) : QObject(parent)
{
  connect(this, &Permission::urlChanged, [this]()
  {
    this->setData();
  });

  connect(this, &Permission::userChanged, [this]()
  {
    this->setData();
  });
}

const QUrl &Permission::url() const
{
  return m_url;
}

void Permission::setUrl(const QUrl &newUrl)
{
  if (m_url == newUrl)
    return;
  m_url = newUrl;
  emit urlChanged();
}

Permission::PermissionType Permission::type() const
{
  return m_type;
}

void Permission::setType(PermissionType newType)
{
  if (m_type == newType)
    return;
  m_type = newType;
  emit typeChanged();
}

Permission::UserType Permission::user() const
{
  return m_user;
}

void Permission::setUser(UserType newUser)
{
  if (m_user == newUser)
    return;
  m_user = newUser;
  emit userChanged();
}

bool Permission::read() const
{
  return m_read;
}

void Permission::setRead(bool newRead)
{
  if (m_read == newRead)
    return;
  m_read = newRead;
  emit readChanged();
}

bool Permission::write() const
{
  return m_write;
}

void Permission::setWrite(bool newWrite)
{
  if (m_write == newWrite)
    return;
  m_write = newWrite;
  emit writeChanged();
}

bool Permission::execute() const
{
  return m_execute;
}

void Permission::setExecute(bool newExecute)
{
  if (m_execute == newExecute)
    return;
  m_execute = newExecute;
  emit executeChanged();
}

void Permission::setData()
{
  m_read = Permission::checkPermission (m_url, m_user, PermissionType::READ);
  m_write = Permission::checkPermission (m_url, m_user, PermissionType::WRITE);
  m_execute = Permission::checkPermission (m_url, m_user, PermissionType::EXECUTE);
  emit this->readChanged ();
  emit this->writeChanged ();
  emit this->executeChanged ();
}
