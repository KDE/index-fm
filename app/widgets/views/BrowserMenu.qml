import QtQuick 2.9
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import org.kde.maui 1.0 as Maui
import org.kde.kirigami 2.2 as Kirigami
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

    Kirigami.Separator{ width: parent.width; height: 1}

    MenuItem
    {
        visible: !isMobile
        text: qsTr(terminalVisible ? "Hide terminal" : "Show terminal")
        onTriggered:
        {
            terminalVisible = !terminalVisible
            inx.saveSettings("TERMINAL_VISIBLE", terminalVisible, "BROWSER")
            close()
        }
    }

    MenuItem
    {
        text: qsTr("Compact mode")
        onTriggered: placesSidebar.isCollapsed = !placesSidebar.isCollapsed
    }

    MenuItem
    {
        text: qsTr("Show previews")
        onTriggered:
        {
            browser.previews = !browser.previews
            inx.saveSettings("SHOW_PREVIEWS", browser.previews, "BROWSER")
            close()
        }
    }

    Kirigami.Separator{ width: parent.width; height: 1}

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
        text: qsTr("Bookmark")
        onTriggered: browser.bookmarkFolder(browser.currentPath)
    }

    Kirigami.Separator{ width: parent.width; height: 1}

    MenuItem
    {
        text: qsTr("Paste ")+"["+pasteFiles+"]"
        enabled: pasteFiles > 0
        onTriggered: browser.paste()
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
