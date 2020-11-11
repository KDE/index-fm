// Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2018-2020 Nitrux Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later


import QtQuick 2.14
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.3
import QtQml.Models 2.3
import QtQml 2.14

import org.kde.kirigami 2.8 as Kirigami
import org.kde.mauikit 1.2 as Maui
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

    readonly property bool previewerVisible : _stackView.depth === 2
    //    property bool terminalVisible : Maui.FM.loadSettings("TERMINAL", "EXTENSIONS", false) == "true"
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

    Component
    {
        id: _previewerComponent

        FilePreviewer
        {
            model: _browser.currentFMModel
            //            currentIndex: _browser.currentIndex
            headBar.farLeftContent: ToolButton
            {
                icon.name: "go-previous"
                onClicked:
                {
                    _stackView.pop(StackView.Immediate)
                }
            }

            Component.onCompleted:
            {
                listView.forceActiveFocus()
                listView.currentIndex = Qt.binding(function() { return _browser.currentIndex })
            }
        }
    }

    SplitView
    {
        anchors.fill: parent
        anchors.bottomMargin: _selectionBar.visible && (terminalVisible | _stackView.depth == 2) ? _selectionBar.height : 0
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

        StackView
        {
            id: _stackView

            SplitView.fillWidth: true
            SplitView.fillHeight: true

            initialItem: Maui.FileBrowser
            {
                id: _browser

                selectionBar: root.selectionBar
                thumbnailsSize: appSettings.iconSize * 1.7
                selectionMode: root.selectionMode
                onSelectionModeChanged:
                {
                    root.selectionMode = selectionMode
                    selectionMode = Qt.binding(function() { return root.selectionMode })
                } // rebind this property in case filebrowser breaks it

                settings.showHiddenFiles: appSettings.showHiddenFiles
                settings.showThumbnails: appSettings.showThumbnails
                settings.foldersFirst: sortSettings.globalSorting ? sortSettings.foldersFirst : true
                settings.sortBy: sortSettings.sortBy
                settings.group: sortSettings.group

                Binding
                {
                    target: _browser.settings
                    property: "sortBy"
                    when: sortSettings.globalSorting
                    value: sortSettings.sortBy
                    restoreMode: Binding.RestoreBindingOrValue
                }

                Binding
                {
                    target: _browser.settings
                    property: "group"
                    when: sortSettings.globalSorting
                    value: sortSettings.group
                    restoreMode: Binding.RestoreBindingOrValue
                }

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

                    MenuSeparator {},

                    MenuItem
                    {
                        visible: !control.isExec && openWithDialog
                        text: i18n("Open with")
                        icon.name: "document-open"
                        onTriggered:
                        {
                            openWith([_browser.itemMenu.item.path])
                        }
                    },

                    MenuItem
                    {
                        visible: !control.isExec
                        text: i18n("Share")
                        icon.name: "document-share"
                        onTriggered:
                        {
                            shareFiles([_browser.itemMenu.item.path])
                        }
                    },

                    MenuItem
                    {
                        visible: !control.isExec && tagsDialog
                        text: i18n("Tags")
                        icon.name: "tag"
                        onTriggered:
                        {
                            tagsDialog.composerList.urls = [_browser.itemMenu.item.path]
                            tagsDialog.open()
                        }
                    },

                    MenuItem
                    {
                        visible: Maui.FM.checkFileType(Maui.FMList.COMPRESSED, _browser.itemMenu.item.mime)
                        text: i18n("Extract")
                        icon.name: "archive-extract"
                        onTriggered:
                        {
                            console.log("@gadominguez File: FileMenu.qml Extract with ARK Item: " + _browser.itemMenu.item.path)
                            //                    extractArk(item);
                            _compressedFile.url = _browser.itemMenu.item.path
                            dialogLoader.sourceComponent= _extractDialogComponent
                            dialog.open()
                        }
                    },

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
                        visible: _browser.itemMenu.isDir && root.currentTab.count === 1 && appSettings.supportSplit
                        text: i18n("Open in split view")
                        icon.name: "view-split-left-right"
                        onTriggered: root.currentTab.split(_browser.itemMenu.item.path, Qt.Horizontal)
                    },

                    MenuSeparator {},

                    MenuItem
                    {
                        visible: !_browser.itemMenu.isExec
                        text: i18n("Preview")
                        icon.name: "view-preview"
                        onTriggered:
                        {
                            //                        previewer.show(_browser.currentFMModel, _browser.currentView.currentIndex)
                            _stackView.push(_previewerComponent, StackView.Immediate)
                        }
                    },

                    MenuSeparator{ visible: colorBar.visible },

                    MenuItem
                    {
                        height: visible ? Maui.Style.iconSizes.medium + Maui.Style.space.big : 0
                        visible: _browser.itemMenu.isDir
                        ColorsBar
                        {
                            id: colorBar
                            anchors.centerIn: parent
                            size: Maui.Style.iconSizes.medium
                            onColorPicked: _browser.currentFMList.setDirIcon(_browser.itemMenu.index, color)
                        }
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
                        if(tabsObjectModel.count > 1)
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
                        newFolder()
                    }

                    if((event.key === Qt.Key_N) && (event.modifiers & Qt.ControlModifier) && (event.modifiers & Qt.ShiftModifier))
                    {
                        newFile()
                    }

                    if(event.key === Qt.Key_Space)
                    {
                        _stackView.push(_previewerComponent, StackView.Immediate)
                    }
                }

                onItemClicked:
                {
                    const item = currentFMList.get(index)

                    if(appSettings.singleClick)
                    {
                        if(appSettings.previewFiles && item.isdir != "true" && !root.selectionMode)
                        {
                            _stackView.push(_previewerComponent, StackView.Immediate)
                            return
                        }

                        openItem(index)
                    }
                }

                onItemDoubleClicked:
                {
                    const item = currentFMList.get(index)

                    if(!appSettings.singleClick)
                    {
                        if(appSettings.previewFiles && item.isdir != "true" && !root.selectionMode)
                        {
                            _stackView.push(_previewerComponent)
                            return
                        }

                        openItem(index)
                    }
                }
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
    }

    MouseArea
    {
        anchors.fill: parent
        enabled: _splitView.currentIndex !== _index
        propagateComposedEvents: false
        preventStealing: true
        onClicked: _splitView.currentIndex = _index
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
