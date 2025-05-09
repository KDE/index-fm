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

    FilePreviewer
    {
        id: _previewer
        anchors.fill: parent

        focus: true
        Keys.enabled: true
        Keys.onPressed: (event) => console.log("Key pressed on preview popup", event.key)
        Keys.onEscapePressed: (event) =>
                              {
                                  control.close()
                                  event.accepted= true
                              }
    }

    page.footBar.rightContent: [
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

    page.headBar.rightContent: ToolButton
    {
        icon.name: "documentinfo"
        checkable: true
        checked: _previewer.showInfo
        onClicked: _previewer.toggleInfo()
    }

    function forceActiveFocus()
    {
        _previewer.forceActiveFocus()
    }
}
