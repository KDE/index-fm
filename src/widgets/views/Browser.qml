import QtQuick 2.9
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.0 as Kirigami
import org.kde.mauikit 1.0 as Maui

Maui.FileBrowser
{
    id: control

    viewType: Maui.FM.loadSettings("VIEW_TYPE", "BROWSER", Maui.FMList.LIST_VIEW)
    onViewTypeChanged: Maui.FM.saveSettings("VIEW_TYPE", viewType, "BROWSER")

    headBar.rightContent: ToolButton
    {
        visible: terminal
        icon.name: "utilities-terminal"
        onClicked:
        {
            terminalVisible = !terminalVisible
            Maui.FM.saveSettings("TERMINAL", terminalVisible, "EXTENSIONS")
        }
        checked : terminalVisible
        checkable: false
    }

    onNewBookmark:
    {
        for(var index in paths)
            placesSidebar.list.addPlace(paths[index])
    }

    onNewTag: placesSidebar.list.refresh()

    onCurrentPathChanged:
    {
        if(terminalVisible && !Kirigami.Settings.isMobile)
            terminal.session.sendText("cd '" + String(currentPath).replace("file://", "") + "'\n")

        placesSidebar.currentIndex = -1
        for(var i = 0; i < placesSidebar.count; i++)
            if(String(currentPath) === placesSidebar.list.get(i).path)
            {
                placesSidebar.currentIndex = i
                return;
            }
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
