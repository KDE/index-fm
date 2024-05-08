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
    maxWidth: 800
    maxHeight: implicitHeight

    stack: FilePreviewer
    {
        id: _previewer
        Layout.fillWidth: true
        Layout.fillHeight: true
    }

    footBar.rightContent: Button
    {
        text: i18n("Open")
        icon.name: "document-open"
        //        flat: true
        onClicked:
        {
            FB.FM.openUrl(_previewer.currentUrl)
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
