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
    altHeader: Kirigami.Settings.isMobile

    readonly property url currentPath : currentBrowser ?  currentBrowser.currentPath : ""
    readonly property FB.FileBrowser currentBrowser : currentTab && currentTab.browser ? currentTab.browser : null

    property alias dialog : dialogLoader.item
    property alias selectionBar : _browserView.selectionBar
    property alias openWithDialog : _openWithDialog
    property alias tagsDialog : _tagsDialog
    property alias currentTabIndex : _browserView.currentTabIndex
    property alias currentTab : _browserView.currentTab
    property alias appSettings : settings

    property bool selectionMode: false

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
        property int sortBy:  FB.FMList.MODIFIED
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

    menuButton.visible: _stackView.depth === 1
    floatingHeader: false
    flickable: currentBrowser.flickable
    mainMenu: [Action
        {
            text: i18n("Settings")
            icon.name: "settings-configure"
            onTriggered: openConfigDialog()
        }]

    FB.TagsDialog
    {
        id: _tagsDialog
        taglist.strict: false
        composerList.strict: false

        onTagsReady:
        {
            composerList.updateToUrls(tags)
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

        }
    }

    Component
    {
        id: _browserComponent
        BrowserLayout {}
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

    headBar.rightContent: ToolButton
    {
        icon.name: "edit-find"
        checked: currentBrowser.headBar.visible
        onClicked: currentBrowser.toggleSearchBar()
    }

    headBar.middleContent: [
        Maui.PathBar
        {
            id: _pathBar
            visible: _stackView.depth === 1

            Layout.fillWidth: true
            Layout.minimumWidth: 100
            //            Layout.maximumWidth: 500
            onPathChanged: currentBrowser.openFolder(path.trim())
            url: root.currentPath

            onHomeClicked: currentBrowser.openFolder(FB.FM.homePath())
            onPlaceClicked: currentBrowser.openFolder(path)
            onPlaceRightClicked:
            {
                _pathBarmenu.path = path
                _pathBarmenu.open()
            }

            Maui.ContextualMenu
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
            //            Layout.maximumWidth: 500
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
        if(Maui.Handy.isAndroid)
        {
            Maui.Android.statusbarColor(Kirigami.Theme.backgroundColor, false)
            Maui.Android.navBarColor(headBar.visible ? headBar.Kirigami.Theme.backgroundColor : Kirigami.Theme.backgroundColor, false)
        }

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
            root.openTab(FB.FM.homePath())
            currentBrowser.settings.viewType = settings.viewType

            if( settings.overviewStart )
            {
                _stackView.push(_homeViewComponent)
            }
        }

    }

    //     onThumbnailsSizeChanged:
    //     {
    //         if(settings.trackChanges && settings.saveDirProps)
    //             Maui.FM.setDirConf(currentPath+"/.directory", "MAUIFM", "IconSize", thumbnailsSize)
    //             else
    //                 Maui.FM.saveSettings("IconSize", thumbnailsSize, "SETTINGS")
    //
    //                 if(browserView.viewType === FB.FMList.ICON_VIEW)
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
        _browserView.browserList.closeTab(index)
    }

    function openTab(path)
    {
        if(path)
        {
            if(_stackView.depth === 2)
                _stackView.pop()

            _browserView.browserList.addTab(_browserComponent, {'path': path})
            _browserView.browserList.currentIndex = _browserView.browserList.count -1
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
}
