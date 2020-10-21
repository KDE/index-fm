// Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2018-2020 Nitrux Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQml 2.14
import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3

import org.kde.kirigami 2.7 as Kirigami
import org.kde.mauikit 1.2 as Maui
import org.maui.index 1.0 as Index
import Qt.labs.settings 1.0

import QtQml.Models 2.3

import "widgets"
import "widgets/views"
import "widgets/previewer"

Maui.ApplicationWindow
{
    id: root
    title:  currentTab ? currentTab.title : ""

    readonly property url currentPath : currentBrowser ?  currentBrowser.currentPath : ""
    readonly property Maui.FileBrowser currentBrowser : currentTab && currentTab.browser ? currentTab.browser : null

    property alias dialog : dialogLoader.item
    property alias previewer : _previewer
    property alias selectionBar : _selectionBar
    property alias openWithDialog : _openWithDialog
    property alias tagsDialog : _tagsDialog
    property alias currentTabIndex : _browserList.currentIndex
    property alias currentTab : _browserList.currentItem
    property alias appSettings : settings

    property bool selectionMode: false
    property int iconSize : Maui.FM.loadSettings("ICONSIZE", "UI", Maui.Style.iconSizes.large)

    Settings
    {
        id: settings
        category: "Browser"
        property bool showHiddenFiles: false
        property bool showThumbnails: true
        property bool singleClick : Kirigami.Settings.isMobile ? true : Maui.Handy.singleClick
        property bool previewFiles : Kirigami.Settings.isMobile
        property bool restoreSession:  false
        property bool stickSidebar :  !Kirigami.Settings.isMobile
        property bool supportSplit : !Kirigami.Settings.isMobile
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
            }

            tabs.push(tabPaths)
        }

        Maui.FM.saveSettings("LAST_SESSION", tabs, "BROWSER")
        Maui.FM.saveSettings("LAST_TAB_INDEX", _browserList.currentIndex, "BROWSER")
        close.accepted = true
    }

    floatingHeader: false
    flickable: currentBrowser.flickable
    mainMenu: [Action
        {
            text: i18n("Settings")
            icon.name: "settings-configure"
            onTriggered: openConfigDialog()
        }]

    FilePreviewer {id: _previewer}

    Maui.TagsDialog
    {
        id: _tagsDialog
        taglist.strict: false
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
            message: i18n("Extract the content of the compressed file into a  new or existing subdirectory or inside the current directory.")
            entryField: true
            page.margins: Maui.Style.space.big

            onAccepted:
            {
                _compressedFile.extract(currentPath, textEntry.text)
                _extractDialog.close()
            }
        }
    }

    Index.CompressedFile
    {
        id: _compressedFile
    }

    headBar.rightContent: ToolButton
    {
        id: _selectButton
        visible: Maui.Handy.isTouch
        icon.name: "item-select"
        checkable: true
        checked: root.selectionMode
        onClicked: root.selectionMode = !root.selectionMode
        onPressAndHold: currentBrowser.selectAll()
    }

    headBar.middleContent: Maui.PathBar
    {
        id: _pathBar
        Layout.fillWidth: true
        Layout.minimumWidth: 100
        Layout.maximumWidth: 500
        //        Layout.leftMargin: Maui.Style.space.medium
        //        Layout.rightMargin: Maui.Style.space.medium

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
    }

    Loader
    {
        id: dialogLoader
    }

    sideBar: PlacesSideBar
    {
        id: placesSidebar
    }

    ObjectModel { id: tabsObjectModel }
    ColumnLayout
    {
        anchors.fill: parent
        spacing: 0

        Maui.TabBar
        {
            id: tabsBar
            visible: _browserList.count > 1
            Layout.fillWidth: true
            Layout.preferredHeight: tabsBar.implicitHeight
            position: TabBar.Header
            currentIndex : _browserList.currentIndex
            onNewTabClicked: root.openTab(currentPath)
            Keys.onPressed:
            {
                if(event.key == Qt.Key_Return)
                {
                    _browserList.currentIndex = currentIndex
                }

                if(event.key == Qt.Key_Down)
                {
                    currentBrowser.currentView.forceActiveFocus()
                }
            }

            Repeater
            {
                id: _repeater
                model: tabsObjectModel.count

                Maui.TabButton
                {
                    id: _tabButton
                    implicitHeight: tabsBar.implicitHeight
                    implicitWidth: Math.max(parent.width / _repeater.count, 120)
                    checked: index === _browserList.currentIndex
                    template.iconSource: "folder"
                    template.iconSizeHint: 16
                    text: tabsObjectModel.get(index).title

                    onClicked:
                    {
                        _browserList.currentIndex = index
                    }

                    onCloseClicked: closeTab(index)

                    DropArea
                    {
                        id: _dropArea
                        anchors.fill: parent
                        onEntered: _browserList.currentIndex = index
                    }
                }
            }
        }

        Maui.Page
        {
            Layout.fillHeight: true
            Layout.fillWidth: true
            altHeader: Kirigami.Settings.isMobile
            flickable: root.flickable
            floatingFooter: true
            floatingHeader: false
            headBar.rightContent:[

                ToolButton
                {
                    visible: currentTab && currentTab.currentItem ? currentTab.currentItem.supportsTerminal : false
                    icon.name: "utilities-terminal"
                    onClicked: currentTab.currentItem.toogleTerminal()
                    checked : currentTab && currentBrowser ? currentTab.currentItem.terminalVisible : false
                    checkable: true
                },

                Maui.ToolButtonMenu
                {
                    visible: !sortSettings.globalSorting
                    icon.name: "view-sort"

                    MenuItem
                    {
                        text: i18n("Show Folders First")
                        checked: currentBrowser.currentFMList.foldersFirst
                        checkable: true
                        onTriggered: currentBrowser.currentFMList.foldersFirst = !currentBrowser.currentFMList.foldersFirst
                    }

                    MenuSeparator {}

                    MenuItem
                    {
                        text: i18n("Type")
                        checked:currentBrowser.currentFMList.sortBy === Maui.FMList.MIME
                        checkable: true
                        onTriggered: currentBrowser.currentFMList.sortBy = Maui.FMList.MIME
                        autoExclusive: true
                    }

                    MenuItem
                    {
                        text: i18n("Date")
                        checked:currentBrowser.currentFMList.sortBy === Maui.FMList.DATE
                        checkable: true
                        onTriggered: currentBrowser.currentFMList.sortBy = Maui.FMList.DATE
                        autoExclusive: true
                    }

                    MenuItem
                    {
                        text: i18n("Modified")
                        checkable: true
                        checked: currentBrowser.currentFMList.sortBy === Maui.FMList.MODIFIED
                        onTriggered: currentBrowser.currentFMList.sortBy = Maui.FMList.MODIFIED
                        autoExclusive: true
                    }

                    MenuItem
                    {
                        text: i18n("Size")
                        checkable: true
                        checked: currentBrowser.currentFMList.sortBy === Maui.FMList.SIZE
                        onTriggered: currentBrowser.currentFMList.sortBy = Maui.FMList.SIZE
                        autoExclusive: true
                    }

                    MenuItem
                    {
                        text: i18n("Name")
                        checkable: true
                        checked: currentBrowser.currentFMList.sortBy === Maui.FMList.LABEL
                        onTriggered: currentBrowser.currentFMList.sortBy = Maui.FMList.LABEL
                        autoExclusive: true
                    }

                    MenuSeparator{}

                    MenuItem
                    {
                        id: groupAction
                        text: i18n("Group")
                        checkable: true
                        checked: currentBrowser.settings.group
                        onTriggered:
                        {
                            currentBrowser.settings.group = !currentBrowser.settings.group
                        }
                    }
                },

                ToolButton
                {
                    visible: settings.supportSplit
                    icon.name: currentTab.orientation === Qt.Horizontal ? "view-split-left-right" : "view-split-top-bottom"
                    checked: currentTab.count == 2
                    autoExclusive: true
                    onClicked: toogleSplitView()
                },

                ToolButton
                {
                    icon.name: "edit-find"
                    checked: currentBrowser.headBar.visible
                    onClicked:
                    {
                        currentBrowser.headBar.visible = !currentBrowser.headBar.visible
                    }
                },

                ToolButton
                {
                    id: _optionsButton
                    icon.name: "overflow-menu"
                    enabled: root.currentBrowser && root.currentBrowser.currentFMList.pathType !== Maui.FMList.TAGS_PATH && root.currentBrowser.currentFMList.pathType !== Maui.FMList.TRASH_PATH && root.currentBrowser.currentFMList.pathType !== Maui.FMList.APPS_PATH
                    onClicked:
                    {
                        if(currentBrowser.browserMenu.visible)
                            currentBrowser.browserMenu.close()
                        else
                            currentBrowser.browserMenu.show(_optionsButton, 0, height)
                    }
                    checked: currentBrowser.browserMenu.visible
                    checkable: false
                }
            ]

            headBar.farLeftContent: ToolButton
            {
                icon.name: "bookmarks"
                checked: placesSidebar.position == 1
                visible: !placesSidebar.stick
                onClicked: placesSidebar.visible = checked
            }

            headBar.leftContent: [

                Maui.ToolActions
                {
                    expanded: true
                    autoExclusive: false
                    checkable: false

                    Action
                    {
                        text: i18n("Previous")
                        icon.name: "go-previous"
                        onTriggered : currentBrowser.goBack()
                    }

                    Action
                    {
                        text: i18n("Next")
                        icon.name: "go-next"
                        onTriggered: currentBrowser.goNext()
                    }
                },

                Maui.ToolActions
                {
                    id: _viewTypeGroup
                    autoExclusive: true
                    cyclic: true
                    expanded: headBar.width > Kirigami.Units.gridUnit * 32

                    Binding on currentIndex
                    {
                        value: currentBrowser ? currentBrowser.settings.viewType : -1
                        //                    restoreMode: Binding.RestoreBinding
                        delayed: true
                    }

                    display: ToolButton.TextBesideIcon
                    onCurrentIndexChanged:
                    {
                        if(currentTab && currentBrowser)
                        currentBrowser.settings.viewType = currentIndex

                        Maui.FM.saveSettings("VIEW_TYPE", currentIndex, "BROWSER")
                    }

                    Action
                    {
                        icon.name: "view-list-icons"
                        text: i18n("Grid")
                        shortcut: "Ctrl+G"
                    }

                    Action
                    {
                        icon.name: "view-list-details"
                        text: i18n("List")
                        shortcut: "Ctrl+L"
                    }

                    //                    Action
                    //                    {
                    //                        icon.name: "view-file-columns"
                    //                        text: i18n("Columns")
                    //                        shortcut: "Ctrl+M"
                    //                    }
                }
            ]

            footer: Maui.SelectionBar
            {
                id: _selectionBar

                padding: Maui.Style.space.big
                anchors.horizontalCenter: parent.horizontalCenter
                width: Math.min(parent.width-(Maui.Style.space.medium*2), implicitWidth)
                maxListHeight: _browserList.height - (Maui.Style.contentMargins*2)

                onCountChanged:
                {
                    if(_selectionBar.count < 1)
                    {
                        root.selectionMode = false
                    }
                }

                onUrisDropped:
                {
                    for(var i in uris)
                    {
                        if(!Maui.FM.fileExists(uris[i]))
                            continue;

                        const item = Maui.FM.getFileInfo(uris[i])
                        _selectionBar.append(item.path, item)
                    }
                }

                onExitClicked: clear()

                listDelegate: Maui.ListBrowserDelegate
                {
                    isCurrentItem: false
                    Kirigami.Theme.inherit: true
                    width: ListView.view.width
                    height: Maui.Style.iconSizes.big + Maui.Style.space.big
                    imageSource: root.showThumbnails ? model.thumbnail : ""
                    iconSource: model.icon
                    label1.text: model.label
                    label2.text: model.path
                    label3.text: ""
                    label4.text: ""
                    checkable: true
                    checked: true
                    iconSizeHint: Maui.Style.iconSizes.big
                    onToggled: _selectionBar.removeAtIndex(index)
                    background: Item {}
                    onClicked:
                    {
                        _selectionBar.selectionList.currentIndex = index
                        _previewer.show(_selectionBar.selectionList.model, _selectionBar.selectionList.currentIndex )
                    }

                    onPressAndHold: removeAtIndex(index)
                }

                Action
                {
                    text: i18n("Open")
                    icon.name: "document-open"
                    onTriggered:
                    {
                        for(var i in selectionBar.uris)
                            currentBrowser.openFile(_selectionBar.uris[i])
                    }
                }

                Action
                {
                    text: i18n("Tags")
                    icon.name: "tag"
                    onTriggered:
                    {
                        currentBrowser.tagFiles(_selectionBar.uris)
                    }
                }

                Action
                {
                    text: i18n("Share")
                    icon.name: "document-share"
                    onTriggered:
                    {
                        Maui.Platform.shareFiles(_selectionBar.uris)
                    }
                }

                Action
                {
                    text: i18n("Copy")
                    icon.name: "edit-copy"
                    onTriggered:
                    {
                        _selectionBar.animate()
                        currentBrowser.copy(_selectionBar.uris)
                    }
                }

                Action
                {
                    text: i18n("Cut")
                    icon.name: "edit-cut"
                    onTriggered:
                    {
                        _selectionBar.animate()
                        currentBrowser.cut(_selectionBar.uris)
                    }
                }

                Action
                {
                    text: i18n("Remove")
                    icon.name: "edit-delete"

                    onTriggered:
                    {
                        currentBrowser.remove(_selectionBar.uris)
                    }
                }
            }

            ListView
            {
                id: _browserList
                anchors.fill: parent

                clip: true
                focus: true
                orientation: ListView.Horizontal
                model: tabsObjectModel
                snapMode: ListView.SnapOneItem
                spacing: 0
                interactive: Kirigami.Settings.hasTransientTouchInput && tabsObjectModel.count > 1
                highlightFollowsCurrentItem: true
                highlightMoveDuration: 0
                highlightResizeDuration: 0
                highlightRangeMode: ListView.StrictlyEnforceRange
                preferredHighlightBegin: 0
                preferredHighlightEnd: width
                highlight: Item {}
                highlightMoveVelocity: -1
                highlightResizeVelocity: -1

                onMovementEnded: _browserList.currentIndex = indexAt(contentX, contentY)
                boundsBehavior: Flickable.StopAtBounds

                onCurrentItemChanged:
                {
                    if(currentBrowser)
                    {
                        currentBrowser.currentView.forceActiveFocus()
                    }
                }

                DropArea
                {
                    id: _dropArea
                    anchors.fill: parent
                    z: parent.z -2
                    onDropped:
                    {
                        const urls = drop.urls
                        for(var i in urls)
                        {
                            const item = Maui.FM.getFileInfo(urls[i])
                            if(item.isdir == "true")
                            {
                                control.openTab(urls[i])
                            }
                        }
                    }
                }
            }
        }

        ProgressBar
        {
            id: _progressBar
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignBottom
            Layout.preferredHeight: visible ? Maui.Style.iconSizes.medium : 0
            visible: value > 0
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
        if(settings.restoreSession)
        {
            var session = Maui.FM.loadSettings("LAST_SESSION", "BROWSER", [[{path: Maui.FM.homePath(), viewType: 1}]])

            for(var i in session)
            {
                const tab = session[i];
                if(tab.length === 2)
                {
                    root.openTab(tab[0].path)
                    currentBrowser.settings.viewType = tab[0].viewType
                    currentTab.split(tab[1].path, Qt.Horizontal)
                    currentBrowser.settings.viewType = tab[1].viewType
                }else
                {
                    root.openTab(tab[0].path)
                    currentBrowser.settings.viewType = tab[0].viewType
                }
            }

            const lastTabIndex = Maui.FM.loadSettings("LAST_TAB_INDEX", "BROWSER", _browserList.currentIndex)
            _browserList.currentIndex = lastTabIndex

        }else
        {
            root.openTab(Maui.FM.homePath())
            currentBrowser.settings.viewType = Maui.FM.loadSettings("VIEW_TYPE", "BROWSER", Maui.FMList.LIST_VIEW)
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
            if(String(path) === placesSidebar.list.get(i).path)
            {
                placesSidebar.currentIndex = i
                return;
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
            const component = Qt.createComponent("qrc:/widgets/views/BrowserLayout.qml");

            if (component.status === Component.Ready)
            {
                const object = component.createObject(tabsObjectModel, {'path': path});
                tabsObjectModel.append(object)
                _browserList.currentIndex = tabsObjectModel.count - 1
            }
        }
    }

    function setIconSize(size)
    {
        root.iconSize = size
        Maui.FM.saveSettings("ICONSIZE",  root.iconSize, "UI")
    }
}
