// Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2018-2020 Nitrux Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later


import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtQml.Models 2.3
import QtQml 2.14

import org.kde.kirigami 2.8 as Kirigami

import org.mauikit.controls 1.3 as Maui
import org.mauikit.filebrowsing 1.3 as FB

import org.maui.index 1.0 as Index

import "../previewer"
import ".."

Maui.SplitViewItem
{
    id: control

    property alias browser : _browser
    property alias currentPath: _browser.currentPath
    property alias settings : _browser.settings
    property alias title : _browser.title
//    property alias dirConf : _dirConf

//    property alias sortBy : _dirConf.sortKey
//    property alias viewType : _dirConf.viewType

    property bool terminalVisible : false
    readonly property bool supportsTerminal : terminalLoader.item

    onCurrentPathChanged:
    {
        syncTerminal(currentBrowser.currentPath)
    }

    Maui.SplitView
    {
        anchors.fill: parent
        anchors.bottomMargin: selectionBar.visible && (terminalVisible) ? selectionBar.height : 0
        spacing: 0
        orientation: Qt.Vertical      

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
                    control.focusSplitItem()
                }
            }

            MouseArea // to support tbutton go back and forward
            {
                anchors.fill: parent
                propagateComposedEvents: true
                acceptedButtons: Qt.BackButton | Qt.ForwardButton
                //        hoverEnabled: true
                //        onEntered: _splitView.currentIndex = control.index
                onPressed:
                {
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
            asynchronous: true
            active: inx.supportsEmbededTerminal()

            source: "Terminal.qml"

            onVisibleChanged: syncTerminal(control.currentPath)
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
