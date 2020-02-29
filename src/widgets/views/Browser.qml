import QtQuick 2.9
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.0 as Kirigami
import org.kde.mauikit 1.0 as Maui

Maui.FileBrowser
{
    id: control

    property int index

    SplitView.fillHeight: true
    SplitView.fillWidth: true
    SplitView.preferredHeight: _splitView.orientation === Qt.Vertical ? _splitView.height / (_splitView.count) :  _splitView.height
    SplitView.minimumHeight: _splitView.orientation === Qt.Vertical ?  200 : 0
    SplitView.preferredWidth: _splitView.orientation === Qt.Horizontal ? _splitView.width / (_splitView.count) : _splitView.width
    SplitView.minimumWidth: _splitView.orientation === Qt.Horizontal ? 300 :  0

    selectionBar: root.selectionBar
    previewer: root.previewer
    selectionMode: root.selectionMode
    settings.showHiddenFiles: root.showHiddenFiles
showStatusBar: root.showStatusBar

    MouseArea
    {
        anchors.fill: parent
        propagateComposedEvents: true
//        hoverEnabled: true
//        onEntered: _splitView.currentIndex = control.index
        onPressed:
        {
            _splitView.currentIndex = control.index
            mouse.accepted = false
        }
    }

    onKeyPress:
    {
        if((event.key == Qt.Key_T) && (event.modifiers & Qt.ControlModifier))
        {
            openTab(control.currentPath)
        }

        // Shortcut for closing tab
        if((event.key == Qt.Key_W) && (event.modifiers & Qt.ControlModifier))
        {
            if(tabsBar.count > 1)
                closeTab(tabsBar.currentIndex)
        }

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
        syncTerminal(control.currentPath)
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
        if(control.singleClick)
            openItem(index)
    }

    onItemDoubleClicked:
    {
        if(!control.singleClick)
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



}
