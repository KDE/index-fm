import QtQuick 2.9
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.0 as Kirigami
import org.kde.mauikit 1.0 as Maui

Maui.FileBrowser
{
    id: control
    settings.singleClick:  Maui.FM.loadSettings("SINGLE_CLICK", "BROWSER", Maui.Handy.singleClick) == "true"
    viewType: Maui.FM.loadSettings("VIEW_TYPE", "BROWSER", Maui.FMList.LIST_VIEW)
    onViewTypeChanged: Maui.FM.saveSettings("VIEW_TYPE", viewType, "BROWSER")

    headBar.rightContent: ToolButton
    {
        visible: terminal
        icon.name: "utilities-terminal"
        onClicked: toogleTerminal()
        checked : terminalVisible
        checkable: false
    }

    onKeyPress:
    {
        if(event.key === Qt.Key_F4)
        {
            toogleTerminal()
        }

        if((event.key === Qt.Key_K) && (event.modifiers & Qt.ControlModifier))
        {
            if(_pathBarLoader.sourceComponent !== _pathBarComponent)
                root.searchBar= false

            _pathBarLoader.item.showEntryBar()
        }
    }

    onCurrentPathChanged:
    {
        root.title = Maui.FM.getFileInfo(browser.currentPath).label
        syncTerminal()
        if(root.searchBar)
            root.searchBar = false

        placesSidebar.currentIndex = -1

        for(var i = 0; i < placesSidebar.count; i++)
            if(String(currentPath) === placesSidebar.list.get(i).path)
            {
                placesSidebar.currentIndex = i
                return;
            }
    }

    onItemClicked:
    {
        if(browser.settings.singleClick)
            openItem(index)
    }

    onItemDoubleClicked:
    {
        if(!browser.settings.singleClick)
        {
            openItem(index)
            return;
        }

        if(Kirigami.Settings.isMobile)
            return

        const item = currentFMList.get(index)
        if(item.mime === "inode/directory")
            control.openFolder(item.path)
        else
            control.openFile(item.path)
    }

    selectionBar.actions:[
        Action
        {
            text: qsTr("Open")
            icon.name: "document-open"
            onTriggered:
            {

                for(var i in selectionBar.uris)
                    control.openFile(selectionBar.uris[i])

            }
        },

        Action
        {
            text: qsTr("Tags")
            icon.name: "tag"
            onTriggered:
            {
                control.tagFiles(selectionBar.uris)
            }
        },

        Action
        {
            text: qsTr("Share")
            icon.name: "document-share"
            onTriggered:
            {
                control.shareFiles(selectionBar.uris)
            }
        },

        Action
        {
            text: qsTr("Copy")
            icon.name: "edit-copy"
            onTriggered:
            {
                control.selectionBar.animate()
                control.copy(selectionBar.uris)
            }
        },

        Action
        {
            text: qsTr("Cut")
            icon.name: "edit-cut"
            onTriggered:
            {
                control.selectionBar.animate()
                control.cut(selectionBar.uris)
            }
        },

        Action
        {
            text: qsTr("Remove")
            icon.name: "edit-delete"

            onTriggered:
            {
                control.remove(selectionBar.uris)
            }
        }
    ]

    function syncTerminal()
    {
        if(root.terminal && root.terminalVisible)
            root.terminal.session.sendText("cd '" + String(currentPath).replace("file://", "") + "'\n")

    }

    function toogleTerminal()
    {
        terminalVisible = !terminalVisible
        Maui.FM.saveSettings("TERMINAL", terminalVisible, "EXTENSIONS")
    }
}
