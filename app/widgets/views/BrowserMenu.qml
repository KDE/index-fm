import QtQuick 2.9
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "../../Index.js" as INX

Menu
{
    x: parent.width / 2 - width / 2
    y: parent.height / 2 - height / 2
    modal: true
    focus: true
    parent: ApplicationWindow.overlay
    margins: 1
    padding: 2

    property int pasteFiles : 0

    MenuItem
    {
        text: qsTr("Paste ")+"["+pasteFiles+"]"
        enabled: pasteFiles > 0
        onTriggered: browser.paste()
    }

    MenuItem
    {
        text: qsTr("Bookmark")
        onTriggered: INX.bookmarkFolder(browser.currentPath)
    }

    function show()
    {
        if(browser.isCopy)
            pasteFiles = copyPaths.length
        else if(browser.isCut)
            pasteFiles = cutPaths.length

        if(isMobile) open()
        else popup()
    }

}
