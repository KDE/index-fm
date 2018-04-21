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


    MenuItem
    {
        text: qsTr(terminalVisible ? "Hide terminal" : "Show terminal")
        onTriggered:
        {
            terminalVisible = !terminalVisible
            inx.saveSettings("TERMINAL_VISIBLE", terminalVisible, "INX")
            close()
        }
    }


    MenuItem
    {
        text: qsTr("Bookmark")
        onTriggered: INX.bookmarkFolder(browser.currentPath)
    }
}
