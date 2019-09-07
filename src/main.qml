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
    title: browser.browser.currentPath
    //    property alias browser: browserView.browser
    property alias browser: _browserList.currentItem
    showAccounts: false
    about.appDescription: qsTr("Index is a file manager that works on desktops, Android and Plasma Mobile. Index lets you browse your system files and applications and preview your music, text, image and video files and share them with external applications.")
    about.appIcon: "qrc:/assets/index.svg"

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

    onGoBackTriggered: browser.browser.goBack()


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

    //    leftIcon.visible: false
    //    leftIcon.onClicked: _drawer.visible = !_drawer.visible
    //    leftIcon.checkable: true
    //    leftIcon.checked: _drawer.visible

    //    headBar.strech: false

    Component
    {
        id: _pathBarComponent

        Maui.PathBar
        {
            anchors.fill: parent
            //        colorScheme.backgroundColor: "#fff"
            //        colorScheme.textColor: "#333"
            //        colorScheme.borderColor: Qt.darker(headBarBGColor, 1.4)
            onPathChanged: browser.browser.openFolder(path)
            url: browser.browser.currentPath
            onHomeClicked: browser.browser.openFolder(Maui.FM.homePath())
            onPlaceClicked: browser.browser.openFolder(path)
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
            //            onCleared: browser.goBack()
            onGoBackTriggered:
            {
                searchBar = false
                clear()
                //                browser.goBack()
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
        //        onLoaded:
        //        {
        //            if(sourceComponent === _pathBarComponent)
        //                item.url =browser.currentPath
        //        }
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
        //        height: 200 /*- root.header.height - browser.header.height*/
        //        y: 0
        height: root.height - root.header.height - (browser.browser.headBar.position === ToolBar.Footer && _drawer.modal ? browser.browser.footer.height : 0)
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
                browser.browser.openFolder(path)

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
            //             width: isCollapsed ? iconSize*2 : parent.width
            //             height: parent.height


        }
    }

    ObjectModel { id: tabsObjectModel }

    ColumnLayout
    {
        anchors.fill: parent
        spacing: 0

        Rectangle
        {
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
                //                    currentIndex : _editorList.currentIndex
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
                        width: 150 * unit
                        checked: index === _browserList.currentIndex
                        implicitHeight: toolBarHeight

                        onClicked: _browserList.currentIndex = index

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
                                text: tabsObjectModel.get(index).browser.currentFMList.pathName
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
        }
    }





    //    Rectangle
    //    {
    //        color: "pink"
    //        width: iconSizes.big
    //        height: width * 1.5

    //        anchors.left: parent.left
    //        anchors.bottom:  parent.bottom

    //        anchors.bottomMargin: toolBarHeight

    //        Maui.ToolButton
    //        {

    //        }
    //    }
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
        onOpenPath: browser.browser.openFolder(paths[0])
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
            tabsObjectModel.get(tabsObjectModel.count - 1).browser.openFolder(path)
        }
    }

    function setTabMetadata(filepath)
    {
        tabsListModel.setProperty(tabsBar.currentIndex, "path", filepath)
    }
}
