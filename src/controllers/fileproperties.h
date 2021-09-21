#ifndef FILEPROPERTIES_H
#define FILEPROPERTIES_H

#include <QObject>
#include <QUrl>
#include <QFileDevice>

class Permission : public QObject
{
  Q_OBJECT
  Q_PROPERTY(QUrl url READ url WRITE setUrl NOTIFY urlChanged)
  Q_PROPERTY(UserType user READ user WRITE setUser NOTIFY userChanged)
  Q_PROPERTY(bool read READ read WRITE setRead NOTIFY readChanged)
  Q_PROPERTY(bool write READ write WRITE setWrite NOTIFY writeChanged)
  Q_PROPERTY(bool execute READ execute WRITE setExecute NOTIFY executeChanged)

 public:
  enum PermissionType
  {
    READ,
    WRITE,
    EXECUTE,
    NONE
  };
  Q_ENUM(PermissionType)

  enum UserType
  {
    OWNER,
    GROUP,
    OTHER
  };
  Q_ENUM(UserType)

  explicit Permission(QObject *parent = nullptr);

  const QUrl &url() const;
  void setUrl(const QUrl &newUrl);
  Permission::PermissionType type() const;
  void setType(PermissionType newType);

  Permission::UserType user() const;
  void setUser(UserType newUser);

  bool read() const;
  void setRead(bool newRead);

  bool write() const;
  void setWrite(bool newWrite);

  bool execute() const;
  void setExecute(bool newExecute);

private:
  QUrl m_url;
  PermissionType m_type;
  UserType m_user;

void setData();
static  bool checkPermission(const QUrl & url, const Permission::UserType &user, const Permission::PermissionType &type);
static bool setPermission(const QUrl &url,  const Permission::UserType &user, const PermissionType &key, const bool &state);
bool m_read = false;

  bool m_write = false;

  bool m_execute = false;

signals:
  void urlChanged();
  void typeChanged();
  void userChanged();
  void readChanged();
  void writeChanged();
  void executeChanged();
};

class FileProperties : public QObject
{
  Q_OBJECT
  Q_PROPERTY(QUrl url READ url WRITE setUrl NOTIFY urlChanged)
  Q_PROPERTY(QString group READ group WRITE setGroup NOTIFY groupChanged)
  Q_PROPERTY(QString owner READ owner WRITE setOwner NOTIFY ownerChanged)
  Q_PROPERTY(QStringList groups READ groups NOTIFY groupsChanged)
  Q_PROPERTY(QStringList users READ users NOTIFY usersChanged)

public:
  explicit FileProperties(QObject *parent = nullptr);

  const QUrl &url() const;
  void setUrl(const QUrl &newUrl);

  const QString &group() const;
  void setGroup(const QString &newGroup);

  const QStringList &groups() const;

  const QString &owner() const;
  void setOwner(const QString &newOwner);

  const QStringList &users() const;


private:
  QUrl m_url;

  QString m_group;

  QStringList m_groups;

  QString m_owner;
  QStringList m_users;  ///< List of all usernames on the system

  void setData();

signals:
  void urlChanged();
  void groupChanged();
  void groupsChanged();
  void ownerChanged();
  void usersChanged();
};

#endif // FILEPROPERTIES_H
