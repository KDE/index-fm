import QtQuick 2.9
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
    title:  currentTab && currentBrowser ? currentBrowser.title : ""
    Maui.App.description: qsTr("Index is a file manager that works on desktops, Android and Plasma Mobile. Index lets you browse your system files and applications and preview your music, text, image and video files and share them with external applications.")
    Maui.App.iconName: "qrc:/assets/index.svg"
    Maui.App.webPage: "https://mauikit.org"
    Maui.App.donationPage: "https://invent.kde.org/kde/index-fm"
    Maui.App.reportPage: "https://github.com/Nitrux/maui"

    property bool terminalVisible : Maui.FM.loadSettings("TERMINAL", "EXTENSIONS", false) == "true"
    onTerminalVisibleChanged: if(terminalVisible && currentBrowser) syncTerminal(root.currentPath)

    property alias terminal : terminalLoader.item
    property alias dialog : dialogLoader.item

    property alias previewer : _previewer
    property alias selectionBar : _selectionBar
    property alias shareDialog : _shareDialog
    property alias openWithDialog : _openWithDialog
    property alias tagsDialog : _tagsDialog

    property alias currentTab : _browserList.currentItem
    readonly property Maui.FileBrowser currentBrowser : currentTab && currentTab.browser ? currentTab.browser : null

    property bool searchBar: false
    property bool selectionMode: false
    property bool showHiddenFiles: false
    property bool showThumbnails: true
    property bool showStatusBar: false
    property bool singleClick : Maui.FM.loadSettings("SINGLE_CLICK", "BROWSER", Maui.Handy.singleClick) == "true"
    property bool restoreSession: Maui.FM.loadSettings("RESTORE_SESSION", "BROWSER", false) == "true"
    property bool supportSplit :!Kirigami.Settings.isMobile && root.width > 600
    readonly property url currentPath : currentBrowser ?  currentBrowser.currentPath : ""

    onCurrentPathChanged:
    {
        syncTerminal(currentBrowser.currentPath)
        syncSidebar(currentBrowser.currentPath)
    }

    onCurrentBrowserChanged:
    {
        _viewTypeGroup.currentIndex = currentBrowser.settings.viewType
    }

    onClosing:
    {
        close.accepted = false
        var paths = []

        for(var i = 0; i <tabsObjectModel.count; i ++)
        {
            const tab = tabsObjectModel.get(i)
            var tabPaths = []

            for(var j = 0; j < tab.model.count; j++)
            {
                const browser = tab.model.get(j)
                tabPaths.push(browser.currentPath)
            }

            paths.push(tabPaths)
        }

        Maui.FM.saveSettings("LAST_SESSION", paths, "BROWSER")
        close.accepted = true
    }

    flickable: currentTab && currentTab.browser ? currentTab.browser.flickable : null

    mainMenu: [MenuItem
    {
        text: qsTr("Settings")
        icon.name: "configure"
        onTriggered: openConfigDialog()
    },

    MenuSeparator {},

    MenuItem
    {
        visible: terminal
        text: qsTr("Show Terminal")
        icon.name: "utilities-terminal"
        onTriggered: toogleTerminal()
        checked : terminalVisible
        checkable: true
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
                anchors.fill: parent
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

    headBar.rightSretch: Maui.App.enableCSD
    headBar.middleContent:   Maui.PathBar
    {
        id: _pathBar
        Layout.fillWidth: true
        Layout.margins: Maui.Style.space.medium

        onPathChanged: currentTab.browser.openFolder(path.trim())
        url: root.currentPath
        onHomeClicked: currentTab.browser.openFolder(Maui.FM.homePath())
        onPlaceClicked: currentTab.browser.openFolder(path)
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
        iconSize: Maui.Style.iconSizes.medium

        onPlaceClicked:
        {
            currentTab.browser.openFolder(path)
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
                icon.name: "item-select"
                checkable: true
                checked: root.selectionMode
                onClicked: root.selectionMode = !root.selectionMode
                onPressAndHold: currentTab.browser.selectAll()
            },

            Maui.ToolButtonMenu
            {
                icon.name: "view-sort"

                MenuItem
                {
                    text: qsTr("Show Folders First")
                    checked: currentTab.browser.currentFMList.foldersFirst
                    checkable: true
                    onTriggered: currentTab.browser.currentFMList.foldersFirst = !currentTab.browser.currentFMList.foldersFirst
                }

                MenuSeparator {}

                MenuItem
                {
                    text: qsTr("Type")
                    checked: currentTab.browser.currentFMList.sortBy === Maui.FMList.MIME
                    checkable: true
                    onTriggered: currentTab.browser.currentFMList.sortBy = Maui.FMList.MIME
                    autoExclusive: true
                }

                MenuItem
                {
                    text: qsTr("Date")
                    checked: currentTab.browser.currentFMList.sortBy === Maui.FMList.DATE
                    checkable: true
                    onTriggered: currentTab.browser.currentFMList.sortBy = Maui.FMList.DATE
                    autoExclusive: true
                }

                MenuItem
                {
                    text: qsTr("Modified")
                    checkable: true
                    checked: currentTab.browser.currentFMList.sortBy === Maui.FMList.MODIFIED
                    onTriggered: currentTab.browser.currentFMList.sortBy = Maui.FMList.MODIFIED
                    autoExclusive: true
                }

                MenuItem
                {
                    text: qsTr("Size")
                    checkable: true
                    checked: currentTab.browser.currentFMList.sortBy === Maui.FMList.SIZE
                    onTriggered: currentTab.browser.currentFMList.sortBy = Maui.FMList.SIZE
                    autoExclusive: true
                }

                MenuItem
                {
                    text: qsTr("Name")
                    checkable: true
                    checked: currentTab.browser.currentFMList.sortBy === Maui.FMList.LABEL
                    onTriggered: currentTab.browser.currentFMList.sortBy = Maui.FMList.LABEL
                    autoExclusive: true
                }

                MenuSeparator{}

                MenuItem
                {
                    id: groupAction
                    text: qsTr("Group")
                    checkable: true
                    checked: currentTab.browser.settings.group
                    onTriggered:
                    {
                        currentTab.browser.settings.group = !currentTab.browser.settings.group
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
                    if(currentTab.browser.browserMenu.visible)
                        currentTab.browser.browserMenu.close()
                    else
                        currentTab.browser.browserMenu.show(_optionsButton, 0, height)
                }
                checked: currentTab.browser.browserMenu.visible
                checkable: false
            }
        ]

        headBar.leftContent: [
            ToolButton
            {
                icon.name: "go-previous"
                onClicked: currentBrowser.goBack()
            },

            ToolButton
            {
                icon.name: "go-next"
                onClicked: currentBrowser.goNext()
            },

            Maui.ToolActions
            {
                id: _viewTypeGroup
                expanded: headBar.width > Kirigami.Units.gridUnit * 32
                currentIndex: Maui.FM.loadSettings("VIEW_TYPE", "BROWSER", Maui.FMList.LIST_VIEW)
                onCurrentIndexChanged:
                {
                    if(currentTab.browser)
                    currentTab.browser.settings.viewType = currentIndex

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

        SplitView
        {
            anchors.fill: parent
            spacing: 0
            orientation: Qt.Vertical

            handle: Rectangle
            {
                implicitWidth: 10
                implicitHeight: 10
                color: SplitHandle.pressed ? Kirigami.Theme.highlightColor
                                           : (SplitHandle.hovered ? Qt.lighter(Kirigami.Theme.backgroundColor, 1.1) : Kirigami.Theme.backgroundColor)

                Kirigami.Separator
                {
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    anchors.left: parent.left
                }
            }

            ColumnLayout
            {
                id: _layout

                SplitView.fillHeight: true
                SplitView.fillWidth: true

                spacing: 0

                Maui.TabBar
                {
                    id: tabsBar
                    visible: _browserList.count > 1
                    Layout.fillWidth: true
                    Layout.preferredHeight: tabsBar.implicitHeight
                    position: TabBar.Header
                    currentIndex : _browserList.currentIndex

                    Keys.onPressed:
                    {
                        if(event.key == Qt.Key_Return)
                        {
                            _browserList.currentIndex = currentIndex
                        }

                        if(event.key == Qt.Key_Down)
                        {
                            currentTab.browser.currentView.forceActiveFocus()
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
                            implicitWidth: Math.max(_layout.width / _repeater.count, 120)
                            checked: index === _browserList.currentIndex

                            text: tabsObjectModel.get(index).browser.title

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
                            currentTab.browser.currentView.forceActiveFocus()
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
                    Layout.bottomMargin: Maui.Style.contentMargins*2
                    maxListHeight: _browserList.height - (Maui.Style.contentMargins*2)

                    onCountChanged:
                    {
                        if(_selectionBar.count < 1)
                        {
                            currentTab.browser.clearSelection()
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

                    onExitClicked: currentTab.browser.clearSelection()

                    listDelegate: Maui.ListBrowserDelegate
                    {
                        Kirigami.Theme.inherit: true
                        width: parent.width
                        height: Maui.Style.iconSizes.big + Maui.Style.space.big
                        label1.text: model.label
                        label2.text: model.path
                        label3.text: ""
                        label4.text: ""
                        showEmblem: true
                        keepEmblemOverlay: true
                        showThumbnails: true
                        leftEmblem: "list-remove"
                        folderSize: Maui.Style.iconSizes.big
                        onLeftEmblemClicked: _selectionBar.removeAtIndex(index)
                        background: Item {}
                        onClicked:
                        {
                            _selectionBar.selectionList.currentIndex = index
                            //                        control.previewer.show(_selectionBar.selectionList.model, _selectionBar.selectionList.currentIndex )
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
                                currentTab.browser.openFile(_selectionBar.uris[i])

                        }
                    }

                    Action
                    {
                        text: qsTr("Tags")
                        icon.name: "tag"
                        onTriggered:
                        {
                            currentTab.browser.tagFiles(_selectionBar.uris)
                        }
                    }

                    Action
                    {
                        text: qsTr("Share")
                        icon.name: "document-share"
                        onTriggered:
                        {
                            currentTab.browser.shareFiles(_selectionBar.uris)
                        }
                    }

                    Action
                    {
                        text: qsTr("Copy")
                        icon.name: "edit-copy"
                        onTriggered:
                        {
                            _selectionBar.animate()
                            currentTab.browser.copy(_selectionBar.uris)
                        }
                    }

                    Action
                    {
                        text: qsTr("Cut")
                        icon.name: "edit-cut"
                        onTriggered:
                        {
                            _selectionBar.animate()
                            currentTab.browser.cut(_selectionBar.uris)
                        }
                    }

                    Action
                    {
                        text: qsTr("Remove")
                        icon.name: "edit-delete"

                        onTriggered:
                        {
                            currentTab.browser.remove(_selectionBar.uris)
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

            //        Kirigami.Separator
            //        {
            //            visible: terminalLoader.active && terminalLoader.visible
            //            Layout.fillWidth: true
            //        }

            Loader
            {
                id: terminalLoader
                active: inx.supportsEmbededTerminal() && Maui.Handy.isLinux && !Kirigami.Settings.IsMobile
                visible: active && terminalVisible && terminal
                SplitView.fillWidth: true
                SplitView.preferredHeight: 200
                SplitView.maximumHeight: parent.height * 0.5
                SplitView.minimumHeight : 100
                source: "widgets/views/Terminal.qml"

                Behavior on Layout.preferredHeight
                {
                    NumberAnimation
                    {
                        duration: Kirigami.Units.longDuration
                        easing.type: Easing.InQuad
                    }
                }
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
                var session = Maui.FM.loadSettings("LAST_SESSION", "BROWSER", [[Maui.FM.homePath()]])

            console.log("LAST SESSIONW AS", session)
            for(var i in session)
            {
                const tab = session[i];
                if(tab.length === 2)
                {
                    root.openTab(tab[0])
                    currentTab.split(tab[1], Qt.Horizontal)
                }else root.openTab(tab[0])
            }
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

    function syncTerminal(path)
    {
        if(root.terminal && root.terminalVisible)
            root.terminal.session.sendText("cd '" + String(path).replace("file://", "") + "'\n")
    }

    function toogleTerminal()
    {
        terminalVisible = !terminalVisible
        Maui.FM.saveSettings("TERMINAL", terminalVisible, "EXTENSIONS")
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
