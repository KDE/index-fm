// Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2018-2020 Nitrux Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.3

import Qt.labs.settings 1.0

import org.kde.kirigami 2.14 as Kirigami
import org.mauikit.controls 1.3 as Maui

import org.mauikit.filebrowsing 1.0 as FB
import org.maui.index 1.0 as Index

import "widgets"
import "widgets/views"
import "widgets/previewer"

Maui.ApplicationWindow
{
    id: root
    title: currentTab ? currentTab.title : ""
    header.visible: false

    readonly property url currentPath : currentBrowser ?  currentBrowser.currentPath : ""

    property alias dialog : dialogLoader.item
    property alias selectionBar : _browserView.selectionBar
    property alias openWithDialog : _openWithDialog
    property alias currentTabIndex : _browserView.currentTabIndex

    property alias currentTab : _browserView.currentTab
    property alias currentSplit : _browserView.currentSplit
    readonly property FB.FileBrowser currentBrowser : currentSplit.browser

    property alias appSettings : settings

    property bool selectionMode: false

    Maui.Notify
    {
        id: _notifyOperation
        componentName: "org.kde.index"
        eventId: "fileOperation"
    }

    Settings
    {
        id: settings
        category: "Browser"
        property bool showHiddenFiles: false
        property bool showThumbnails: true
        property bool previewFiles : Kirigami.Settings.isMobile
        property bool restoreSession:  false
        property bool overviewStart : false

        property int viewType : FB.FMList.LIST_VIEW
        property int listSize : 0 // s-m-x-xl
        property int gridSize : 1 // s-m-x-xl

        property var lastSession : [[({'path': FB.FM.homePath(), 'viewType': 1})]]
        property int lastTabIndex : 0
    }

    Settings
    {
        id: sortSettings
        category: "Sorting"
        property bool foldersFirst: true
        property int sortBy: FB.FMList.MODIFIED
        property int sortOrder: Qt.AscendingOrder
        property bool group: false
    }

    onClosing:
    {
        //        sortSettings.sortBy = currentBrowser.settings.sortBy
        close.accepted = !settings.restoreSession
        var tabs = []

        for(var i = 0; i < _browserView.browserList.count; i ++)
        {
            const tab = _browserView.browserList.contentModel.get(i)
            var tabPaths = []

            for(var j = 0; j < tab.model.count; j++)
            {
                const browser = tab.model.get(j)
                const tabMap = {'path': browser.currentPath, 'viewType': browser.settings.viewType}
                tabPaths.push(tabMap)

                console.log("saving tabs", browser.currentPath, browser.settings.viewType)

            }

            tabs.push(tabPaths)
        }

        console.log("saving tabs", tabs.length)

        settings.lastSession = tabs
        settings.lastTabIndex = currentTabIndex

        close.accepted = true
    }

    Component
    {
        id: _tagsDialogComponent

        FB.TagsDialog
        {
            taglist.strict: false
            composerList.strict: false

            onTagsReady:
            {
                composerList.updateToUrls(tags)
            }
        }
    }

    FB.OpenWithDialog { id: _openWithDialog }

    Component
    {
        id: _configDialogComponent
        SettingsDialog {}
    }

    Component
    {
        id: _shortcutsDialogComponent
        ShortcutsDialog {}
    }

    Component
    {
        id: _extractDialogComponent

        Maui.Dialog
        {
            id: _extractDialog

            title: i18n("Extract")
            message: i18n("Extract the content of the compressed file into a new or existing subdirectory or inside the current directory.")
            entryField: true
            page.margins: Maui.Style.space.big
            closeButtonVisible: false

            onAccepted:
            {
                _compressedFile.extract(currentPath, textEntry.text)
                _extractDialog.close()
            }
        }
    }

    Component
    {
        id: _compressDialogComponent

        Maui.FileListingDialog
        {
            id: _compressDialog

            closeButtonVisible: false

            title: i18np("Compress %1 file", "Compress %1 files", urls.length)
            message: i18n("Compress selected files into a new file.")

            textEntry.placeholderText: i18n("Archive name...")
            entryField: true

            function clear()
            {
                textEntry.clear()
                compressType.currentIndex = 0
                urls = []
                _showCompressedFiles.checked = false
            }

            Maui.ToolActions
            {
                id: compressType
                autoExclusive: true
                expanded: true
                currentIndex: 0

                Action
                {
                    text: ".ZIP"
                }

                Action
                {
                    text: ".TAR"
                }

                Action
                {
                    text: ".7ZIP"
                }
            }

            onRejected:
            {
                //                _compressDialog.clear()
                _compressDialog.close()
            }

            onAccepted:
            {
                var error = _compressedFile.compress(urls, currentPath, textEntry.text, compressType.currentIndex)

                if(error)
                {
                    root.notify("","Compress Error", "Some error occurs. Maybe current user does not have permission for writing in this directory.")
                }
                else
                {
                    _compressDialog.close()
                }
            }
        }
    }

    Component
    {
        id: _previewerComponent

        FilePreviewer
        {
            onClosed:
            {
                dialogLoader.sourceComponent = null
            }
        }
    }

    Component
    {
        id: _browserComponent
        BrowserLayout {}
    }

    Maui.NotifyAction
    {
        id: _extractionFinishedAction
        text: i18n("Open folder")
    }

    Index.CompressedFile
    {
        id: _compressedFile


        onExtractionFinished:
        {
            _notifyOperation.title = i18n("Extracted")
            _notifyOperation.message = i18n("File was extracted")
            _notifyOperation.defaultAction = _extractionFinishedAction
            _notifyOperation.iconName = "application-x-archive"
            _notifyOperation.send()
        }
    }

    Loader
    {
        id: dialogLoader
    }

    sideBar: PlacesSideBar
    {
        id: placesSidebar
    }

    StackView
    {
        id: _stackView
        anchors.fill: parent
        initialItem: BrowserView
        {
            id: _browserView

            headBar.forceCenterMiddleContent: root.isWide
            altHeader: Kirigami.Settings.isMobile

            flickable: currentBrowser.flickable

            headBar.middleContent: [

                Item
                {
                    Layout.fillWidth: true
                    Layout.minimumWidth: 100
                    Layout.fillHeight: true

                    PathBar
                    {
                        id: _pathBar

                        anchors.centerIn: parent
                        width: Math.min(parent.width, implicitWidth)
                        onPathChanged: currentBrowser.openFolder(path.trim())
                        url: currentBrowser.currentPath

                        onHomeClicked: currentBrowser.openFolder(FB.FM.homePath())
                        onPlaceClicked:
                        {
                            if(path === String(currentPath))
                            {
                                openMenu()

                            }
                            else
                            {
                                currentBrowser.openFolder(path)
                            }
                        }

                        onPlaceRightClicked:
                        {
                            _pathBarmenu.path = path
                            _pathBarmenu.show()
                        }

                        onMenuClicked: openMenu()

                        function openMenu()
                        {
                            browserMenu.show((width *0.5)-(browserMenu.width * 0.5), height + Maui.Style.space.medium)
                        }

                        Maui.ContextualMenu
                        {
                            id: _pathBarmenu
                            property url path


                            MenuItem
                            {
                                text: i18n("Bookmark")
                                icon.name: "bookmark-new"
                                onTriggered: currentBrowser.bookmarkFolder([_pathBarmenu.path])
                            }

                            MenuItem
                            {
                                text: i18n("Open in new tab")
                                icon.name: "tab-new"
                                onTriggered: openTab(_pathBarmenu.path)
                            }

                            MenuItem
                            {
                                visible: root.currentTab.count === 1
                                text: i18n("Open in split view")
                                icon.name: "view-split-left-right"
                                onTriggered: currentTab.split(_pathBarmenu.path, Qt.Horizontal)
                            }

                        }

                        Maui.ContextualMenu
                        {
                            id: browserMenu
                            //                            enabled: root.currentBrowser && root.currentBrowser.currentFMList.pathType !== FB.FMList.TAGS_PATH && root.currentBrowser.currentFMList.pathType !== FB.FMList.TRASH_PATH && root.currentBrowser.currentFMList.pathType !== FB.FMList.APPS_PATH


                            Maui.MenuItemActionRow
                            {
                                Action
                                {
                                    icon.name: "go-next"
                                    onTriggered: currentBrowser.goForward()
                                }

                                Action
                                {
                                    icon.name: "edit-find"
                                    checked: currentBrowser.headBar.visible
                                    checkable: true
                                    onTriggered: currentBrowser.toggleSearchBar()
                                }

                                Action
                                {
                                    icon.name: "list-add"
                                    onTriggered: currentBrowser.newItem()
                                }
                            }

                            MenuSeparator {}

                            MenuItem
                            {
                                text: i18n("Paste")
                                //         enabled: _optionsButton.enabled

                                icon.name: "edit-paste"
                                // 		enabled: control.clipboardItems.length > 0
                                onTriggered: currentBrowser.paste()
                            }

                            MenuItem
                            {
                                text: i18n("Select all")
                                icon.name: "edit-select-all"
                                onTriggered: currentBrowser.selectAll()
                            }

                            MenuSeparator{}

                            MenuItem
                            {
                                text: i18n("Go to")
                                icon.name: "edit-entry"
                                onTriggered: _pathBar.pathEntry = true
                            }

                            MenuItem
                            {
                                enabled: Maui.Handy.isLinux && !Kirigami.Settings.isMobile
                                text: i18n("Open terminal here")
                                id: openTerminal
                                icon.name: "dialog-scripts"
                                onTriggered:
                                {
                                    inx.openTerminal(currentPath)
                                }
                            }

                            MenuSeparator {}

                            MenuItem
                            {
                                text: i18n("Shortcuts")
                                icon.name: "configure-shortcuts"
                                onTriggered:
                                {
                                    dialogLoader.sourceComponent = _shortcutsDialogComponent
                                    dialog.open()
                                }
                            }

                            MenuItem
                            {
                                text: i18n("Settings")
                                icon.name: "settings-configure"
                                onTriggered: openConfigDialog()
                            }

                            MenuItem
                            {
                                text: i18n("About")
                                icon.name: "documentinfo"
                                onTriggered: root.about()
                            }
                        }
                    }
                }
            ]
        }

        Loader
        {
            id : _homeViewComponent
            asynchronous: true
            visible: StackView.status === StackView.Active
            active: StackView.status === StackView.Active || item
            HomeView
            {
                anchors.fill: parent
            }
        }
    }

    Connections
    {
        target: inx
        function onOpenPath(paths)
        {
            for(var index in paths)
                root.openTab(paths[index])
        }
    }

    Component.onCompleted:
    {
        if(Maui.Handy.isAndroid)
        {
            Maui.Android.statusbarColor(Kirigami.Theme.backgroundColor, false)
            Maui.Android.navBarColor(headBar.visible ? headBar.Kirigami.Theme.backgroundColor : Kirigami.Theme.backgroundColor, false)
        }

        const tabs = settings.lastSession
        if(settings.restoreSession && tabs.length)
        {
            console.log("restore", tabs.length)
            restoreSession(tabs)
            return
        }

        root.openTab(FB.FM.homePath())
        //            if(settings.overviewStart)
        //            {
        //                _stackView.push(_homeViewComponent)
        //            }
    }

    function toogleSplitView()
    {
        if(currentTab.count === 2)
            currentTab.pop()
        else
            currentTab.split(root.currentPath, Qt.Horizontal)
    }

    function openConfigDialog()
    {
        dialogLoader.sourceComponent = _configDialogComponent
        dialog.open()
    }

    function closeTab(index)
    {
        _browserView.browserList.closeTab(index)
    }

    function openTab(path)
    {
        if(path)
        {
            if(_stackView.depth === 2)
                _stackView.pop()

            _browserView.browserList.addTab(_browserComponent, {'path': path})
        }
    }

    function tagFiles(urls)
    {
        if(urls.length <= 0)
        {
            return
        }
        tagsDialog.composerList.urls = urls
        tagsDialog.open()
    }

    /**
     * For this to work the implementation needs to have passed a selectionBar
     **/
    function openWith(urls)
    {
        if(urls.length <= 0)
        {
            return
        }

        openWithDialog.urls = urls
        openWithDialog.open()
    }

    /**
      *
      **/
    function shareFiles(urls)
    {
        if(urls.length <= 0)
        {
            return
        }

        Maui.Platform.shareFiles(urls)
    }

    function openPreview(model, index)
    {
        dialogLoader.sourceComponent = _previewerComponent
        dialog.model = model
        dialog.currentIndex = index
        dialog.open()
    }

    function restoreSession(tabs)
    {
        for(var i = 0; i < tabs.length; i++ )
        {
            const tab = tabs[i]

            root.openTab(tab[0].path)
            currentBrowser.settings.viewType = tab[0].viewType

            if(tab.length === 2)
            {
                currentTab.split(tab[1].path, Qt.Horizontal)
                currentBrowser.settings.viewType = tab[1].viewType
            }
        }

        currentTabIndex = settings.lastTabIndex
    }
}
