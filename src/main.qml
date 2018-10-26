import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.0 as Kirigami
import org.kde.mauikit 1.0 as Maui

import QtQuick.Window 2.0
import FMList 1.0

import "widgets"
import "widgets/views"
import "widgets/sidebar"

Maui.ApplicationWindow
{
    id: root
    title: browser.currentPath
    property alias browser: browserView.browser

    property int sidebarWidth: placesSidebar.isCollapsed ? placesSidebar.iconSize * 2:
                                                           Kirigami.Units.gridUnit * 11 > Screen.width  * 0.3 ? Screen.width : Kirigami.Units.gridUnit * 11

    about.appDescription: qsTr("Index is a file manager that works on desktops, Android and Plasma Mobile. Index lets you browse your system files and applications and preview your music, text, image and video files and share them with external applications.")
    about.appIcon: "qrc:/assets/index.svg"

    pageStack.defaultColumnWidth: sidebarWidth
    pageStack.initialPage: [placesSidebar, browserView]
    pageStack.interactive: isMobile
    pageStack.separatorVisible: pageStack.wideMode

    accentColor: altColor
//    highlightColor: "#64B5F6"
    altColor: "#43455a"
    altToolBars: false
    altColorText: "#ffffff"
//    headBarBGColor: "#64B5F6"
//    headBarFGColor: altColorText
//    headBar.colorScheme.borderColor: Qt.darker(headBarBGColor, 1.4)

    headBar.middleContent: Maui.PathBar
    {
        id: pathBar
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

            browser.openFolder(inx.homePath())
        }

        onPlaceClicked: browser.openFolder(path)
    }

    PlacesSidebar
    {
        id: placesSidebar
        onPlaceClicked:
        {
            if(item.type === "Tags")
                browser.populateTags(item.path)
            else
                browser.openFolder(item.path)
        }

        width: isCollapsed ? iconSize*2 : parent.width
        height: parent.height
    }


    Browser
    {
        id: browserView
        anchors.fill: parent
        Component.onCompleted:
        {
            browser.openFolder(inx.homePath())
        }
    }

    onSearchButtonClicked: fmDialog.show()

    Maui.FileDialog
    {
        id:fmDialog
        onlyDirs: false
        filterType: FMList.AUDIO
        sortBy: FMList.MODIFIED
        mode: modes.OPEN
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
        },

        Maui.MenuItem
        {
            text: qsTr("Syncing")

        }
    ]
}
