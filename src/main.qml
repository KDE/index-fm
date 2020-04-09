import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.7 as Kirigami
import org.kde.mauikit 1.0 as Maui
import org.kde.mauikit 1.1 as MauiLab
import QtQml.Models 2.3

import "widgets"
import "widgets/views"

Maui.ApplicationWindow
{
    id: root
    title:  currentTab ? currentTab.title : ""
    Maui.App.description: qsTr("Index allows you to navigate your computer and preview multimedia files.")
    Maui.App.iconName: "qrc:/assets/index.svg"
    Maui.App.webPage: "https://mauikit.org"
    Maui.App.donationPage: "https://invent.kde.org/kde/index-fm"
    Maui.App.reportPage: "https://github.com/Nitrux/maui"
    //    Maui.App.enableCSD: true


//    property alias terminal : terminalLoader.item
    property alias dialog : dialogLoader.item

    property alias previewer : _previewer
    property alias selectionBar : _selectionBar
    property alias shareDialog : _shareDialog
    property alias openWithDialog : _openWithDialog
    property alias tagsDialog : _tagsDialog
    property alias currentTabIndex : _browserList.currentIndex
    property alias currentTab : _browserList.currentItem
    readonly property Maui.FileBrowser currentBrowser : currentTab && currentTab.browser ? currentTab.browser : null
    property bool searchBar: false
    property bool selectionMode: false
    property bool showHiddenFiles: false
    property bool showThumbnails: true
    property bool showStatusBar: false
    property bool singleClick : Maui.FM.loadSettings("SINGLE_CLICK", "BROWSER", Kirigami.Settings.isMobile ? true : Maui.Handy.singleClick) == "true"
    property bool restoreSession: Maui.FM.loadSettings("RESTORE_SESSION", "BROWSER", false) == "true"
    property bool supportSplit :!Kirigami.Settings.isMobile && root.width > 600
    readonly property url currentPath : currentBrowser ?  currentBrowser.currentPath : ""

    onCurrentPathChanged:
    {
        syncSidebar(currentBrowser.currentPath)
    }

    onCurrentBrowserChanged:
    {
        _viewTypeGroup.currentIndex = currentBrowser.settings.viewType
    }

    onClosing:
    {
        close.accepted = !root.restoreSession
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

    flickable: currentTab && currentBrowser ? currentBrowser.flickable : null

    mainMenu: [MenuItem
        {
            text: qsTr("Settings")
            icon.name: "settings-configure"
            onTriggered: openConfigDialog()
        }]

    Maui.FilePreviewer {id: _previewer}
    Maui.TagsDialog
    {
        id: _tagsDialog
        taglist.strict: false
    }

    MauiLab.ShareDialog {id: _shareDialog}
    Maui.OpenWithDialog {id: _openWithDialog}

    Component
    {
        id: _configDialogComponent

        Maui.Dialog
        {
            maxHeight: _configLayout.implicitHeight * 1.5
            maxWidth: 300
            defaultButtons: false

            ColumnLayout
            {
                Layout.fillHeight: true
                Layout.fillWidth: true

                Kirigami.FormLayout
                {
                    id: _configLayout
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Item
                    {
                        Kirigami.FormData.label: qsTr("Navigation")
                        Kirigami.FormData.isSection: true
                    }

                    Switch
                    {
                        icon.name: "image-preview"
                        checkable: true
                        checked:  root.showThumbnails
                        Kirigami.FormData.label: qsTr("Show Thumbnails")
                        onToggled:  root.showThumbnails = ! root.showThumbnails
                    }

                    Switch
                    {
                        Kirigami.FormData.label: qsTr("Show Hidden Files")
                        checkable: true
                        checked:  root.showHiddenFiles
                        onToggled:  root.showHiddenFiles = !root.showHiddenFiles
                    }

                    Switch
                    {
                        Kirigami.FormData.label: qsTr("Single Click")
                        checkable: true
                        checked:  root.singleClick
                        onToggled:
                        {
                            root.singleClick = !root.singleClick
                            Maui.FM.saveSettings("SINGLE_CLICK",  root.singleClick, "BROWSER")
                        }
                    }

                    Switch
                    {
                        Kirigami.FormData.label: qsTr("Restore Session")
                        checkable: true
                        checked:  root.restoreSession
                        onToggled:
                        {
                            root.restoreSession = !root.restoreSession
                            Maui.FM.saveSettings("RESTORE_SESSION",  root.restoreSession, "BROWSER")
                        }
                    }

                    Item
                    {
                        Kirigami.FormData.label: qsTr("Interface")
                        Kirigami.FormData.isSection: true
                    }

                    Switch
                    {
                        Kirigami.FormData.label: qsTr("Show Status Bar")
                        checkable: true
                        checked:  root.showStatusBar
                        onToggled:  root.showStatusBar = !root.showStatusBar
                    }
                }
            }
        }
    }

    //    headBar.rightSretch: Maui.App.enableCSD
    headBar.rightContent: ToolButton
    {
        visible: Maui.Handy.isTouch
        icon.name: "item-select"
        checkable: true
        checked: root.selectionMode
        onClicked: root.selectionMode = !root.selectionMode
        onPressAndHold: currentBrowser.selectAll()
    }

    headBar.middleContent:  Maui.PathBar
    {
        id: _pathBar
        Layout.fillWidth: true
        Layout.leftMargin: Maui.Style.space.medium
        Layout.rightMargin: Maui.Style.space.medium

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
                text: qsTr("Open in tab")
                onTriggered: openTab(_pathBarmenu.path)
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
        collapsed : !root.isWide
        collapsible: true
        section.property: !showLabels ? "" : "type"
        preferredWidth: Math.min(Kirigami.Units.gridUnit * 11, root.width)
        height: root.height - root.header.height
        iconSize: collapsed ? Maui.Style.iconSizes.medium : Maui.Style.iconSizes.small

        Behavior on iconSize
        {
            NumberAnimation
            {
                duration: Kirigami.Units.longDuration
                easing.type: Easing.InOutQuad
            }
        }

        onPlaceClicked:
        {
            currentBrowser.openFolder(path)
            if(placesSidebar.modal)
                placesSidebar.collapse()
        }

        list.groups: [
            Maui.FMList.QUICK_PATH,
            Maui.FMList.PLACES_PATH,
            Maui.FMList.REMOTE_PATH,
            Maui.FMList.REMOVABLE_PATH,
            Maui.FMList.DRIVES_PATH,
            Maui.FMList.TAGS_PATH]

        itemMenu.contentData: [
            MenuItem
            {
                text: qsTr("Open in tab")
                onTriggered: openTab(placesSidebar.list.get(placesSidebar.currentIndex).path)
            }
        ]
    }

    ObjectModel { id: tabsObjectModel }
    Maui.Page
    {
        anchors.fill: parent
        headBar.position: Kirigami.Settings.isMobile ? ToolBar.Footer : ToolBar.Header
        headBar.rightContent:[

            ToolButton
            {
                visible: currentTab && currentTab.currentItem ? currentTab.currentItem.supportsTerminal : false
//                text: qsTr("Show Terminal")
                icon.name: "utilities-terminal"
                onClicked: currentTab.currentItem.toogleTerminal()
                checked : currentTab && currentBrowser ? currentTab.currentItem.terminalVisible : false
                checkable: true
            },

            Maui.ToolButtonMenu
            {
                icon.name: "view-sort"

                MenuItem
                {
                    text: qsTr("Show Folders First")
                    checked: currentBrowser.currentFMList.foldersFirst
                    checkable: true
                    onTriggered: currentBrowser.currentFMList.foldersFirst = !currentBrowser.currentFMList.foldersFirst
                }

                MenuSeparator {}

                MenuItem
                {
                    text: qsTr("Type")
                    checked:currentBrowser.currentFMList.sortBy === Maui.FMList.MIME
                    checkable: true
                    onTriggered: currentBrowser.currentFMList.sortBy = Maui.FMList.MIME
                    autoExclusive: true
                }

                MenuItem
                {
                    text: qsTr("Date")
                    checked:currentBrowser.currentFMList.sortBy === Maui.FMList.DATE
                    checkable: true
                    onTriggered: currentBrowser.currentFMList.sortBy = Maui.FMList.DATE
                    autoExclusive: true
                }

                MenuItem
                {
                    text: qsTr("Modified")
                    checkable: true
                    checked: currentBrowser.currentFMList.sortBy === Maui.FMList.MODIFIED
                    onTriggered: currentBrowser.currentFMList.sortBy = Maui.FMList.MODIFIED
                    autoExclusive: true
                }

                MenuItem
                {
                    text: qsTr("Size")
                    checkable: true
                    checked: currentBrowser.currentFMList.sortBy === Maui.FMList.SIZE
                    onTriggered: currentBrowser.currentFMList.sortBy = Maui.FMList.SIZE
                    autoExclusive: true
                }

                MenuItem
                {
                    text: qsTr("Name")
                    checkable: true
                    checked: currentBrowser.currentFMList.sortBy === Maui.FMList.LABEL
                    onTriggered: currentBrowser.currentFMList.sortBy = Maui.FMList.LABEL
                    autoExclusive: true
                }

                MenuSeparator{}

                MenuItem
                {
                    id: groupAction
                    text: qsTr("Group")
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

        headBar.leftContent: [

            Maui.ToolActions
            {
                expanded: true
                autoExclusive: false
                checkable: false

                Action
                {
                    icon.name: "go-previous"
                    onTriggered : currentBrowser.goBack()
                }

                Action
                {
                    icon.name: "go-next"
                    onTriggered: currentBrowser.goNext()
                }
            },

            Maui.ToolActions
            {
                id: _viewTypeGroup
                expanded: headBar.width > Kirigami.Units.gridUnit * 32
                currentIndex: Maui.FM.loadSettings("VIEW_TYPE", "BROWSER", Maui.FMList.LIST_VIEW)
                onCurrentIndexChanged:
                {
                    if(currentTab && currentBrowser)
                    currentBrowser.settings.viewType = currentIndex

                    Maui.FM.saveSettings("VIEW_TYPE", currentIndex, "BROWSER")
                }

                Action
                {
                    icon.name: "view-list-icons"
                    text: qsTr("Grid")
                    shortcut: "Ctrl+G"
                }

                Action
                {
                    icon.name: "view-list-details"
                    text: qsTr("List")
                    shortcut: "Ctrl+L"
                }

                Action
                {
                    icon.name: "view-file-columns"
                    text: qsTr("Columns")
                    shortcut: "Ctrl+M"
                }
            },

            ToolButton
            {
                visible: root.supportSplit
                icon.name: "view-split-left-right"
                checked: currentTab.count == 2
                autoExclusive: true
                onClicked: toogleSplitView()
            }
        ]

        ColumnLayout
        {
            id: _layout

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

                        text: tabsObjectModel.get(index).title

                        onClicked:
                        {
                            _browserList.currentIndex = index
                        }

                        onCloseClicked: closeTab(index)
                    }
                }
            }

            Flickable
            {
                Layout.margins: 0
                Layout.fillWidth: true
                Layout.fillHeight: true

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

            MauiLab.SelectionBar
            {
                id: _selectionBar

                Layout.alignment: Qt.AlignHCenter
                Layout.margins: Maui.Style.space.medium
                Layout.preferredWidth: Math.min(parent.width-(Maui.Style.space.medium*2), implicitWidth)
                maxListHeight: _browserList.height - (Maui.Style.contentMargins*2)

                onCountChanged:
                {
                    if(_selectionBar.count < 1)
                    {
                        currentBrowser.clearSelection()
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

                onExitClicked: currentBrowser.clearSelection()

                listDelegate: Maui.ListBrowserDelegate
                {
                    isCurrentItem: false
                    Kirigami.Theme.inherit: true
                    showThumbnails: true
                    width: parent.width
                    height: Maui.Style.iconSizes.big + Maui.Style.space.big
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
                    text: qsTr("Open")
                    icon.name: "document-open"
                    onTriggered:
                    {

                        for(var i in selectionBar.uris)
                            currentBrowser.openFile(_selectionBar.uris[i])

                    }
                }

                Action
                {
                    text: qsTr("Tags")
                    icon.name: "tag"
                    onTriggered:
                    {
                        currentBrowser.tagFiles(_selectionBar.uris)
                    }
                }

                Action
                {
                    text: qsTr("Share")
                    icon.name: "document-share"
                    onTriggered:
                    {
                        currentBrowser.shareFiles(_selectionBar.uris)
                    }
                }

                Action
                {
                    text: qsTr("Copy")
                    icon.name: "edit-copy"
                    onTriggered:
                    {
                        _selectionBar.animate()
                        currentBrowser.copy(_selectionBar.uris)
                    }
                }

                Action
                {
                    text: qsTr("Cut")
                    icon.name: "edit-cut"
                    onTriggered:
                    {
                        _selectionBar.animate()
                        currentBrowser.cut(_selectionBar.uris)
                    }
                }

                Action
                {
                    text: qsTr("Remove")
                    icon.name: "edit-delete"

                    onTriggered:
                    {
                        currentBrowser.remove(_selectionBar.uris)
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

    }

    Connections
    {
        target: inx
        onOpenPath:
        {
            for(var index in paths)
                root.openTab(paths[index])
        }
    }

    Component.onCompleted:
    {
        if(isAndroid)
        {
            Maui.Android.statusbarColor(Kirigami.Theme.backgroundColor, true)
            Maui.Android.navBarColor(Kirigami.Theme.backgroundColor, true)
        }

        if(root.restoreSession)
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

        }else root.openTab(Maui.FM.homePath())
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
        if(root.searchBar)
            root.searchBar = false

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
}
