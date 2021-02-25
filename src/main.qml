// Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2018-2020 Nitrux Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.3

import Qt.labs.settings 1.0
import QtQml.Models 2.3

import org.kde.kirigami 2.14 as Kirigami
import org.kde.mauikit 1.3 as Maui

import org.maui.index 1.0 as Index

import "widgets"
import "widgets/views"
import "widgets/previewer"

Maui.ApplicationWindow
{
    id: root
    title: currentTab ? currentTab.title : ""
    altHeader: Kirigami.Settings.isMobile

    readonly property url currentPath : currentBrowser ?  currentBrowser.currentPath : ""
    readonly property Maui.FileBrowser currentBrowser : currentTab && currentTab.browser ? currentTab.browser : null

    property alias dialog : dialogLoader.item
    property alias selectionBar : _browserView.selectionBar
    property alias openWithDialog : _openWithDialog
    property alias tagsDialog : _tagsDialog
    property alias currentTabIndex : _browserView.currentTabIndex
    property alias currentTab : _browserView.currentTab
    property alias viewTypeGroup : _browserView.viewTypeGroup
    property alias appSettings : settings

    property bool selectionMode: true

    Settings
    {
        id: settings
        category: "Browser"
        property bool showHiddenFiles: false
        property bool showThumbnails: true
        property bool singleClick : Kirigami.Settings.isMobile ? true : Maui.Handy.singleClick
        property bool previewFiles : Kirigami.Settings.isMobile
        property bool restoreSession:  false
        property bool supportSplit : !Kirigami.Settings.isMobile
        property bool overview : false

        property int viewType : Maui.FMList.LIST_VIEW
        property int listSize : 0 // s-m-x-xl
        property int gridSize : 1 // s-m-x-xl

        property var lastSession : [[({'path': Maui.FM.homePath(), 'viewType': 1})]]
        property int lastTabIndex : 0
    }

    Settings
    {
        id: sortSettings
        category: "Sorting"
        property bool foldersFirst: true
        property int sortBy:  Maui.FMList.MODIFIED
        property int sortOrder : Qt.AscendingOrder
        property bool group : false
        property bool globalSorting: Kirigami.Settings.isMobile
    }

    onCurrentPathChanged:
    {
        syncSidebar(currentBrowser.currentPath)
    }

    onClosing:
    {
        close.accepted = !settings.restoreSession
        var tabs = []

        for(var i = 0; i <tabsObjectModel.count; i ++)
        {
            const tab = tabsObjectModel.get(i)
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

    menuButton.visible: _stackView.depth === 1
    floatingHeader: false
    flickable: currentBrowser.flickable
    mainMenu: [Action
        {
            text: i18n("Settings")
            icon.name: "settings-configure"
            onTriggered: openConfigDialog()
        }]

    Maui.TagsDialog
    {
        id: _tagsDialog
        taglist.strict: false

        onTagsReady:
        {
            composerList.updateToUrls(tags)
        }
    }

    Maui.OpenWithDialog {id: _openWithDialog}

    Component
    {
        id: _configDialogComponent
        SettingsDialog {}
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


    Index.CompressedFile
    {
        id: _compressedFile
    }

    headBar.leftContent: ToolButton
    {
        icon.name: "go-previous"
        text: i18n("Browser")
        display: isWide ? ToolButton.TextBesideIcon : ToolButton.IconOnly
        visible: _stackView.depth === 2
        onClicked: _stackView.pop()
    }

    headBar.middleContent: [
        Maui.PathBar
        {
            id: _pathBar
            visible: _stackView.depth === 1

            Layout.fillWidth: true
            Layout.minimumWidth: 100
            Layout.maximumWidth: 500
            onPathChanged: currentBrowser.openFolder(path.trim())
            url: root.currentPath

            onHomeClicked: currentBrowser.openFolder(Maui.FM.homePath())
            onPlaceClicked: currentBrowser.openFolder(path)
            onPlaceRightClicked:
            {
                _pathBarmenu.path = path
                _pathBarmenu.popup()
            }

            Menu
            {
                id: _pathBarmenu
                property url path

                MenuItem
                {
                    text: i18n("Open in new tab")
                    icon.name: "tab-new"
                    onTriggered: openTab(_pathBarmenu.path)
                }

                MenuItem
                {
                    visible: root.currentTab.count === 1 && settings.supportSplit
                    text: i18n("Open in split view")
                    icon.name: "view-split-left-right"
                    onTriggered: currentTab.split(_pathBarmenu.path, Qt.Horizontal)
                }
            }
        },

        Maui.TextField
        {
            id: _searchField
            visible: _stackView.depth === 2
            Layout.fillWidth: true
            Layout.minimumWidth: 100
            Layout.maximumWidth: 500
            placeholderText: i18n("Search for files")
            onAccepted:
            {
                _stackView.pop()
                currentBrowser.search(text)
            }
        }
    ]

    Loader
    {
        id: dialogLoader
    }

    sideBar: PlacesSideBar
    {
        id: placesSidebar
    }

    ObjectModel { id: tabsObjectModel }

    StackView
    {
        id: _stackView
        anchors.fill: parent
        initialItem: BrowserView
        {
            id: _browserView
        }
    }

        HomeView
        {
            id : _homeViewComponent
            visible: StackView.status === StackView.Active
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
        const tabs = settings.lastSession

        if(settings.restoreSession && tabs.length)
        {
            console.log("restore", tabs.length)

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

        }else
        {
            root.openTab(Maui.FM.homePath())
            currentBrowser.settings.viewType = settings.viewType

//            if( settings.overview )
//                _stackView.push(_homeViewComponent)
        }

    }

    //     onThumbnailsSizeChanged:
    //     {
    //         if(settings.trackChanges && settings.saveDirProps)
    //             Maui.FM.setDirConf(currentPath+"/.directory", "MAUIFM", "IconSize", thumbnailsSize)
    //             else
    //                 Maui.FM.saveSettings("IconSize", thumbnailsSize, "SETTINGS")
    //
    //                 if(browserView.viewType === Maui.FMList.ICON_VIEW)
    //                     browserView.currentView.adaptGrid()
    //     }

    function syncSidebar(path)
    {
        placesSidebar.currentIndex = -1

        for(var i = 0; i < placesSidebar.count; i++)
        {
            if(String(path) === placesSidebar.model.get(i).path)
            {
                placesSidebar.currentIndex = i
                return;
            }
        }
    }

    function toogleSplitView()
    {
        if(currentTab.count == 2)
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
        var item = tabsObjectModel.get(index)
        item.destroy()
        tabsObjectModel.remove(index)
    }

    function openTab(path)
    {
        if(path)
        {
            if(_stackView.depth === 2)
                _stackView.pop()

            const component = Qt.createComponent("qrc:/widgets/views/BrowserLayout.qml");

            if (component.status === Component.Ready)
            {
                const object = component.createObject(tabsObjectModel, {'path': path});
                tabsObjectModel.append(object)
                currentTabIndex = tabsObjectModel.count - 1
            }
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
}
