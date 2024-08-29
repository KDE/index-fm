// Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2018-2020 Nitrux Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtCore

import QtQuick.Controls
import QtQuick.Layouts

import org.mauikit.controls as Maui

import org.mauikit.filebrowsing as FB
import org.mauikit.archiver as Arc
import org.maui.index as Index

import "widgets"
import "widgets/views"
import "widgets/previewer"

Maui.ApplicationWindow
{
    id: root
    title: currentTab ? currentTab.title : ""

    Maui.Style.accentColor : Maui.Handy.isAndroid ? "#6765C2": undefined

    readonly property alias dialog : dialogLoader.item
    readonly property alias selectionBar : _browserView.selectionBar
    readonly property alias pathBar: _pathBarLoader.item

    readonly property alias currentTab : _browserView.currentTab
    readonly property alias currentSplit : _browserView.currentSplit
    readonly property FB.FileBrowser currentBrowser : currentSplit.browser

    readonly property alias appSettings : settings

    property alias currentTabIndex : _browserView.currentTabIndex
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

        property int viewType : FB.FMList.LIST_VIEW
        property int listSize : 0 // s-m-l-x-xl
        property int gridSize : 3 // s-m-l-x-xl

        property var lastSession : [[({'path': FB.FM.homePath()})]]
        property int lastTabIndex : 0

        property bool quickSidebarSection : true
        property var sidebarSections : [
            FB.FMList.BOOKMARKS_PATH,
            FB.FMList.REMOTE_PATH,
            FB.FMList.REMOVABLE_PATH,
            FB.FMList.DRIVES_PATH]


        property alias sideBarWidth : _sideBarView.sideBar.preferredWidth

        property bool dirConf : true
        property bool syncTerminal: true
        property bool previewerWindow: Maui.Handy.isLinux && !Maui.Handy.isMobile
        property bool autoPlayPreviews: true
        property bool terminalFollowsColorScheme: true
        property string terminalColorScheme: "Maui-Dark"
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

    onClosing: (close) =>
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
                           const tabMap = {'path': browser.currentPath}
                           tabPaths.push(tabMap)

                           console.log("saving tabs", browser.currentPath)

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

            onTagsReady: (tags) =>
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

        Arc.ExtractDialog
        {
            destination:  currentBrowser.currentPath
        }
    }

    Component
    {
        id: _compressDialogComponent

        Arc.NewArchiveDialog
        {
            id: _compressDialog
            destination: currentBrowser.currentPath
            onDone: _compressDialog.compress()
        }
    }

    Component
    {
        id: _previewerComponent

        PreviewerDialog
        {
            onClosed:
            {
                dialogLoader.sourceComponent = null
            }
        }
    }

    Component
    {
        id: _previewerWindowComponent
        PreviewerWindow
        {
            onClosing: destroy()
        }
    }

    Component
    {
        id: _browserComponent
        BrowserLayout {}
    }

    // Maui.NotifyAction
    // {
    //     id: _extractionFinishedAction
    //     text: i18n("Open folder")
    // }

    // Index.CompressedFile
    // {
    //     id: _compressedFile

    //     onExtractionFinished:
    //     {
    //         _notifyOperation.title = i18n("Extracted")
    //         _notifyOperation.message = i18n("File was extracted")
    //         _notifyOperation.defaultAction = _extractionFinishedAction
    //         _notifyOperation.iconName = "application-x-archive"
    //         _notifyOperation.send()
    //     }
    // }

    Loader
    {
        id: dialogLoader
    }

    Maui.SideBarView
    {
        id: _sideBarView
        anchors.fill: parent
        sideBar.preferredWidth: 200

        sideBar.minimumWidth: 200
        sideBar.autoShow: true
        sideBar.autoHide: true
        sideBarContent: PlacesSideBar
        {
            id: placesSidebar
            anchors.fill: parent
        }

        Maui.PageLayout
        {
            anchors.fill: parent

            split: width < 800
            splitIn: ToolBar.Header

            altHeader: Maui.Handy.isMobile
            Maui.Controls.showCSD: true

            headBar.visible: !_homeViewComponent.visible
            headBar.forceCenterMiddleContent: width > 1000

            leftContent:  [

                Loader
                {
                    asynchronous: true
                    active: _sideBarView.sideBar.collapsed
                    visible: active

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
                },

                Maui.ToolActions
                {
                    autoExclusive: false
                    checkable: false
                    display: ToolButton.IconOnly

                    Action
                    {
                        icon.name: "go-previous"
                        onTriggered : currentBrowser.goBack()
                    }

                    Action
                    {
                        icon.name: "go-next"
                        onTriggered : currentBrowser.goForward()
                    }
                },

                Maui.ToolActions
                {
                    autoExclusive: true
                    expanded: root.isWide
                    cyclic: true
                    display: ToolButton.IconOnly

                    Action
                    {
                        text: i18n("List")
                        icon.name: "view-list-details"
                        checked: currentBrowser.viewType === FB.FMList.LIST_VIEW
                        checkable: true
                        onTriggered:
                        {
                            if(currentBrowser)
                            {
                                currentBrowser.viewType = FB.FMList.LIST_VIEW
                            }
                        }
                    }

                    Action
                    {
                        text: i18n("Grid")
                        icon.name: "view-list-icons"
                        checked:  currentBrowser.viewType === FB.FMList.ICON_VIEW
                        checkable: true

                        onTriggered:
                        {
                            if(currentBrowser)
                            {
                                currentBrowser.viewType = FB.FMList.ICON_VIEW
                            }
                        }
                    }
                }
            ]

            rightContent: [

                ToolButton
                {
                    icon.name: "edit-find"
                    checked: currentBrowser.headBar.visible
                    checkable: true
                    onClicked: currentBrowser.toggleSearchBar()
                },

                Loader
                {
                    id: _mainMenuLoader

                    asynchronous: true
                    sourceComponent: Maui.ToolButtonMenu
                    {
                        id: _mainMenu
                        icon.name:  "overflow-menu"

                        property bool canPaste: false
                        menu.onOpened: canPaste = currentBrowser.currentFMList.clipboardHasContent()

                        MenuItem
                        {
                            text: i18n("Paste")
                            enabled: _mainMenu.canPaste

                            icon.name: "edit-paste"
                            onTriggered: currentBrowser.paste()
                        }

                        MenuItem
                        {
                            text: i18n("Select All")
                            icon.name: "edit-select-all"
                            onTriggered: currentBrowser.selectAll()
                        }

                        MenuItem
                        {
                            text: i18n("New Item")
                            icon.name: "folder-new"
                            onTriggered: currentBrowser.newItem()
                        }

                        Menu
                        {
                            icon.name: "view-sort"
                            title: i18n("Sort")

                            MenuItem
                            {
                                text: i18n("Type")
                                checked: currentBrowser.sortBy === FB.FMList.MIME
                                checkable: true
                                autoExclusive: true
                                onTriggered:
                                {
                                    currentBrowser.sortBy = FB.FMList.MIME
                                }
                            }

                            MenuItem
                            {
                                text: i18n("Date")
                                checked: currentBrowser.sortBy === FB.FMList.DATE
                                checkable: true
                                autoExclusive: true

                                onTriggered:
                                {
                                    currentBrowser.sortBy = FB.FMList.DATE
                                }
                            }

                            MenuItem
                            {
                                text: i18n("Modified")
                                checked: currentBrowser.sortBy === FB.FMList.MODIFIED
                                checkable: true
                                autoExclusive: true

                                onTriggered:
                                {
                                    currentBrowser.sortBy = FB.FMList.MODIFIED
                                }
                            }

                            MenuItem
                            {
                                text: i18n("Size")
                                checked: currentBrowser.sortBy === FB.FMList.SIZE
                                checkable: true
                                autoExclusive: true

                                onTriggered:
                                {
                                    currentBrowser.sortBy = FB.FMList.SIZE
                                }
                            }

                            MenuItem
                            {
                                text: i18n("Name")
                                checked: currentBrowser.sortBy === FB.FMList.LABEL
                                checkable: true
                                autoExclusive: true

                                onTriggered:
                                {
                                    currentBrowser.sortBy = FB.FMList.LABEL
                                }
                            }
                        }

                        MenuSeparator {}

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
                                text: i18n("View Hidden")
                                checkable: true
                                checked: settings.showHiddenFiles
                                onTriggered: settings.showHiddenFiles = !settings.showHiddenFiles
                            }

                            Action
                            {
                                text: i18n("Split View")
                                icon.name: currentTab.orientation === Qt.Horizontal ? "view-split-left-right" : "view-split-top-bottom"
                                checked: currentTab.count === 2
                                checkable: true
                                onTriggered: toogleSplitView()
                            }

                            Action
                            {
                                text: i18n("Terminal")
                                enabled: !Maui.Handy.isAndroid && currentTab && currentTab.currentItem ? currentTab.currentItem.supportsTerminal : false
                                icon.name: "dialog-scripts"
                                checked : currentTab && currentBrowser ? currentTab.currentItem.terminalVisible : false
                                checkable: true

                                onTriggered: currentTab.currentItem.toogleTerminal()
                            }
                        }

                        MenuItem
                        {
                            enabled: Maui.Handy.isLinux && !Maui.Handy.isMobile
                            text: i18n("Open Terminal Here")
                            id: openTerminal
                            icon.name: "dialog-scripts"
                            onTriggered:
                            {
                                inx.openTerminal(currentBrowser.currentPath)
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
                            onTriggered: Maui.App.aboutDialog()
                        }
                    }
                }
            ]

            headBar.middleContent: Loader
            {
                id: _pathBarLoader

                asynchronous: true

                Layout.fillWidth: true
                Layout.minimumWidth: 100


                sourceComponent: Item
                {
                    implicitHeight: _pathBar.implicitHeight
                    readonly property alias pathBar: _pathBar

                    OpacityAnimator on opacity
                    {
                        from: 0
                        to: 1
                        duration: Maui.Style.units.longDuration
                        running: parent.visible
                    }

                    PathBar
                    {
                        id: _pathBar

                        anchors.centerIn: parent
                        width: Math.min(parent.width, implicitWidth)

                        url: currentBrowser.currentPath

                        onPathChanged: (path) => currentBrowser.openFolder(path)

                        onHomeClicked: currentBrowser.openFolder(FB.FM.homePath())
                        onPlaceClicked: (path) =>
                                        {
                                            if(path === currentBrowser.currentPath)
                                            {
                                                popupMainMenu()
                                            }
                                            else
                                            {
                                                currentBrowser.openFolder(path)
                                            }
                                        }

                        onPlaceRightClicked: (path) =>
                                             {
                                                 _pathBarmenu.path = path
                                                 _pathBarmenu.show()
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
                                text: i18n("Open in New Tab")
                                icon.name: "tab-new"
                                onTriggered: openTab(_pathBarmenu.path)
                            }

                            MenuItem
                            {
                                visible: root.currentTab.count === 1
                                text: i18n("Open in Split View")
                                icon.name: "view-split-left-right"
                                onTriggered: currentTab.split(_pathBarmenu.path, Qt.Horizontal)
                            }
                        }
                    }
                }
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

    function openTab(path, path2 = "")
    {
        if(path)
        {
            if(_stackView.depth === 2)
                _stackView.pop()


            _browserView.browserList.addTab(_browserComponent, {'path': path, 'path2': path2}, false)
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
     * Add the file urls to the selection
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

    function openPreview(url)
    {
        if(appSettings.previewerWindow)
        {
            var previewer = _previewerWindowComponent.createObject(root)
            previewer.previewer.setData(url)
        }else
        {
            dialogLoader.sourceComponent = _previewerComponent
            dialog.previewer.setData(url)
            dialog.open()
        }
    }

    function restoreSession(tabs)
    {
        for(var i = 0; i < tabs.length; i++ )
        {
            const tab = tabs[i]

            if(tab.length === 2)
            {
                root.openTab(tab[0].path, tab[1].path)
            }else
            {
                root.openTab(tab[0].path)
            }
        }

        currentTabIndex = settings.lastTabIndex
    }

    /**
      * Remove or add a sidebar section
      */
    function toggleSection(section)
    {
        placesSidebar.list.toggleSection(section)
        appSettings.sidebarSections = placesSidebar.list.groups
    }

    function isUrlOpen(url : string) : bool
    {
        return _browserView.isUrlOpen(url);
    }

    /**
      * Open menu in the menu button position
     */
    function openMainMenu()
    {
        _mainMenuLoader.item.open()
    }

    /**
      * Open menu in  the cursor position
      */
    function popupMainMenu()
    {
        _mainMenuLoader.item.popup()
    }
}
