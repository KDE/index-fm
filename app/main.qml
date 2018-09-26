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
                                                          Kirigami.Units.gridUnit * 11 > Screen.width  * 0.3 ? Screen.width : Kirigami.Units.gridUnit * 11

    about.appDescription: qsTr("Index is a file manager that works on desktops, Android and Plasma Mobile. Index lets you browse your system files and applications and preview your music, text, image and video files and share them with external applications.")
    about.appIcon: "qrc:/assets/index.svg"
    pageStack.defaultColumnWidth: sidebarWidth
    pageStack.initialPage: [placesSidebar, browser]
    pageStack.interactive: isMobile
    pageStack.separatorVisible: pageStack.wideMode
    accentColor: altColor
    highlightColor: headBarBGColor
    altColor: "#43455a"
    altToolBars: false
    altColorText: "#ffffff"
    headBarBGColor: "#64B5F6"
    headBarFGColor: altColorText
//    headBarBG.color: headBarColor

    headBar.colorScheme.borderColor: Qt.darker(headBarBGColor, 1.4)
    headBar.middleContent: Maui.PathBar
    {
        id: pathBar
        colorScheme.backgroundColor: "#fff"
        colorScheme.textColor: "#333"
        colorScheme.borderColor: Qt.darker(headBarBGColor, 1.4)
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

        onRenameClicked:
        {
            if(paths.length === 1)
                renameDialog.open()

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
        title: "Create new folder"
        onFinished: inx.createDir(browser.currentPath, text)

    }

    Maui.NewDialog
    {
        id: newFileDialog
        title: "Create new file"
        onFinished: inx.createFile(browser.currentPath, text)
    }

    Maui.NewDialog
    {
        id: renameDialog
        title: qsTr("Rename file")
        textEntry.placeholderText: qsTr("New name...")
        onFinished: inx.rename(itemMenu.paths[0], textEntry.text)

        acceptText: qsTr("Rename")
        rejectText: qsTr("Cancel")
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
