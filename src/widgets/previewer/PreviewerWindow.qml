import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import org.mauikit.controls as Maui

import org.mauikit.filebrowsing as FB


Maui.DialogWindow
{
    id: control
    readonly property alias previewer : _previewer

    title: _previewer.title
    width: 700
    height: 1000

    page.showTitle: true
    page.headBar.forceCenterMiddleContent: isWide

    FilePreviewer
    {
        id: _previewer
        anchors.fill: parent
    }

    page.footBar.rightContent: [
        ToolButton
        {
            icon.name: "love"
        },

        ToolButton
        {
            icon.name: "edit-share"
        },

        Button
        {
            text: i18n("Open")
            icon.name: "document-open"
            //        flat: true
            onClicked:
            {
                FB.FM.openUrl(_previewer.currentUrl)
            }
        }
    ]

    page.headBar.rightContent: ToolButton
    {
        icon.name: "documentinfo"
        checkable: true
        checked: _previewer.showInfo
        onClicked: _previewer.toggleInfo()
    }
}
