import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import org.mauikit.controls as Maui

import org.mauikit.filebrowsing as FB


Maui.PopupPage
{
    title: _previewer.title
    readonly property alias previewer : _previewer
    hint: 1
    maxWidth: 600
    maxHeight: implicitHeight

    stack: FilePreviewer
    {
        id: _previewer
        Layout.fillWidth: true
        Layout.fillHeight: true
        currentUrl: currentBrowser.currentFMModel.get(currentBrowser.currentIndex).url
    }

    footBar.rightContent: [
        FB.FavButton
        {
            url: _previewer.currentUrl
        },

        ToolButton
        {
            icon.name: "document-share"
            onClicked: shareFiles([_previewer.currentUrl])
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

    footBar.leftContent: Maui.ToolActions
    {
        checkable: false
        Action
        {
            icon.name:"go-previous"
            onTriggered: currentBrowser.previousItem()
        }

        Action
        {
            icon.name:"go-next"
            onTriggered: currentBrowser.nextItem()
        }
    }

    headBar.rightContent: ToolButton
    {
        icon.name: "documentinfo"
        checkable: true
        checked: _previewer.showInfo
        onClicked: _previewer.toggleInfo()
    }
}
