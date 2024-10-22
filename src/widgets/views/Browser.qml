// Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2018-2020 Nitrux Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later


import QtQuick
import QtQuick.Controls

import org.mauikit.controls as Maui
import org.mauikit.filebrowsing as FB

import org.maui.index as Index

import "../previewer"
import ".."

Maui.SplitViewItem
{
    id: control

    readonly property alias browser : _browser
    readonly property alias settings : _browser.settings
    readonly property alias title : _browser.title
    readonly property bool supportsTerminal : terminalLoader.item

    property alias currentPath: _browser.currentPath
    property alias terminalVisible : _dirConf.terminalVisible

    Maui.Controls.title : currentPath

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
        Maui.InfoDialog
        {
            property string tag

            title: i18n("Remove '%1'", tag)
            standardButtons: Dialog.Yes | Dialog.Cancel

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
        Maui.SplitViewItem
        {
            SplitView.fillWidth: true
            SplitView.fillHeight: true
            autoClose: false


            FB.FileBrowser
            {
                id: _browser

                property alias viewType : _dirConf.viewType
                property alias sortBy : _dirConf.sortKey

                anchors.fill: parent

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
                settings.foldersFirst: sortSettings.foldersFirst
                settings.group: sortSettings.group

                settings.sortBy:  _dirConf.sortKey
                settings.viewType: _dirConf.viewType

                Index.FolderConfig
                {
                    id:  _dirConf
                    path: control.currentPath
                    enabled: appSettings.dirConf
                    fallbackSortKey: sortSettings.sortBy
                    fallbackViewType: appSettings.viewType
                }

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

                onKeyPress: (event) =>
                            {
                                if (event.key === Qt.Key_Forward)
                                {
                                    _browser.goForward()
                                    event.accepted = true
                                }

                                if((event.key === Qt.Key_T) && (event.modifiers & Qt.ControlModifier))
                                {
                                    openTab(control.currentPath)
                                    event.accepted = true
                                }

                                // Shortcut for closing tab
                                if((event.key === Qt.Key_W) && (event.modifiers & Qt.ControlModifier))
                                {
                                    if(_browserView.browserList.count > 1)
                                    root.closeTab(tabsBar.currentIndex)
                                    event.accepted = true
                                }

                                if((event.key === Qt.Key_K) && (event.modifiers & Qt.ControlModifier))
                                {
                                    pathBar.pathBar.showEntryBar()
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
                                        openPreview(_browser.currentFMModel.get(_browser.currentIndex).path)
                                    }
                                    event.accepted = true
                                }
                            }

                onItemClicked: (index) =>
                               {
                                   const item = currentFMModel.get(index)

                                   //                handleSelectionState(item)

                                   if(Maui.Handy.singleClick)
                                   {
                                       if(appSettings.previewFiles && item.isdir != "true" && !root.selectionMode)
                                       {
                                           openPreview(item.path)
                                           return
                                       }

                                       openItem(index)
                                   }
                               }

                onItemDoubleClicked: (index) =>
                                     {
                                         const item = currentFMModel.get(index)
                                         //                handleSelectionState(item)

                                         if(!Maui.Handy.singleClick)
                                         {
                                             if(appSettings.previewFiles && item.isdir != "true" && !root.selectionMode)
                                             {
                                                 openPreview(item.path)
                                                 return
                                             }

                                             openItem(index)
                                         }
                                     }

                onItemRightClicked: (index) =>
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
                    popupMainMenu()
                }
            }
        }

        Maui.SplitViewItem
        {
            SplitView.fillWidth: true
            SplitView.preferredHeight: 200
            SplitView.maximumHeight: parent.height * 0.5
            SplitView.minimumHeight : 100
            autoClose: false
            visible: control.terminalVisible || appSettings.showCoverFlow

            Connections
            {
                target: _browser
                function onCurrentPathChanged()
                {
                    if(!control.terminalVisible)
                        _embeddedViews.currentIndex = 1
                }
            }

            Maui.SwipeView
            {
                            id: _embeddedViews
                anchors.fill: parent
                floatingHeader: true
                autoHideHeader: true
                headBar.visible: control.terminalVisible && appSettings.showCoverFlow

                Maui.Theme.colorSet: Maui.Theme.Complementary
                Maui.Theme.inherit: false

                background: Rectangle
                {
                    color: Maui.Theme.backgroundColor
                }

                Loader
                {
                    id: terminalLoader
                    Maui.Controls.title: "Terminal"

                    visible: control.terminalVisible
                    asynchronous: true
                    active: Maui.Handy.isLinux
                }

                Maui.SwipeViewLoader
                {
                    Maui.Controls.title: "Preview"
                    visible: appSettings.showCoverFlow
                    // focus: false

                    ListView
                    {
                        focus: true

                        Keys.enabled: true
                        Keys.forwardTo: _browser
                        Keys.onLeftPressed: _browser.previousItem()
                        Keys.onRightPressed: _browser.nextItem()
                        Keys.onPressed: console.log("KEY PRESSED")

                        model: _browser.currentFMModel
                        currentIndex: _browser.currentIndex
                        orientation: Qt.Horizontal

                        spacing: Maui.Style.space.huge
                        snapMode: ListView.SnapOneItem

                        boundsBehavior: Flickable.StopAtBounds
                                    boundsMovement: Flickable.StopAtBounds

                                    interactive: Maui.Handy.isTouch
                                    highlightFollowsCurrentItem: true
                                    highlightMoveDuration: 0
                                    highlightResizeDuration : 0

                                    onCurrentIndexChanged: positionViewAtIndex(currentIndex, ListView.Center)

                        delegate: Maui.IconItem
                        {

                            scale: ListView.view.currentIndex === index ? 1 : 0.6
                            height: ListView.view.height
                            width: ListView.view.width /3
                            iconSource: model.icon
                            imageSource: model.thumbnail
                            fillMode: Image.PreserveAspectFit

                            iconSizeHint: Maui.Style.iconSizes.huge
                            imageSizeHint: height
                        }
                    }
                }
            }
        }
    }

    Component.onCompleted:
    {
        //set these values in here to avoid global binding them, so each view can have different sorting settings
        settings.foldersFirst = sortSettings.foldersFirst
        settings.group = sortSettings.group

        terminalLoader.setSource("Terminal.qml", ({'session.initialWorkingDirectory': control.currentPath.replace("file://", "")}))
    }

    function syncTerminal(path)
    {
        if(terminalLoader.item && appSettings.syncTerminal && FB.FM.fileExists(path))
            terminalLoader.item.session.changeDir(path.replace("file://", ""))
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

        if(terminalVisible)
        {
            terminalLoader.item.forceActiveFocus()
        }else
        {
            control.forceActiveFocus()
        }
    }

    function forceActiveFocus()
    {
        browser.forceActiveFocus()
    }
}
