// Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2018-2020 Nitrux Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later


import QtQuick 2.14
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.8 as Kirigami
import org.kde.mauikit 1.0 as Maui
import QtQml.Models 2.3

SplitView
{
    id: control

    readonly property int _index : ObjectModel.index
    property alias browser : _browser
    property alias currentPath: _browser.currentPath
    property alias settings : _browser.settings
    property alias title : _browser.title

    //    property bool terminalVisible : Maui.FM.loadSettings("TERMINAL", "EXTENSIONS", false) == "true"
    property bool terminalVisible : false
    readonly property bool supportsTerminal : terminalLoader.item

    spacing: 0
    orientation: Qt.Vertical
    SplitView.fillHeight: true
    SplitView.fillWidth: true

    SplitView.preferredHeight: _splitView.orientation === Qt.Vertical ? _splitView.height / (_splitView.count) :  _splitView.height
    SplitView.minimumHeight: _splitView.orientation === Qt.Vertical ?  200 : 0

    SplitView.preferredWidth: _splitView.orientation === Qt.Horizontal ? _splitView.width / (_splitView.count) : _splitView.width
    SplitView.minimumWidth: _splitView.orientation === Qt.Horizontal ? 300 :  0

    opacity: _splitView.currentIndex === _index ? 1 : 0.7

    onCurrentPathChanged:
    {
        syncTerminal(currentBrowser.currentPath)
    }

    handle: Rectangle
    {
        implicitWidth: 6
        implicitHeight: 6
        color: SplitHandle.pressed ? Kirigami.Theme.highlightColor
                                   : (SplitHandle.hovered ? Qt.lighter(Kirigami.Theme.backgroundColor, 1.1) : Kirigami.Theme.backgroundColor)

        Rectangle
        {
            anchors.centerIn: parent
            width: 48
            height: parent.height
            color: _splitSeparator.color
        }

        Kirigami.Separator
        {
            id: _splitSeparator
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.left: parent.left
        }

        Kirigami.Separator
        {
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.left: parent.left
        }
    }

    Maui.FileBrowser
    {
        id: _browser
        SplitView.fillWidth: true
        SplitView.fillHeight: true

        selectionBar: root.selectionBar
        previewer: root.previewer
        shareDialog: root.shareDialog
        openWithDialog: root.openWithDialog
        tagsDialog: root.tagsDialog
        thumbnailsSize: root.iconSize * 1.7
        selectionMode: root.selectionMode
        onSelectionModeChanged:
        {
            root.selectionMode = selectionMode
            selectionMode = Qt.binding(function() { return root.selectionMode })
        } // rebind this property in case filebrowser breaks it

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

        itemMenu.contentData : [

            MenuSeparator {visible: _browser.itemMenu.isDir},

            MenuItem
            {
                visible: _browser.itemMenu.isDir
                text: i18n("Open in new tab")
                icon.name: "tab-new"
                onTriggered: root.openTab(_browser.itemMenu.item.path)
            },

            MenuItem
            {
                visible: _browser.itemMenu.isDir && root.currentTab.count === 1 && root.supportSplit
                text: i18n("Open in split view")
                icon.name: "view-split-left-right"
                onTriggered: root.currentTab.split(_browser.itemMenu.item.path, Qt.Horizontal)
            }
        ]

        Connections
        {
            target: _browser.dropArea
            ignoreUnknownSignals: true
            function onEntered()
            {
                _splitView.currentIndex = control._index
            }
        }

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

            if((event.key === Qt.Key_N) && (event.modifiers & Qt.ControlModifier))
            {
                newFolder()
            }

            if((event.key === Qt.Key_N) && (event.modifiers & Qt.ControlModifier) && (event.modifiers & Qt.ShiftModifier))
            {
                newFile()
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

    Loader
    {
        id: terminalLoader
        active: inx.supportsEmbededTerminal()
        visible: active && terminalVisible
        SplitView.fillWidth: true
        SplitView.preferredHeight: 200
        SplitView.maximumHeight: parent.height * 0.5
        SplitView.minimumHeight : 100
        source: "Terminal.qml"

        Behavior on Layout.preferredHeight
        {
            NumberAnimation
            {
                duration: Kirigami.Units.longDuration
                easing.type: Easing.InQuad
            }
        }

        onVisibleChanged: syncTerminal(control.currentPath)
    }

    Component.onCompleted: syncTerminal(control.currentPath)
    Component.onDestruction: console.log("Destroyed browsers!!!!!!!!")

    function syncTerminal(path)
    {
        if(terminalLoader.item && terminalVisible)
            terminalLoader.item.session.sendText("cd '" + String(path).replace("file://", "") + "'\n")
    }

    function toogleTerminal()
    {
        terminalVisible = !terminalVisible
        //        Maui.FM.saveSettings("TERMINAL", terminalVisible, "EXTENSIONS")
    }
}
