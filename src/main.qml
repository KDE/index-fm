// Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2018-2020 Nitrux Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import Qt.labs.settings 1.0

import org.mauikit.controls 1.3 as Maui

import org.mauikit.filebrowsing 1.3 as FB
import org.maui.index 1.0 as Index

import "widgets"
import "widgets/views"
import "widgets/previewer"

Maui.ApplicationWindow
{
    id: root
    title: currentTab ? currentTab.title : ""

    Maui.Style.styleType: Maui.Handy.isAndroid ? (appSettings.darkMode ? Maui.Style.Dark : Maui.Style.Light) : undefined
    Maui.Style.accentColor : Maui.Handy.isAndroid ?"#6765C2": undefined

    property alias dialog : dialogLoader.item
    property alias selectionBar : _browserView.selectionBar
    property alias currentTabIndex : _browserView.currentTabIndex
    property alias pathBar: _pathBar

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
        property bool previewFiles : Maui.Handy.isMobile
        property bool restoreSession:  false
        property bool overviewStart : false
        property bool actionBar: false

        property int viewType : FB.FMList.LIST_VIEW
        property int listSize : 0 // s-m-l-x-xl
        property int gridSize : 1 // s-m-l-x-xl

        property var lastSession : [[({'path': FB.FM.homePath(), 'viewType': 1})]]
        property int lastTabIndex : 0
        property bool quickSidebarSection : true
        property var sidebarSections : [
            FB.FMList.BOOKMARKS_PATH,
            FB.FMList.REMOTE_PATH,
            FB.FMList.REMOVABLE_PATH,
            FB.FMList.DRIVES_PATH]
        property bool darkMode: Maui.Style.styleType === Maui.Style.Dark

        property alias sideBarWidth : _sideBarView.sideBar.preferredWidth
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

    Component
    {
        id: _openWithDialogComponent
        FB.OpenWithDialog {}
    }

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

        Maui.NewDialog
        {
            id: _extractDialog

            title: i18n("Extract")
            message: i18n("Extract the content of the compressed file into a new or existing subdirectory or inside the current directory.")
            closeButtonVisible: false

            onFinished:
            {
                _compressedFile.extract(currentBrowser.currentPath, text)
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

            TextField
            {
                id: _textEntry
                width: parent.width
                placeholderText: i18n("Archive name...")
            }

            function clear()
            {
                _textEntry.clear()
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
                var error = _compressedFile.compress(urls, currentBrowser.currentPath, _textEntry.text, compressType.currentIndex)

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


    Maui.SideBarView
    {
        id: _sideBarView
        anchors.fill: parent
        sideBar.preferredWidth: Maui.Style.units.gridUnit * (Maui.Handy.isWindows || Maui.Handy.isAndroid ? 13 : 11)

        sideBar.minimumWidth: Maui.Style.units.gridUnit * (Maui.Handy.isWindows || Maui.Handy.isAndroid ? 13 : 11)
        sideBarContent: PlacesSideBar
        {
            id: placesSidebar
            anchors.fill: parent
        }

        Maui.Page
        {
            anchors.fill: parent
            headBar.visible: false
            footer: Loader
            {
                width: parent.width
                asynchronous: true
                active: settings.actionBar
                visible: active && !_homeViewComponent.visible
                sourceComponent:  ActionBar {}
            }

            StackView
            {
                id: _stackView
                anchors.fill: parent
                clip: false

                initialItem: BrowserView
                {
                    id: _browserView

                    flickable: currentBrowser.flickable

                    headBar.rightContent: Loader
                    {
                        id: _mainMenuLoader
                        asynchronous: true
                        sourceComponent: Maui.ToolButtonMenu
                        {
                            icon.name: settings.actionBar ? "overflow-menu" : (currentBrowser.settings.viewType === FB.FMList.LIST_VIEW ? "view-list-details" : "view-list-icons")
                            Maui.MenuItemActionRow
                            {
                                Action
                                {
                                    icon.name: "go-next"
                                    text: i18n("Forward")
                                    onTriggered: currentBrowser.goForward()
                                }

                                Action
                                {
                                    icon.name: "edit-find"
                                    text: i18n("Search")
                                    checked: currentBrowser.headBar.visible
                                    checkable: true
                                    onTriggered: currentBrowser.toggleSearchBar()
                                }

                                Action
                                {
                                    icon.name: "list-add"
                                    text: i18n("New")
                                    onTriggered: currentBrowser.newItem()
                                }
                            }

                            Maui.LabelDelegate
                            {
                                width: parent.width
                                isSection: true
                                label: i18n("Edit")
                            }

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

                            Maui.LabelDelegate
                            {
                                width: parent.width
                                isSection: true
                                label: i18n("Navigation")
                            }

                            Maui.MenuItemActionRow
                            {

                                Action
                                {
                                    icon.name: "tab-new"
                                    text: i18n("New tab")
                                    onTriggered: root.openTab(currentBrowser.currentPath)
                                }

                                Action
                                {
                                    icon.name: "view-hidden"
                                    text: i18n("Hidden")
                                    checkable: true
                                    checked: settings.showHiddenFiles
                                    onTriggered: settings.showHiddenFiles = !settings.showHiddenFiles
                                }

                                Action
                                {
                                    text: i18n("Split")
                                    icon.name: currentTab.orientation === Qt.Horizontal ? "view-split-left-right" : "view-split-top-bottom"
                                    checked: currentTab.count === 2
                                    checkable: true
                                    onTriggered: toogleSplitView()
                                }

                                Action
                                {
                                    text: i18n("Terminal")
                                    enabled: currentTab && currentTab.currentItem ? currentTab.currentItem.supportsTerminal : false
                                    icon.name: "dialog-scripts"
                                    checked : currentTab && currentBrowser ? currentTab.currentItem.terminalVisible : false
                                    checkable: true

                                    onTriggered: currentTab.currentItem.toogleTerminal()
                                }
                            }

                            MenuItem
                            {
                                text: i18n("Go to")
                                icon.name: "edit-entry"
                                onTriggered: pathBar.showEntryBar()
                            }

                            MenuItem
                            {
                                enabled: Maui.Handy.isLinux && !Maui.Handy.isMobile
                                text: i18n("Open terminal here")
                                id: openTerminal
                                icon.name: "dialog-scripts"
                                onTriggered:
                                {
                                    inx.openTerminal(currentBrowser.currentPath)
                                }
                            }

                            Maui.LabelDelegate
                            {
                                width: parent.width
                                isSection: true
                                label: i18n("View")
                            }

                            MenuItem
                            {
                                text: i18n("List")
                                icon.name: "view-list-details"
                                checked: currentBrowser.settings.viewType === FB.FMList.LIST_VIEW
                                checkable: true
                                autoExclusive: true
                                onTriggered:
                                {
                                    if(currentBrowser)
                                    {
                                        currentBrowser.settings.viewType = FB.FMList.LIST_VIEW
                                    }

                                    settings.viewType = FB.FMList.LIST_VIEW
                                }
                            }

                            MenuItem
                            {
                                text: i18n("Grid")
                                icon.name: "view-list-icons"
                                checked:  currentBrowser.settings.viewType === FB.FMList.ICON_VIEW
                                checkable: true
                                autoExclusive: true

                                onTriggered:
                                {
                                    if(currentBrowser)
                                    {
                                        currentBrowser.settings.viewType = FB.FMList.ICON_VIEW
                                    }

                                    settings.viewType = FB.FMList.ICON_VIEW
                                }
                            }

                            Maui.ContextualMenu
                            {
                                title: i18n("Sort by")
                                titleIconSource: "view-sort"

                                Action
                                {
                                    text: i18n("Type")
                                    checked: currentBrowser.settings.sortBy === FB.FMList.MIME
                                    checkable: true

                                    onTriggered:
                                    {
                                        currentBrowser.settings.sortBy = FB.FMList.MIME
                                        sortSettings.sortBy = FB.FMList.MIME
                                    }
                                }

                                Action
                                {
                                    text: i18n("Date")
                                    checked: currentBrowser.settings.sortBy === FB.FMList.DATE
                                    checkable: true
                                    onTriggered:
                                    {
                                        currentBrowser.settings.sortBy = FB.FMList.DATE
                                        sortSettings.sortBy = FB.FMList.DATE
                                    }
                                }

                                Action
                                {
                                    text: i18n("Modified")
                                    checked: currentBrowser.settings.sortBy === FB.FMList.MODIFIED
                                    checkable: true
                                    onTriggered:
                                    {
                                        currentBrowser.settings.sortBy = FB.FMList.MODIFIED
                                        sortSettings.sortBy = FB.FMList.MODIFIED
                                    }
                                }

                                Action
                                {
                                    text: i18n("Size")
                                    checked: currentBrowser.settings.sortBy === FB.FMList.SIZE
                                    checkable: true
                                    onTriggered:
                                    {
                                        currentBrowser.settings.sortBy = FB.FMList.SIZE
                                        sortSettings.sortBy = FB.FMList.SIZE
                                    }
                                }

                                Action
                                {
                                    text: i18n("Name")
                                    checked:  currentBrowser.settings.sortBy === FB.FMList.LABEL
                                    checkable: true
                                    onTriggered:
                                    {
                                        currentBrowser.settings.sortBy = FB.FMList.LABEL
                                        sortSettings.sortBy = FB.FMList.LABEL
                                    }
                                }

                                MenuSeparator{}

                                MenuItem
                                {
                                    text: i18n("Show Folders First")
                                    checked: currentBrowser.settings.foldersFirst
                                    checkable: true

                                    onTriggered:
                                    {
                                        currentBrowser.settings.foldersFirst = !currentBrowser.settings.foldersFirst
                                        sortSettings.foldersFirst =  !sortSettings.foldersFirst
                                    }
                                }

                                MenuItem
                                {
                                    id: groupAction
                                    text: i18n("Group")
                                    checkable: true
                                    checked: currentBrowser.settings.group
                                    onTriggered:
                                    {
                                        currentBrowser.settings.group = !currentBrowser.settings.group
                                        sortSettings.group = !sortSettings.group
                                    }
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

                    headBar.farLeftContent: Loader
                    {
                        asynchronous: true
                        sourceComponent: ToolButton
                        {
                            icon.name: _sideBarView.sideBar.visible ? "sidebar-collapse" : "sidebar-expand"
                            onClicked: _sideBarView.sideBar.toggle()
                            checked: _sideBarView.sideBar.visible
                            ToolTip.delay: 1000
                            ToolTip.timeout: 5000
                            ToolTip.visible: hovered
                            ToolTip.text: i18n("Toggle sidebar")
                        }
                    }

                    headBar.middleContent: Item
                    {
                        Layout.fillWidth: true
                        Layout.minimumWidth: 100
                        Layout.fillHeight: true

                        PathBar
                        {
                            id: _pathBar

                            anchors.centerIn: parent
                            width: Math.min(parent.width, implicitWidth)
                            onPathChanged: currentBrowser.openFolder(path)
                            url: currentBrowser.currentPath

                            onHomeClicked: currentBrowser.openFolder(FB.FM.homePath())
                            onPlaceClicked:
                            {
                                if(path === currentBrowser.currentPath)
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

                            //                    onMenuClicked: openMenu()

                            function openMenu()
                            {
                                _mainMenuLoader.item.open()
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
                        }
                    }
                }

                Loader
                {
                    id: _homeViewComponent
                    asynchronous: true
                    visible: StackView.status === StackView.Active
                    active: StackView.status === StackView.Active || item

                    sourceComponent: HomeView {}

                    BusyIndicator
                    {
                        running: parent.status === Loader.Loading
                        anchors.centerIn: parent
                    }
                }
            }
        }
    }

    Component.onCompleted:
    {
        setAndroidStatusBarColor()

        if(settings.overviewStart)
        {
            root.openTab(FB.FM.homePath())

            _stackView.push(_homeViewComponent)
            return
        }

        if(initPaths.length)
        {
            for(var path of initPaths)
                root.openTab(path)
            return;
        }

        const tabs = settings.lastSession
        if(settings.restoreSession && tabs.length)
        {
            console.log("restore", tabs.length)
            restoreSession(tabs)
            return
        }

        root.openTab(FB.FM.homePath())
    }

    function setAndroidStatusBarColor()
    {
        if(Maui.Handy.isAndroid)
        {
            Maui.Android.statusbarColor( Maui.Theme.backgroundColor, !appSettings.darkMode)
            Maui.Android.navBarColor( Maui.Theme.backgroundColor, !appSettings.darkMode)
        }
    }

    function toogleSplitView()
    {
        if(currentTab.count === 2)
            currentTab.pop()
        else
            currentTab.split(currentBrowser.currentPath, Qt.Horizontal)
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

    function openDirs(paths)
    {
        for(var path of paths)
            root.openTab(path)
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

        dialogLoader.sourceComponent = _tagsDialogComponent
        dialog.composerList.urls =urls
        dialog.open()
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

        if(Maui.Handy.isAndroid)
        {
            FB.FM.openUrl(urls[0])
            return
        }

        dialogLoader.sourceComponent = _openWithDialogComponent
        dialog.urls = urls
        dialog.open()
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

    function toggleSection(section)
    {
        placesSidebar.list.toggleSection(section)
        appSettings.sidebarSections = placesSidebar.list.groups
    }

    function isUrlOpen(url : string) : bool
    {
        return _browserView.isUrlOpen(url);
    }
    }
