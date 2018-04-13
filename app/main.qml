import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.0 as Kirigami

import "widgets"
import "widgets/views"
import "widgets/sidebar"

import "widgets_templates"

import "Index.js" as INX

Kirigami.ApplicationWindow
{
    id: root
    visible: true
    width: 640
    height: 480
    title: qsTr("Index")

    property int sidebarWidth: Kirigami.Units.gridUnit * 11

    pageStack.defaultColumnWidth: sidebarWidth
    pageStack.initialPage: [placesSidebar, browser]
    pageStack.interactive: isMobile
    pageStack.separatorVisible: pageStack.wideMode

    readonly property bool isMobile : Kirigami.Settings.isMobile

    readonly property int contentMargins: isMobile ? 8 : 10
    readonly property int defaultFontSize: Kirigami.Theme.defaultFont.pointSize
    readonly property var fontSizes: ({
                                          tiny: defaultFontSize - 2,
                                          small: defaultFontSize -1,
                                          default: defaultFontSize,
                                          big: defaultFontSize + 1,
                                          large: defaultFontSize + 2
                                      })

    property string backgroundColor: Kirigami.Theme.backgroundColor
    property string textColor: Kirigami.Theme.textColor
    property string highlightColor: Kirigami.Theme.highlightColor
    property string highlightedTextColor: Kirigami.Theme.highlightedTextColor
    property string buttonBackgroundColor: Kirigami.Theme.buttonBackgroundColor
    property string viewBackgroundColor: Kirigami.Theme.viewBackgroundColor
    property string altColor: Kirigami.Theme.complementaryBackgroundColor

    property var iconSizes : ({
                                  small :  16,
                                  medium : 22,
                                  large:  48,
                              })
    property int iconSize : iconSizes.medium

    property int rowHeight : 32

    overlay.modal: Rectangle {
        color: isMobile ? darkColor : "transparent"
        opacity: 0.5
        height: root.height
    }

    overlay.modeless: Rectangle {
        color: "transparent"
    }


    header: IndexToolbar
    {
        id: mainHeader
    }

    PlacesSidebar
    {
        id: placesSidebar
        anchors.fill: parent

        onPlaceClicked: browser.openFolder(path)

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
                browser.selectionBar.animate("black")
            }else browser.copy([path])

        }
        onCutClicked:
        {
            if(multiple)
            {
                browser.cut(browser.selectedPaths)
                browser.selectionBar.animate("red")
            }else browser.cut([path])
        }
    }



}
