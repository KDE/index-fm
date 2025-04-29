import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import org.mauikit.controls as Maui

import org.mauikit.filebrowsing as FB

Maui.PopupPage
{
    id: control
    title: _previewer.title
    readonly property alias previewer : _previewer
    hint: 1
    maxWidth: 600
    maxHeight: implicitHeight
    focus: true
    
    onOpened: _previewer.forceActiveFocus()
    
    stack: FilePreviewer
    {
        id: _previewer
        Layout.fillWidth: true
        Layout.fillHeight: true
        focus: true
        Keys.enabled: true
        Keys.onPressed: (event) => console.log("Key pressed on preview popup", event.key)
        Keys.onEscapePressed: (event) =>
                              {
                                  control.close()
                                  event.accepted= true
                              }
        Keys.onLeftPressed: _previousAction.trigger()
        Keys.onRightPressed: _nextAction.trigger()
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
            id: _previousAction
            icon.name:"go-previous"
            shortcut: StandardKey.PreviousChild
            onTriggered:
            {
                currentBrowser.previousItem()
                _previewer.currentUrl = currentBrowser.currentFMModel.get(currentBrowser.currentIndex).url
            }
        }
        
        Action
        {
            id: _nextAction
            icon.name:"go-next"
            shortcut: StandardKey.NextChild

            onTriggered:
            {
                currentBrowser.nextItem()
                _previewer.currentUrl = currentBrowser.currentFMModel.get(currentBrowser.currentIndex).url
            }
        }
    }
    
    headBar.rightContent: ToolButton
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
