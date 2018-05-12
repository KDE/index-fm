import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.0 as Kirigami
import org.kde.maui 1.0 as Maui

import QtQuick.Window 2.0
import QtQuick.Controls.Material 2.1

import "widgets"
import "widgets/views"
import "widgets/sidebar"
import "widgets/dialogs/share"

import "widgets_templates"

import "Index.js" as INX

Maui.ApplicationWindow
{
    id: root
    title: qsTr("Index")

    property int sidebarWidth: placesSidebar.isCollapsed ? placesSidebar.iconSize * 2:
                                                           Kirigami.Units.gridUnit * (isMobile ? 14 : 11)

    pageStack.defaultColumnWidth: sidebarWidth
    pageStack.initialPage: [placesSidebar, browser]
    pageStack.interactive: isMobile
    pageStack.separatorVisible: pageStack.wideMode
    highlightColor: "#8682dd"
    altColor: "#43455a"

    headBar.middleContent: PathBar
    {
        id: pathBar
        height: iconSizes.big
        width: headBar.width * (isMobile ? 0.6 : 0.8)
    }

    PlacesSidebar
    {
        id: placesSidebar
        onPlaceClicked: browser.openFolder(path)

        width: isCollapsed ? iconSize*2 : parent.width
        height: parent.height
    }

    Browser
    {
        id: browser
        anchors.fill: parent

        Component.onCompleted:
        {
            browser.openFolder(inx.homePath())
        }
    }

    ItemMenu
    {
        id: itemMenu
        onBookmarkClicked: INX.bookmarkFolder(path)
        onCopyClicked:
        {
            if(multiple)
            {
                browser.copy(browser.selectedPaths)
                browser.selectionBar.animate("#6fff80")
            }else browser.copy([path])

        }
        onCutClicked:
        {
            if(multiple)
            {
                browser.cut(browser.selectedPaths)
                browser.selectionBar.animate("#fff44f")
            }else browser.cut([path])
        }

        onRemoveClicked:
        {
            if(multiple)
            {
                clearSelection()
                browser.remove(browser.selectedPaths)
                browser.selectionBar.animate("red")
            }else  browser.remove([path])
        }
    }

    NewDialog
    {
        id: newFolderDialog
        title: "New folder..."
        onFinished: inx.createDir(browser.currentPath, text)

    }

    NewDialog
    {
        id: newFileDialog
        title: "New file..."
        onFinished: inx.createFile(browser.currentPath, text)
    }

    ShareDialog
    {
        id: shareDialog
        parent: browser
    }

    Component.onCompleted: if(isAndroid) android.statusbarColor(backgroundColor, true)
}
