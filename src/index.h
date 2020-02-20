#ifndef INDEX_H
#define INDEX_H

#include <QObject>
#include <QStringList>

class Index : public QObject
{
	Q_OBJECT
public:
	explicit Index(QObject *parent = nullptr);

	Q_INVOKABLE void openPaths(const QStringList &paths);

signals:
	void openPath(QStringList paths);

	public slots:
	bool supportsEmbededTerminal()
	{
#ifdef EMBEDDED_TERMINAL
		return true;
#else
		return false;
#endif
	}


public slots:
};

#endif // INDEX_H
