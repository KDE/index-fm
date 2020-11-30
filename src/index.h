// Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2018-2020 Nitrux Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later


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

    /**
     * @brief openTerminal
     * Open Terminal Windows
     * @param url
     * Path in which terminal should open
     */
    static void openTerminal(const QUrl &url);
};

#endif // INDEX_H
