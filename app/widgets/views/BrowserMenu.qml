import QtQuick 2.9
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import org.kde.mauikit 1.0 as Maui
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

    MenuSeparator { }
    MenuItem
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
            INX.showPreviews()
            close()
        }
    }

    MenuItem
    {
        text: qsTr("Show hidden files")
        onTriggered:
        {
            INX.showHiddenFiles()
            close()
        }
    }

    MenuSeparator { }
    MenuItem
    {
        text: qsTr("New folder")
        onTriggered: INX.createFolder()
    }

    MenuItem
    {
        text: qsTr("New file")
        onTriggered: INX.createFile()
    }

    MenuItem
    {
        text: qsTr("Bookmark")
        onTriggered: INX.bookmarkFolder()
    }

    MenuSeparator { }
    MenuItem
    {
        text: qsTr("Paste ")+"["+pasteFiles+"]"
        enabled: pasteFiles > 0
        onTriggered: browser.paste()
    }
    MenuSeparator { }
    MenuItem
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

            if(isMobile) open()
            else popup()
        }
    }

}
