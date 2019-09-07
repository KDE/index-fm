import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.7 as Kirigami
import org.kde.mauikit 1.0 as Maui
import QtQml.Models 2.3

import QtQuick.Window 2.0
import "widgets"
import "widgets/views"

Maui.ApplicationWindow
{
    id: root
    title: browser.currentPath
    showAccounts: false
    about.appDescription: qsTr("Index is a file manager that works on desktops, Android and Plasma Mobile. Index lets you browse your system files and applications and preview your music, text, image and video files and share them with external applications.")
    about.appIcon: "qrc:/assets/index.svg"


    property bool terminalVisible : true
    property alias terminal : terminalLoader.item
    property alias browser: _browserList.currentItem
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

    onGoBackTriggered: browser.goBack()


    //    headBarBGColor: viewBackgroundColor
    //    headBar.drawBorder: false
    //    footBar.visible: false

    //    headBar.leftContent:  ToolButton
    //    {
    //        visible: _drawer.modal
    //        icon.name: "view-right-new"
    //        onClicked: _drawer.visible = !_drawer.visible
    //        checkable: true
    //        checked: _drawer.visible
    //    }



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
        width: Math.min(Kirigami.Units.gridUnit * 11, root.width)
        handleClosedIcon.source: "view-right-new"
        handleOpenIcon.source: "view-right-new"
        height: root.height - root.header.height - (browser.headBar.position === ToolBar.Footer && _drawer.modal ? browser.footer.height : 0)
        modal: !root.isWide
        handleVisible: modal
        contentItem: Maui.PlacesSidebar
        {
            id: placesSidebar
            //            height: _drawer.height
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
        }
    }

    ObjectModel { id: tabsObjectModel }

    ColumnLayout
    {
        anchors.fill: parent
        spacing: 0

        Rectangle
        {
            id: _tabBar
            Layout.fillWidth: true
            visible: _browserList.count > 1
            Layout.preferredHeight: visible ? toolBarHeight : 0
            Kirigami.Theme.colorSet: Kirigami.Theme.View
            Kirigami.Theme.inherit: false
            color: Kirigami.Theme.backgroundColor

            TabBar
            {
                id: tabsBar
                anchors.fill: parent
                currentIndex : _browserList.currentIndex
                clip: true

                ListModel { id: tabsListModel }

                background: Rectangle
                {
                    color: "transparent"
                }

                Repeater
                {
                    model: tabsListModel

                    TabButton
                    {
                        readonly property int tabWidth: 150 * unit
                        width: Math.min(Math.min(tabWidth, root.width), tabWidth * 2)
                        checked: index === _browserList.currentIndex
                        implicitHeight: toolBarHeight

                        onClicked:
                        {
                            _browserList.currentIndex = index
                            if(terminal && terminalVisible && !isMobile)
                                terminal.session.sendText("cd '" + path.replace("file://", "") + "'\n")
                        }

                        background: Rectangle
                        {
                            color: checked ? Kirigami.Theme.focusColor : Kirigami.Theme.backgroundColor
                            opacity: checked ? 0.4 : 1

                            Kirigami.Separator
                            {
                                color: Qt.tint(Kirigami.Theme.textColor, Qt.rgba(Kirigami.Theme.backgroundColor.r, Kirigami.Theme.backgroundColor.g, Kirigami.Theme.backgroundColor.b, 0.7))
                                z: tabsBar.z + 1
                                width : 2
                                //                                    visible: tabsListModel.count > 1
                                anchors
                                {
                                    bottom: parent.bottom
                                    top: parent.top
                                    right: parent.right
                                }
                            }
                        }

                        contentItem: RowLayout
                        {
                            height: toolBarHeight
                            width: 150 *unit
                            anchors.bottom: parent.bottom

                            Label
                            {
                                text: tabsObjectModel.get(index).list.pathName
                                //                             verticalAlignment: Qt.AlignVCenter
                                font.pointSize: fontSizes.default
                                Layout.fillWidth: true
                                Layout.fillHeight: false
                                Layout.alignment: Qt.AlignCenter
                                anchors.centerIn: parent
                                color: Kirigami.Theme.textColor
                                wrapMode: Text.NoWrap
                                elide: Text.ElideRight
                            }

                            ToolButton
                            {
                                //                                        Layout.fillHeight: true
                                Layout.margins: space.medium
                                icon.name: "dialog-close"
                                //                             icon.color: "transparent"
                                //                                        visible: tabsListModel.count > 1

                                onClicked:
                                {
                                    var removedIndex = index
                                    tabsObjectModel.remove(removedIndex)
                                    tabsListModel.remove(removedIndex)
                                }
                            }
                        }
                    }
                }
            }

        }

        Kirigami.Separator
        {
            visible: _tabBar.visible
            color: Qt.tint(Kirigami.Theme.textColor, Qt.rgba(Kirigami.Theme.backgroundColor.r, Kirigami.Theme.backgroundColor.g, Kirigami.Theme.backgroundColor.b, 0.7))
            Layout.fillWidth: true
            Layout.preferredHeight: 1
        }

        ListView
        {
            id: _browserList
            Layout.fillHeight: true
            Layout.fillWidth: true
            orientation: ListView.Horizontal
            model: tabsObjectModel
            snapMode: ListView.SnapOneItem
            spacing: 0
            interactive: isMobile
            highlightFollowsCurrentItem: true
            highlightMoveDuration: 0
            onMovementEnded: _browserList.currentIndex = indexAt(contentX, contentY)
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
        openTab(Maui.FM.homePath())
    }

    function openTab(path)
    {
        var component = Qt.createComponent("widgets/views/Browser.qml");
        if (component.status === Component.Ready)
        {
            var object = component.createObject(tabsObjectModel);
            tabsObjectModel.append(object);
        }

        tabsListModel.append({
                                 title: qsTr("Untitled"),
                                 path: path,
                             })

        _browserList.currentIndex = tabsObjectModel.count - 1

        if(path && Maui.FM.fileExists(path))
        {
            setTabMetadata(path)
            tabsObjectModel.get(tabsObjectModel.count - 1).openFolder(path)
        }
    }

    function setTabMetadata(filepath)
    {
        tabsListModel.setProperty(tabsBar.currentIndex, "path", filepath)
    }
}
