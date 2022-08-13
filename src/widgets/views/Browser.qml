// Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2018-2020 Nitrux Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later


import QtQuick 2.15
import QtQuick.Controls 2.15

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

    //    property alias viewType : _dirConf.viewType

    property bool terminalVisible : false
    readonly property bool supportsTerminal : terminalLoader.item

    onCurrentPathChanged:
    {
        if(currentBrowser)
        {
            syncTerminal(currentBrowser.currentPath)
        }
    }

    FileMenu
    {
        id: itemMenu
    }

    Maui.ContextualMenu
    {
        id: _tagMenu
        property string tag

        MenuItem
        {
            text: i18n("Edit")
            icon.name: "document-edit"
            onTriggered:
            {}
        }

        MenuItem
        {
            text: i18n("Remove")
            icon.name: "edit-delete"
            onTriggered:
            {
                dialogLoader.sourceComponent = _removeTagDialogComponent
                dialog.tag = _tagMenu.tag
                dialog.open()
            }
        }
    }

    Component
    {
        id: _removeTagDialogComponent
        Maui.Dialog
        {
            property string tag

            title: i18n("Remove '%1'", tag)
            acceptButton.text: i18n("Accept")
            rejectButton.text: i18n("Cancel")
            page.margins: Maui.Style.space.big
            message: i18n("Are you sure you want to remove this tag? This operation can not be undone.")
            onAccepted:
            {
                FB.Tagging.removeTag(tag, false)
                close()
            }

            onRejected: close()
        }
    }



    Maui.SplitView
    {
        anchors.fill: parent
        anchors.bottomMargin: !selectionBar.hidden && (terminalVisible) ? selectionBar.height : 0
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
                          case 0: return 78;
                          case 1: return 96;
                          case 2: return 126;
                          case 3: return 166;
                          case 4: return 216;
                          default: return 126;
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
//            settings.foldersFirst: sortSettings.foldersFirst
//            settings.sortBy: sortSettings.sortBy
//            settings.group: sortSettings.group
            settings.viewType: appSettings.viewType

            //            Index.FolderConfig
            //            {
            //                id:  _dirConf
            //                path: control.currentPath
            //            }

            browser.holder.actions: [
                Action
                {
                    text: i18n("Create new")
                    enabled:  _browser.currentFMList.status.exists
                    onTriggered: _browser.newItem()
                }
            ]

            Connections
            {
                target: _browser.dropArea
                ignoreUnknownSignals: true
                function onEntered()
                {
                    control.focusSplitItem()
                }
            }

            onKeyPress:
            {
                if (event.key == Qt.Key_Forward)
                {
                    _browser.goForward()
                    event.accepted = true
                }

                if((event.key == Qt.Key_T) && (event.modifiers & Qt.ControlModifier))
                {
                    openTab(control.currentPath)
                    event.accepted = true
                }

                // Shortcut for closing tab
                if((event.key == Qt.Key_W) && (event.modifiers & Qt.ControlModifier))
                {
                    if(_browserView.browserList.count > 1)
                        root.closeTab(tabsBar.currentIndex)
                    event.accepted = true
                }

                if((event.key == Qt.Key_K) && (event.modifiers & Qt.ControlModifier))
                {
                    pathBar.showEntryBar()
                    event.accepted = true
                }

                if(event.key === Qt.Key_F4)
                {
                    toogleTerminal()
                    event.accepted = true
                }

                if(event.key === Qt.Key_F3)
                {
                    toogleSplitView()
                    event.accepted = true
                }

                if((event.key === Qt.Key_N) && (event.modifiers & Qt.ControlModifier))
                {
                    newItem()
                    event.accepted = true
                }

                if(event.key === Qt.Key_Space)
                {
                    if(_browser.currentIndex > -1 && _browser.currentView.count > 0)
                    {
                        openPreview(_browser.currentFMModel, _browser.currentIndex)
                    }
                    event.accepted = true
                }

            }

            onItemClicked:
            {
                const item = currentFMModel.get(index)

//                handleSelectionState(item)

                if(Maui.Handy.singleClick)
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
//                handleSelectionState(item)

                if(!Maui.Handy.singleClick)
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
                const itemIndex = _browser.currentFMModel.mappedToSource(index)
                const item = _browser.currentFMModel.get(index)
//                handleSelectionState(item)

                if(item.path.startsWith("tags://"))
                {
                    _tagMenu.tag = item.label
                    _tagMenu.show()
                }

                if(_browser.currentFMList.pathType !== FB.FMList.TRASH_PATH && _browser.currentFMList.pathType !== FB.FMList.REMOTE_PATH)
                {
                    itemMenu.showFor(itemIndex)
                }
            }

            onRightClicked:
            {
                _mainMenuLoader.item.open()
            }

//            onAreaClicked:
//            {
//                if((mouse.button === Qt.LeftButton) && (mouse.modifiers === Qt.NoModifier) && (!Maui.Handy.isMobile))
//                {
//                    handleSelectionState()
//                }
//            }

        }

        Loader
        {
            id: terminalLoader
            SplitView.fillWidth: true
            SplitView.preferredHeight: 200
            SplitView.maximumHeight: parent.height * 0.5
            SplitView.minimumHeight : 100
            visible: control.terminalVisible
            asynchronous: true
            active: Maui.Handy.isLinux
            source: "Terminal.qml"

            onVisibleChanged:
            {
                syncTerminal(control.currentPath)
                if(item && item.visible)
                {
                    item.forceActiveFocus()
                }
            }
        }
    }

    Component.onCompleted:
    {
        //set these values in here to avoid global binding them, so each view can have different sorting settings
        settings.sortBy = sortSettings.sortBy
        settings.foldersFirst = sortSettings.foldersFirst
        settings.group = sortSettings.group

        syncTerminal(control.currentPath)
    }

    Component.onDestruction: console.log("Destroyed browsers!!!!!!!!")

    function syncTerminal(path)
    {
        if(terminalLoader.item && terminalVisible)
            terminalLoader.item.session.sendText("cd '" + path.replace("file://", "") + "'\n")
    }

    function handleSelectionState(item)
    {
        if((selectionBar.count > 0) && (!Maui.Handy.isMobile) && (!item || !selectionBar.contains(item.url)))
        {
            selectionBar.clear()
        }
    }

    function toogleTerminal()
    {
        terminalVisible = !terminalVisible
    }

    function forceActiveFocus()
    {
        browser.forceActiveFocus()
    }
}
