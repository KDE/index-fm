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

    page.footBar.leftContent: Maui.ToolActions
    {
        visible: !Maui.Handy.isMobile
        expanded: true
        autoExclusive: false
        checkable: false
        display: ToolButton.IconOnly

        Action
        {
            text: i18n("Previous")
            icon.name: "go-previous"
            onTriggered :  _previewer.goPrevious()
        }

        Action
        {
            text: i18n("Next")
            icon.name: "go-next"
            onTriggered: _previewer.goNext()
        }
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
