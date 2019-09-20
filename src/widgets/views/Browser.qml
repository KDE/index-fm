import QtQuick 2.9
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.0 as Kirigami
import org.kde.mauikit 1.0 as Maui

Maui.FileBrowser
{
    id: control
    headBar.visible: true

    menu: [
        MenuItem
        {
            visible: !isMobile
            text: qsTr("Show terminal")
            checkable: true
            checked: terminalVisible
            onTriggered:
            {
                terminalVisible = !terminalVisible
                Maui.FM.setDirConf(control.currentPath+"/.directory", "MAUIFM", "ShowTerminal", terminalVisible)
            }
        }
    ]

    headBar.rightContent: ToolButton
    {
        visible: terminal
        icon.name: "utilities-terminal"
        onClicked: terminalVisible = !terminalVisible
        checked : terminalVisible
        checkable: false
    }

    onNewBookmark:
    {
        for(var index in paths)
            placesSidebar.list.addPlace(paths[index])
    }

    onCurrentPathChanged:
    {
        if(terminalVisible && !isMobile)
            terminal.session.sendText("cd '" + String(currentPath).replace("file://", "") + "'\n")

        for(var i = 0; i < placesSidebar.count; i++)
            if(currentPath === placesSidebar.list.get(i).path)
                placesSidebar.currentIndex = i
    }

    onItemClicked: openItem(index)

    onItemDoubleClicked:
    {
        var item = currentFMList.get(index)
        console.log(item.mime)
        if(Maui.FM.isDir(item.path) || item.mime === "inode/directory")
            control.openFolder(item.path)
        else
            control.openFile(item.path)
    }
}
