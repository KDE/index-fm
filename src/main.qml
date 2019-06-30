import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.0 as Kirigami
import org.kde.mauikit 1.0 as Maui

import QtQuick.Window 2.0
import FMList 1.0

import "widgets"
import "widgets/views"

Maui.ApplicationWindow
{
    id: root
    title: browser.currentPath
    property alias browser: browserView.browser
    showAccounts: false
    about.appDescription: qsTr("Index is a file manager that works on desktops, Android and Plasma Mobile. Index lets you browse your system files and applications and preview your music, text, image and video files and share them with external applications.")
    about.appIcon: "qrc:/assets/index.svg"

    property alias dialog : dialogLoader.item

    property bool searchBar: false

    accentColor: "#303952"
    //    highlightColor: "#64B5F6"
    altToolBars: false
    altColorText: "#ffffff"
    //    headBarBGColor: "#64B5F6"
    //    headBarFGColor: altColorText
    //    headBar.colorScheme.borderColor: Qt.darker(headBarBGColor, 1.4)
    searchButton.iconColor: searchBar ? searchButton.colorScheme.highlightColor : searchButton.colorScheme.textColor
    onSearchButtonClicked:
    {
        searchBar = !searchBar

        if(searchField.visible)
            searchField.forceActiveFocus()
    }


    onGoBackTriggered:
    {
        console.log(browser.currentPathType, FMList.SEARCH_PATH)
        browser.goBack()
    }

    //    headBarBGColor: viewBackgroundColor
    //    headBar.drawBorder: false
    //    footBar.visible: false

    headBar.leftContent:  Maui.ToolButton
    {
        visible: _drawer.modal
        iconName: "view-right-new"
        onClicked: _drawer.visible = !_drawer.visible
        checkable: true
        checked: _drawer.visible
    }

    leftIcon.visible: false
    //    leftIcon.onClicked: _drawer.visible = !_drawer.visible
    //    leftIcon.checkable: true
    //    leftIcon.checked: _drawer.visible

    //    headBar.strech: false
    headBar.middleContent: Maui.PathBar
    {
        id: pathBar
        Layout.fillWidth: true
        Layout.margins: space.medium
        Maui.TextField
        {
            id: searchField
            anchors.fill: parent
            visible: searchBar
            focus: visible
            z: pathBar.z+1
            placeholderText: qsTr("Search... ")
            onAccepted: browser.openFolder("Search/"+text)
            //            onCleared: browser.goBack()
            onGoBackTriggered:
            {
                searchBar = false
                searchField.clear()
                //                browser.goBack()
            }
        }

        //        colorScheme.backgroundColor: "#fff"
        //        colorScheme.textColor: "#333"
        //        colorScheme.borderColor: Qt.darker(headBarBGColor, 1.4)
        height: iconSizes.big
        width: headBar.middleLayout.width * 0.95
        onPathChanged: browser.openFolder(path)
        url: browser.currentPath
        onHomeClicked: browser.openFolder(Maui.FM.homePath())
        onPlaceClicked: browser.openFolder(path)
    }

    Loader
    {
        id: dialogLoader
    }

    globalDrawer: Maui.GlobalDrawer
    {
        id: _drawer
        width: Kirigami.Units.gridUnit * 11
        modal: !root.isWide
        handleVisible: false
        contentItem: Maui.PlacesSidebar
        {
            id: placesSidebar
            //            height: _drawer.height

            onPlaceClicked:
            {
                if(_drawer.modal)
                    _drawer.close()
                browser.openFolder(path)

                if(searchBar)
                    searchBar = false
            }

            list.groups: [FMList.PLACES_PATH, FMList.APPS_PATH, FMList.CLOUD_PATH, FMList.BOOKMARKS_PATH, FMList.DRIVES_PATH, FMList.TAGS_PATH]
            //             width: isCollapsed ? iconSize*2 : parent.width
            //             height: parent.height


        }
    }



    content: Browser
    {
        id: browserView
        anchors.fill: parent
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
            filterType: FMList.AUDIO
            sortBy: FMList.MODIFIED
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
            Maui.Android.statusbarColor(backgroundColor, true)
    }
}
