import QtQuick 2.9
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.8 as Kirigami
import org.kde.mauikit 1.0 as Maui
import QtQml.Models 2.3

Maui.FileBrowser
{
    id: control
    readonly property int _index : ObjectModel.index

    SplitView.fillHeight: true
    SplitView.fillWidth: true
    SplitView.preferredWidth: _splitView.width / (_splitView.count)
    SplitView.minimumWidth: _splitView.count > 1 ? 300 : 0

    selectionBar: root.selectionBar
    previewer: root.previewer
    shareDialog: root.shareDialog
    openWithDialog: root.openWithDialog
    tagsDialog: root.tagsDialog

    selectionMode: root.selectionMode
    showStatusBar: root.showStatusBar
    settings.showHiddenFiles: root.showHiddenFiles
    settings.showThumbnails: root.showThumbnails

    Rectangle
    {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 2
        opacity: 1
        color: Kirigami.Theme.highlightColor
        visible: _splitView.currentIndex === _index && _splitView.count === 2
    }

    opacity: _splitView.currentIndex === _index ? 1 : 0.7

    itemMenu.contentData : [

        MenuSeparator {visible: itemMenu.isDir},

        MenuItem
        {
            visible: itemMenu.isDir
            text: qsTr("Open in new tab")
            icon.name: "tab-new"
            onTriggered: root.openTab(itemMenu.item.path)
        },

        MenuItem
        {
            visible: itemMenu.isDir && root.currentTab.count === 1 && root.supportSplit
            text: qsTr("Open in new split")
            icon.name: "view-split-left-right"
            onTriggered: root.currentTab.split(itemMenu.item.path, Qt.Horizontal)
        }
    ]

    MouseArea
    {
        anchors.fill: parent
        propagateComposedEvents: true
        //        hoverEnabled: true
        //        onEntered: _splitView.currentIndex = control.index
        onPressed:
        {
            _splitView.currentIndex = control._index
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

        if(event.key === Qt.Key_F3)
        {
            toogleSplitView()
        }

        if((event.key === Qt.Key_K) && (event.modifiers & Qt.ControlModifier))
        {
            _pathBar.showEntryBar()
        }
    }

    onItemClicked:
    {
        if(root.singleClick)
            openItem(index)
    }

    onItemDoubleClicked:
    {
        if(!root.singleClick)
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
