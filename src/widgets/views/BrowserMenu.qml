import QtQuick 2.9
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import org.kde.mauikit 1.0 as Maui
import org.kde.kirigami 2.2 as Kirigami
import "../../Index.js" as INX

Maui.Menu
{ 
    property int pasteFiles : 0

    Maui.MenuItem
    {
        text: qsTr(browser.selectionMode ? "Selection OFF" : "Selection ON")
        onTriggered: browser.selectionMode = !browser.selectionMode
    }

    MenuSeparator { }

    Maui.MenuItem
    {
        visible: !isMobile
        text: qsTr(terminalVisible ? "Hide terminal" : "Show terminal")
        onTriggered:
        {
            terminalVisible = !terminalVisible
            Maui.FM.setDirConf(browser.currentPath+"/.directory", "MAUIFM", "ShowTerminal", browser.terminalVisible)
            close()
        }
    }

    Maui.MenuItem
    {
        text: qsTr("Compact mode")
        onTriggered: placesSidebar.isCollapsed = !placesSidebar.isCollapsed
    }

    Maui.MenuItem
    {
        text: qsTr("Show previews")
        onTriggered:
        {
            INX.showPreviews()
            close()
        }
    }

    Maui.MenuItem
    {
        text: qsTr("Show hidden files")
        onTriggered:
        {
            INX.showHiddenFiles()
            close()
        }
    }

    MenuSeparator { }

    Maui.MenuItem
    {
        text: qsTr("New folder")
        onTriggered: INX.createFolder()
    }

    Maui.MenuItem
    {
        text: qsTr("New file")
        onTriggered: INX.createFile()
    }

    Maui.MenuItem
    {
        text: qsTr("Bookmark")
        onTriggered: INX.bookmarkFolder()
    }

    MenuSeparator { }
    Maui.MenuItem
    {
        text: qsTr("Paste ")+"["+pasteFiles+"]"
        enabled: pasteFiles > 0
        onTriggered: browser.paste()
    }
    MenuSeparator { }
    Maui.MenuItem
    {
        width: parent.width

        RowLayout
        {
            anchors.fill: parent
            Maui.ToolButton
            {
                Layout.fillHeight: true
                Layout.fillWidth: true
                iconName: "list-add"
                onClicked: zoomIn()
            }

            Maui.ToolButton
            {
                Layout.fillHeight: true
                Layout.fillWidth: true
                iconName: "list-remove"
                onClicked: zoomOut()
            }
        }
    }

    function show()
    {
        if(browser.currentPathType === browser.pathType.directory
                || browser.currentPathType ===  browser.pathType.tags)
        {
            if(browser.isCopy)
                pasteFiles = copyPaths.length
            else if(browser.isCut)
                pasteFiles = cutPaths.length

            popup()
        }
    }
}
