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
    altColorText: "#ffffff"
    altToolBars: false

    headBar.middleContent: Maui.PathBar
    {
        id: pathBar
        height: iconSizes.big
        width: headBar.width * (isMobile ? 0.6 : 0.8)
        onPathChanged: browser.openFolder(path)
        onHomeClicked:
        {
            if(pageStack.currentIndex !== 0 && !pageStack.wideMode)
                pageStack.currentIndex = 0

            browser.openFolder(inx.homePath())
        }

        onPlaceClicked: browser.openFolder(path)
    }

    footBar.visible: pageStack.currentIndex !== 0 || pageStack.wideMode

    footBar.leftContent: Maui.ToolButton
    {
        id: viewBtn
        iconColor: floatingBar ? altColorText : textColor

        iconName:  browser.detailsView ? "view-list-icons" : "view-list-details"
        onClicked: browser.switchView()
    }

    footBar.middleContent: Row
    {

        spacing: space.medium
        Maui.ToolButton
        {
            iconName: "go-previous"
            iconColor: floatingBar ? altColorText : textColor
            onClicked: browser.goBack()
        }

        Maui.ToolButton
        {
            iconName: "go-up"
            iconColor: floatingBar ? altColorText : textColor
            onClicked: browser.goUp()
        }

        Maui.ToolButton
        {
            iconName: "go-next"
            iconColor: floatingBar ? altColorText : textColor
            onClicked: browser.goNext()
        }
    }

    footBar.rightContent:  [
        //        Maui.ToolButton
        //        {
        //            iconName: "documentinfo"
        //            iconColor: browser.detailsDrawer.visible ? highlightColor : textColor
        //            onClicked: browser.detailsDrawer.visible ? browser.detailsDrawer.close() :
        //                                                       browser.detailsDrawer.show(browser.currentPath)
        //        },
        Maui.ToolButton
        {
            iconName: "overflow-menu"
            iconColor: floatingBar ? altColorText : textColor
            onClicked:  browser.browserMenu.show()
        }
    ]

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

        onSaveToClicked:
        {
            fmDialog.saveDialog = false
            fmDialog.multipleSelection = true
            fmDialog.onlyDirs= true

            var myPath = path

            fmDialog.show(function(selectedPaths)
            {
                inx.copy(myPath, selectedPaths)
            })
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

        onShareClicked:   isAndroid ? Maui.Android.shareDialog(path) :
                                      shareDialog.show(path)
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
}
