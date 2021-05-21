// Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2018-2020 Nitrux Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later


import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3
import QtQml.Models 2.3
import QtQml 2.14

import org.kde.kirigami 2.8 as Kirigami
import org.mauikit.controls 1.2 as Maui
import org.mauikit.filebrowsing 1.0 as FB

import org.maui.index 1.0 as Index

import "../previewer"
import ".."

Item
{
    id: control

    readonly property int _index : ObjectModel.index

    property alias browser : _browser
    property alias currentPath: _browser.currentPath
    property alias settings : _browser.settings
    property alias title : _browser.title
//    property alias dirConf : _dirConf

//    property alias sortBy : _dirConf.sortKey
//    property alias viewType : _dirConf.viewType

    property bool terminalVisible : false
    readonly property bool supportsTerminal : terminalLoader.item

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

    SplitView
    {
        anchors.fill: parent
        anchors.bottomMargin: selectionBar.visible && (terminalVisible) ? selectionBar.height : 0
        spacing: 0
        orientation: Qt.Vertical

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

        FB.FileBrowser
        {
            id: _browser

            SplitView.fillWidth: true
            SplitView.fillHeight: true

            altHeader: _browserView.altHeader
            selectionBar: root.selectionBar
            gridItemSize: switch(appSettings.gridSize)
                          {
                          case 0: return Math.floor(48 * 1.5);
                          case 1: return Math.floor(64 * 1.5);
                          case 2: return Math.floor(80 * 1.5);
                          case 3: return Math.floor(124 * 1.5);
                          case 4: return Math.floor(140 * 1.5);
                          default: return Math.floor(80 * 1.5);
                          }

            listItemSize:   switch(appSettings.listSize)
                            {
                            case 0: return 32;
                            case 1: return 48;
                            case 2: return 64;
                            case 3: return 96;
                            case 4: return 120;
                            default: return 96;
                            }

            selectionMode: root.selectionMode
            onSelectionModeChanged:
            {
                root.selectionMode = selectionMode
                selectionMode = Qt.binding(function() { return root.selectionMode })
            } // rebind this property in case filebrowser breaks it

            settings.showHiddenFiles: appSettings.showHiddenFiles
            settings.showThumbnails: appSettings.showThumbnails
            settings.foldersFirst: true
            settings.sortBy: sortSettings.sortBy
            settings.group: sortSettings.group
//            settings.viewType: _dirConf.viewType

//            Index.FolderConfig
//            {
//                id:  _dirConf
//                path: control.currentPath
//            }

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

            FileMenu
            {
                id: itemMenu
            }

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
                acceptedButtons: Qt.BackButton | Qt.ForwardButton
                //        hoverEnabled: true
                //        onEntered: _splitView.currentIndex = control.index
                onPressed:
                {
                    _splitView.currentIndex = control._index
                    mouse.accepted = false
                    _browser.keyPress(mouse);
                }
            }

            onKeyPress:
            {
                if (event.key == Qt.Key_Forward)
                {
                    _browser.goForward()
                }

                if((event.key == Qt.Key_T) && (event.modifiers & Qt.ControlModifier))
                {
                    openTab(control.currentPath)
                }

                // Shortcut for closing tab
                if((event.key == Qt.Key_W) && (event.modifiers & Qt.ControlModifier))
                {
                    if(_browserView.browserList.count > 1)
                        root.closeTab(tabsBar.currentIndex)
                }

                if((event.key == Qt.Key_K) && (event.modifiers & Qt.ControlModifier))
                {
                    _pathBar.showEntryBar()
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
                    newItem()
                }

                if(event.key === Qt.Key_Space)
                {
                    openPreview(_browser.currentFMModel, _browser.currentIndex)
                }

                if(event.button === Qt.BackButton)
                {
                    _browser.goBack()
                }

                //@gadominguez At this moment this function doesnt work because goForward not exist
                if(event.button === Qt.ForwardButton)
                {
                    _browser.goForward()
                }

            }

            onItemClicked:
            {
                const item = currentFMModel.get(index)

                if(appSettings.singleClick)
                {
                    if(appSettings.previewFiles && item.isdir != "true" && !root.selectionMode)
                    {
                        openPreview(_browser.currentFMModel, _browser.currentIndex)
                        return
                    }

                    openItem(index)
                }
            }

            onItemDoubleClicked:
            {
                const item = currentFMModel.get(index)

                if(!appSettings.singleClick)
                {
                    if(appSettings.previewFiles && item.isdir != "true" && !root.selectionMode)
                    {
                        openPreview(_browser.currentFMModel, _browser.currentIndex)
                        return
                    }

                    openItem(index)
                }
            }

            onItemRightClicked:
            {

                if(_browser.currentFMList.pathType !== FB.FMList.TRASH_PATH && _browser.currentFMList.pathType !== FB.FMList.REMOTE_PATH)
                   {
                     itemMenu.show(index)
                }
            }

            onRightClicked:
            {
                _browserView.browserMenu.open()
            }
        }

        Loader
        {
            id: terminalLoader
            SplitView.fillWidth: true
            SplitView.preferredHeight: 200
            SplitView.maximumHeight: parent.height * 0.5
            SplitView.minimumHeight : 100
            visible: active && control.terminalVisible

            active: inx.supportsEmbededTerminal()

            source: "Terminal.qml"

            onVisibleChanged: syncTerminal(control.currentPath)
        }
    }

    MouseArea
    {
        anchors.fill: parent
        enabled: _splitView.currentIndex !== _index
        propagateComposedEvents: false
        preventStealing: true
        onClicked:
        {
            _splitView.currentIndex = _index
            browser.forceActiveFocus()
        }
    }

    Component.onCompleted:
    {
        syncTerminal(control.currentPath)
    }

    Component.onDestruction: console.log("Destroyed browsers!!!!!!!!")

    function syncTerminal(path)
    {
        if(terminalLoader.item && terminalVisible)
            terminalLoader.item.session.sendText("cd '" + String(path).replace("file://", "") + "'\n")
    }

    function toogleTerminal()
    {
        terminalVisible = !terminalVisible
    }

}
