import QtQuick 2.7
import QtQuick.Controls 2.0
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
    showAccounts: false
    Maui.App.description: qsTr("Index is a file manager that works on desktops, Android and Plasma Mobile. Index lets you browse your system files and applications and preview your music, text, image and video files and share them with external applications.")
    Maui.App.iconName: "qrc:/assets/index.svg"


    property bool terminalVisible : true
    property alias terminal : terminalLoader.item
    property alias dialog : dialogLoader.item
    property bool searchBar: false

    //    accentColor: "#303952"
    //    highlightColor: "#64B5F6"
    //    altColorText: "#ffffff"
    //    headBarBGColor: "#64B5F6"
    //    headBarFGColor: altColorText
    //    headBar.colorScheme.borderColor: Qt.darker(headBarBGColor, 1.4)
    searchButton.checked: searchBar
    onSearchButtonClicked:
    {
        searchBar = !searchBar
        if(searchBar)
            _pathBarLoader.item.forceActiveFocus()
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
        }
    }

    Component
    {
        id: _searchFieldComponent

        Maui.TextField
        {
            anchors.fill: parent
            placeholderText: qsTr("Search for files... ")
            onAccepted: browser.openFolder("search://"+text)
            onGoBackTriggered:
            {
                searchBar = false
                clear()
            }

            background: Rectangle
            {
                border.color: Qt.tint(Kirigami.Theme.textColor, Qt.rgba(Kirigami.Theme.backgroundColor.r, Kirigami.Theme.backgroundColor.g, Kirigami.Theme.backgroundColor.b, 0.7))
                radius: radiusV
                color: Kirigami.Theme.backgroundColor
            }
        }
    }

    headBar.implicitHeight: toolBarHeight * 1.2
    headBar.middleContent:  Loader
    {
        id: _pathBarLoader
        Layout.fillWidth: true
        Layout.margins: space.medium
        Layout.preferredHeight: iconSizes.big
        sourceComponent: searchBar ? _searchFieldComponent : _pathBarComponent
    }

    Loader
    {
        id: dialogLoader
    }

    globalDrawer: Maui.GlobalDrawer
    {
        id: _drawer
        property bool collapsed : !root.isWide

        width: collapsed ? placesSidebar.iconSize * 2.5 : Math.min(Kirigami.Units.gridUnit * 11, root.width)
        height: root.height - root.header.height - (browser.headBar.position === ToolBar.Footer && _drawer.modal ? browser.footer.height : 0)
        modal: false
        handleVisible: false
        contentItem: Maui.PlacesSidebar
        {
            id: placesSidebar
            property bool collapsed : !root.isWide
            showLabels: !collapsed
            section.property: collapsed ? "" : "type"
            ScrollBar.vertical.policy: collapsed ? ScrollBar.AlwaysOff : ScrollBar.AlwaysOn
            anchors.fill: parent
            onPlaceClicked:
            {
                if(_drawer.modal)
                    _drawer.close()
                browser.openFolder(path)

                if(searchBar)
                    searchBar = false
            }

            list.groups: [
                Maui.FMList.PLACES_PATH,
                Maui.FMList.APPS_PATH,
                Maui.FMList.CLOUD_PATH,
                Maui.FMList.REMOTE_PATH,
                Maui.FMList.REMOVABLE_PATH,
                Maui.FMList.DRIVES_PATH,
                Maui.FMList.TAGS_PATH]

            itemMenu.contentData: [MenuItem
            {
                text: qsTr("Open in tab")
                onTriggered: browser.openTab(placesSidebar.list.get(placesSidebar.currentIndex).path)
            }]
        }
    }


    ColumnLayout
    {
        anchors.fill: parent
        spacing: 0

        Browser
        {
            id: browser
            Layout.fillHeight: true
            Layout.fillWidth: true
        }

        Loader
        {
            id: terminalLoader
            visible: terminalVisible && terminal
            focus: true
            Layout.fillWidth: true
            Layout.minimumHeight: visible && terminal ? 100 : 0
            Layout.maximumHeight: visible && terminal ? 500 : 0
            Layout.preferredHeight : visible && terminal ? 200 : 0
            source: !isMobile ? "widgets/views/Terminal.qml" : undefined
        }
    }

    Component
    {
        id:fmDialogComponent

        Maui.FileDialog
        {
            onlyDirs: false
            filterType: Maui.FMList.AUDIO
            sortBy: Maui.FMList.MODIFIED
            mode: modes.OPEN
        }
    }

    Connections
    {
        target: inx
        onOpenPath: browser.openFolder(paths[0])
    }

    Component.onCompleted:
    {
        if(isAndroid)
            Maui.Android.statusbarColor(Kirigami.Theme.backgroundColor, true)
    }
}
