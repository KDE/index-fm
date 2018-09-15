import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.0 as Kirigami
import org.kde.mauikit 1.0 as Maui

import QtQuick.Window 2.0
import QtQuick.Controls.Material 2.1

import "widgets"
import "widgets/views"
import "widgets/sidebar"
import "widgets_templates"

import "Index.js" as INX

Maui.ApplicationWindow
{
    id: root
    title: browser.currentPath
    property int sidebarWidth: placesSidebar.isCollapsed ? placesSidebar.iconSize * 2:
                                                           Kirigami.Units.gridUnit * (isMobile ? 14 : 11)

    pageStack.defaultColumnWidth: sidebarWidth
    pageStack.initialPage: [placesSidebar, browser]
    pageStack.interactive: isMobile
    pageStack.separatorVisible: pageStack.wideMode
    accentColor: altColor
    highlightColor: "#8682dd"
    altColor: "#43455a"
    altToolBars: false
    altColorText: "#ffffff"
    property color headBarColor: "#bdc8e5"
//    headBarBG.color: headBarColor

    headBar.middleContent: Maui.PathBar
    {
        id: pathBar
//        pathBarBG.color:Qt.lighter(headBarColor, 1.1)
        height: iconSizes.big
        width: headBar.middleLayout.width * 0.9
        onPathChanged: browser.openFolder(path)
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
        onBookmarkClicked: browser.bookmarkFolder(paths)
        onCopyClicked:
        {
            if(paths.length > 0)
                browser.selectionBar.animate("#6fff80")

            browser.copy(paths)

        }
        onCutClicked:
        {
            if(paths.length > 0)
                browser.selectionBar.animate("#fff44f")

            browser.cut(paths)
        }

        //        onSaveToClicked:
        //        {
        //            fmDialog.saveDialog = false
        //            fmDialog.multipleSelection = true
        //            fmDialog.onlyDirs= true

        //            var myPath = path

        //            var paths = browser.selectionBar.selectedPaths
        //            fmDialog.show(function(paths)
        //            {
        //                inx.copy(myPath, paths)
        //            })
        //        }

        onRemoveClicked:
        {
            if(paths.length > 0)
            {
                browser.selectionBar.clear()
                browser.selectionBar.animate("red")
            }
            browser.remove(paths)
        }

        onShareClicked: isAndroid ? Maui.Android.shareDialog(paths) :
                                    shareDialog.show(paths)
    }

    Maui.NewDialog
    {
        id: newFolderDialog
        title: "New folder..."
        onFinished: inx.createDir(browser.currentPath, text)

    }

    Maui.NewDialog
    {
        id: newFileDialog
        title: "New file..."
        onFinished: inx.createFile(browser.currentPath, text)
    }

    Maui.ShareDialog
    {
        id: shareDialog
        //        parent: browser
    }

    onSearchButtonClicked: fmDialog.show()
    Maui.FileDialog
    {
        id:fmDialog
    }

    Connections
    {
        target: inx
        onOpenPath: browser.openFolder(paths[0])
    }


}
