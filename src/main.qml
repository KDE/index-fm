import QtQuick 2.9
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.7 as Kirigami
import org.kde.mauikit 1.0 as Maui

import QtQuick.Window 2.0
import "widgets"
import "widgets/views"

Maui.ApplicationWindow
{
    id: root
    title: browser.currentPath
    Maui.App.description: qsTr("Index is a file manager that works on desktops, Android and Plasma Mobile. Index lets you browse your system files and applications and preview your music, text, image and video files and share them with external applications.")
    Maui.App.iconName: "qrc:/assets/index.svg"
    Maui.App.webPage: "https://mauikit.org"
    Maui.App.donationPage: "https://invent.kde.org/kde/index-fm"
    Maui.App.reportPage: "https://github.com/Nitrux/maui"

    property bool terminalVisible : Maui.FM.loadSettings("TERMINAL", "EXTENSIONS", false) == "true"
    onTerminalVisibleChanged: if(terminalVisible) browser.syncTerminal()

    property alias terminal : terminalLoader.item
    property alias dialog : dialogLoader.item
    property bool searchBar: false

    flickable: browser.flickable

     mainMenu: MenuItem
     {
         text: qsTr("Settings")
         icon.name: "configure"
         onTriggered: openConfigDialog()
     }

    Component
    {
        id: _pathBarComponent

        Maui.PathBar
        {
            anchors.fill: parent
            onPathChanged: browser.openFolder(path)
            url: browser.currentPath
            onHomeClicked: browser.openFolder(Maui.FM.homePath())
            onPlaceClicked: browser.openFolder(path)
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
                    onTriggered: browser.openTab(_pathBarmenu.path)
                }
            }
        }
    }

    Component
    {
        id: _searchFieldComponent

        Maui.TextField
        {
            anchors.fill: parent
            placeholderText: qsTr("Search for files... ")
            onAccepted: browser.openFolder("search:///"+text)
            onGoBackTriggered:
            {
                root.searchBar = false
                clear()
            }

            background: Rectangle //emulate pathbar style
            {
                border.color: Qt.tint(Kirigami.Theme.textColor, Qt.rgba(Kirigami.Theme.backgroundColor.r, Kirigami.Theme.backgroundColor.g, Kirigami.Theme.backgroundColor.b, 0.7))
                radius: Maui.Style.radiusV
                color: Kirigami.Theme.backgroundColor
            }
        }
    }


    Component
    {
        id: _configDialogComponent

        Maui.Dialog
        {
            maxHeight: _configLayout.implicitHeight * 1.5
            maxWidth: 300
            defaultButtons: false

                Kirigami.FormLayout
                {
                    id: _configLayout
                    width: parent.width
                    anchors.centerIn: parent

                    Item
                    {
                        Kirigami.FormData.label: qsTr("Navigation")
                        Kirigami.FormData.isSection: true
                    }

                    Switch
                    {
                        icon.name: "image-preview"
                        checkable: true
                        checked: browser.settings.showThumbnails
                        Kirigami.FormData.label: qsTr("Show Thumbnails")
                        onToggled:  browser.settings.showThumbnails = ! browser.settings.showThumbnails
                    }

                    Switch
                    {
                        Kirigami.FormData.label: qsTr("Show Hidden Files")
                        checkable: true
                        checked:  browser.currentFMList.hidden
                        onToggled:  browser.currentFMList.hidden = ! browser.currentFMList.hidden
                    }

                    Switch
                    {
                        Kirigami.FormData.label: qsTr("Single Click")
                        checkable: true
                        checked:  browser.settings.singleClick
                        onToggled:
                        {
                            browser.settings.singleClick = ! browser.settings.singleClick
                            Maui.FM.saveSettings("SINGLE_CLICK",  settings.singleClick, "BROWSER")

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
                        checked:  browser.footBar.visible
                        onToggled:  browser.toggleStatusBar()

                    }
                }
        }
    }

    headBar.implicitHeight: Maui.Style.toolBarHeight * 1.2
    headBar.middleContent:  Loader
    {
        id: _pathBarLoader
        Layout.fillWidth: true
        Layout.margins: Maui.Style.space.medium
        sourceComponent: root.searchBar ? _searchFieldComponent : _pathBarComponent
    }

    headBar.rightContent: ToolButton
    {
        icon.name: "edit-find"
        checked: root.searchBar
        onClicked:
        {
            searchBar = !searchBar
            if(searchBar)
                _pathBarLoader.item.forceActiveFocus()
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
            browser.openFolder(path)

            if(placesSidebar.modal)
                placesSidebar.collapse()
        }

        list.groups: [
            Maui.FMList.QUICK_PATH,
            Maui.FMList.PLACES_PATH,
            Maui.FMList.APPS_PATH,
            Maui.FMList.CLOUD_PATH,
            Maui.FMList.REMOTE_PATH,
            Maui.FMList.REMOVABLE_PATH,
            Maui.FMList.DRIVES_PATH,
            Maui.FMList.TAGS_PATH]

        itemMenu.contentData: [
            MenuItem
            {
                text: qsTr("Open in tab")
                onTriggered: browser.openTab(placesSidebar.list.get(placesSidebar.currentIndex).path)
            }
        ]
    }

    SplitView
    {
        anchors.fill: parent
        spacing: 0
        orientation: Qt.Vertical

        Browser
        {
            id: browser
            SplitView.fillHeight: true
            SplitView.fillWidth: true
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

    Connections
    {
        target: inx
        onOpenPath:
        {
            for(var index in paths)
                browser.openTab(paths[index])
        }
    }

    function openConfigDialog()
    {
        dialogLoader.sourceComponent = _configDialogComponent
        dialog.open()
    }

    Component.onCompleted:
    {
        if(isAndroid)
        {
            Maui.Android.statusbarColor(Kirigami.Theme.backgroundColor, true)
            Maui.Android.navBarColor(Kirigami.Theme.backgroundColor, true)
        }
    }
}
