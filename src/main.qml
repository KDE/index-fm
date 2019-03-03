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

    property int sidebarWidth: placesSidebar.isCollapsed ? placesSidebar.iconSize * 2:
                                                           Kirigami.Units.gridUnit * 11 > Screen.width  * 0.3 ? Screen.width : Kirigami.Units.gridUnit * 11

    about.appDescription: qsTr("Index is a file manager that works on desktops, Android and Plasma Mobile. Index lets you browse your system files and applications and preview your music, text, image and video files and share them with external applications.")
    about.appIcon: "qrc:/assets/index.svg"

    // pageStack.defaultColumnWidth: Kirigami.Units.gridUnit * 25
    //    pageStack.defaultColumnWidth: sidebarWidth
    //    pageStack.initialPage: [browserView]
    //    pageStack.interactive: isMobile
    //    pageStack.separatorVisible: false

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
        pageStack.currentIndex = 1
    }

    onGoBackTriggered:
    {
        console.log(browser.currentPathType, FMList.SEARCH_PATH)
        if(browser.currentPath ===  Maui.FM.homePath())
        {
            if (pageStack.currentIndex >= 1)
                pageStack.flickBack();
        }else browser.goBack()
    }

//    headBarBGColor: viewBackgroundColor
//    headBar.drawBorder: false
    headBar.middleContent: Maui.PathBar
    {
        id: pathBar
        Maui.TextField
        {
            id: searchField
            anchors.fill: parent
            visible: searchBar
            focus: visible
            z: pathBar.z+1
            placeholderText: qsTr("Search... ")
            onAccepted: browser.openFolder("Search/"+text)
            onCleared: browser.goBack()
            onGoBackTriggered:
            {
                searchBar = false
                searchField.clear()
                browser.goBack()
            }
        }

        //        colorScheme.backgroundColor: "#fff"
        //        colorScheme.textColor: "#333"
        //        colorScheme.borderColor: Qt.darker(headBarBGColor, 1.4)
        height: iconSizes.big
        width: headBar.middleLayout.width * 0.9
        onPathChanged: browser.openFolder(path)
        url: browser.currentPath
        onHomeClicked:
        {
            if(pageStack.currentIndex !== 0 && !pageStack.wideMode)
                pageStack.currentIndex = 0

            browser.openFolder(Maui.FM.homePath())
        }

        onPlaceClicked: browser.openFolder(path)
    }

    Loader
    {
        id: dialogLoader
    }

    globalDrawer: Maui.GlobalDrawer
    {
        id: _drawer
        width: Kirigami.Units.gridUnit * 14

        modal: !root.isWide
        handleVisible: modal

        Maui.PlacesSidebar
        {
            id: placesSidebar
            Layout.fillHeight: true
            Layout.fillWidth: true
            onPlaceClicked: browser.openFolder(path)
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

    mainMenu: [
        Maui.MenuItem
        {
            text: qsTr("Settings")
        }
    ]

    Component.onCompleted:
    {
        if(isAndroid)
            Maui.Android.statusbarColor(backgroundColor, true)
    }
}
