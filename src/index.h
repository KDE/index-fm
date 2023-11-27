// Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2018-2020 Nitrux Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later

#pragma once

#include <QObject>
#include <QUrl>
#include <QStringList>

#if (defined Q_OS_LINUX || defined Q_OS_FREEBSD) && !defined Q_OS_ANDROID
class OrgKdeIndexActionsInterface;

namespace IndexInstance
{
QVector<QPair<QSharedPointer<OrgKdeIndexActionsInterface>, QStringList>> appInstances(const QString& preferredService);

bool attachToExistingInstance(const QList<QUrl>& inputUrls, bool openFiles, bool splitView, const QString& preferredService = QString());

bool registerService();
}
#endif

class Index : public QObject
{
    Q_OBJECT
    //#if (defined Q_OS_LINUX || defined Q_OS_FREEBSD) && !defined Q_OS_ANDROID
    Q_CLASSINFO("D-Bus Interface", "org.kde.index.Actions")
    //#endif

public:
    explicit Index(QObject *parent = nullptr);
    Q_INVOKABLE void openPaths(const QStringList &paths);
    void setQmlObject(QObject  *object);

public Q_SLOTS:
    static QUrl cameraPath();
    static QUrl screenshotsPath();

    /**
     * Opens each directory in \p dirs in a separate tab. If \a splitView is set,
     * 2 directories are collected within one tab.
     * \pre \a dirs must contain at least one url.
     *
     * @note this function is overloaded so that it is callable via DBus.
     */
    void openDirectories(const QStringList &dirs, bool splitView);

    /**
     * Opens the directories which contain the files \p files and selects all files.
     * If \a splitView is set, 2 directories are collected within one tab.
     * \pre \a files must contain at least one url.
     *
     * @note this is overloaded so that this function is callable via DBus.
     */
    void openFiles(const QStringList &files, bool splitView);


    /**
         * Tries to raise/activate the Dolphin window.
         */
    void activateWindow();

    /**
         * Determines if a URL is open in any tab.
         * @note Use of QString instead of QUrl is required to be callable via DBus.
         *
         * @param url URL to look for
         * @returns true if url is currently open in a tab, false otherwise.
         */
    bool isUrlOpen(const QString &url);


    /**
         * Pastes the clipboard data into the currently selected folder
         * of the active view. If not exactly one folder is selected,
         * no pasting is done at all.
         */
    void pasteIntoFolder();

    /**
         * Implementation of the MainWindowAdaptor/QDBusAbstractAdaptor interface.
         * Inform all affected dolphin components (panels, views) of an URL
         * change.
         */
    void changeUrl(const QUrl& url);

    /**
         * The current directory of the Terminal Panel has changed, probably because
         * the user entered a 'cd' command. This slot calls changeUrl(url) and makes
         * sure that the panel keeps the keyboard focus.
         */
    void slotTerminalDirectoryChanged(const QUrl& url);

    /** Stores all settings and quits Dolphin. */
    void quit();

    /**
         * Opens a new tab in the background showing the URL \a url.
         */
    void openNewTab(const QUrl& url);

    /**
         * Opens a new tab  showing the URL \a url and activate it.
         */
    void openNewTabAndActivate(const QUrl &url);

    /**
         * Opens a new window showing the URL \a url.
         */
    void openNewWindow(const QUrl &url);

    /**
     * @brief openTerminal
     * Open Terminal Windows
     * @param url
     * Path in which terminal should open
     */
    static void openTerminal(const QUrl &url);

    static QVariantList quickPaths();    

private:
    QObject* m_qmlObject = nullptr;

Q_SIGNALS:
    void openPath(QStringList paths);
    void activate();
};


