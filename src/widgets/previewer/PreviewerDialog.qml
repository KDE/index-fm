import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3

import org.mauikit.controls 1.3 as Maui

import org.mauikit.filebrowsing 1.3 as FB


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
    
     footBar.leftContent: Maui.ToolActions
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
