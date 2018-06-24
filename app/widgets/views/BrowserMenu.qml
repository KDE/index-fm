import QtQuick 2.9
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import org.kde.maui 1.0 as Maui
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
        text: qsTr(browser.selectionMode ? "Selection OFF" : "Selection ON")
        onTriggered: browser.selectionMode = !browser.selectionMode
    }


    MenuItem
    {
        text: qsTr("Paste ")+"["+pasteFiles+"]"
        enabled: pasteFiles > 0
        onTriggered: browser.paste()
    }

    MenuItem
    {
        text: qsTr("Bookmark")
        onTriggered: browser.bookmarkFolder(browser.currentPath)
    }

    MenuItem
    {
        visible: !isMobile
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
        text: qsTr("New folder")
        onTriggered: newFolderDialog.open()
    }

    MenuItem
    {
        text: qsTr("New file")
        onTriggered: newFileDialog.open()
    }

    MenuItem
    {
        text: qsTr("Compact mode")
        onTriggered: placesSidebar.isCollapsed = !placesSidebar.isCollapsed
    }


    function show()
    {
        if(inx.isDir(browser.currentPath))
        {
            if(browser.isCopy)
                pasteFiles = copyPaths.length
            else if(browser.isCut)
                pasteFiles = cutPaths.length

            if(isMobile) open()
            else popup()
        }
    }

}
