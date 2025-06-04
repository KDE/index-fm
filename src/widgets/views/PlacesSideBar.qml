// Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2018-2020 Nitrux Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later


import QtQuick
import QtQml

import QtQuick.Controls
import QtQuick.Layouts

import org.mauikit.controls as Maui
import org.mauikit.filebrowsing as FB

Loader
{
    id: control
    asynchronous: true
    active: (control.enabled && control.visible) || item
    Keys.enabled: false
    focus: false
    readonly property QtObject list: item ? item.list : null

    OpacityAnimator on opacity
    {
        from: 0
        to: 1
        duration: Maui.Style.units.longDuration
        running: control.status === Loader.Ready
    }

    sourceComponent: Pane
    {
        padding: 0
        focus: false
        clip: true
        Maui.Theme.colorSet: Maui.Theme.Window

        background: Rectangle
        {
            color: Maui.Theme.alternateBackgroundColor
            radius: settings.floatyUI ? Maui.Style.radiusV : 0
        }

        contentItem: Maui.ListBrowser
        {
            id: _listBrowser
            verticalScrollBarPolicy: ScrollBar.AlwaysOff
            focus: false
            focusPolicy: Qt.NoFocus
            Keys.enabled: false

            readonly property alias list : placesList

            holder.visible: count === 0
            holder.title: i18n("Bookmarks")
            holder.body: i18n("Your bookmarks will be listed here")

            Binding on currentIndex
            {
                value: placesList.indexOfPath(currentBrowser.currentPath)
                restoreMode: Binding.RestoreBindingOrValue
            }

            Loader
            {
                id: _menuLoader

                asynchronous: true
                sourceComponent: Maui.ContextualMenu
                {
                    id: _menu

                    property string path
                    property int bookmarkIndex : -1

                    onClosed: _menu.bookmarkIndex = -1

                    MenuItem
                    {
                        text: i18n("Open in New Tab")
                        icon.name: "tab-new"
                        onTriggered: openTab(_menu.path)
                    }

                    MenuItem
                    {
                        text: i18n("Open in New Window")
                        icon.name: "window-new"
                        onTriggered: inx.openNewWindow(_menu.path)
                    }

                    MenuItem
                    {
                        enabled: root.currentTab.count === 1
                        text: i18n("Open in Split View")
                        icon.name: "view-split-left-right"
                        onTriggered: currentTab.split(_menu.path, Qt.Horizontal)
                    }

                    MenuSeparator{}

                    MenuItem
                    {
                        enabled: _menu.bookmarkIndex >= 0
                        text: i18n("Remove")
                        icon.name: "edit-delete"
                        Maui.Controls.status: Maui.Controls.Negative
                        onTriggered: placesList.removePlace(_menu.bookmarkIndex)
                    }
                }
            }

            // flickable.topMargin: Maui.Style.contentMargins
            // flickable.bottomMargin: Maui.Style.contentMargins
            flickable.header: Loader
            {
                id: _quickSectionLoader
                asynchronous: true
                width: parent.width
                height: implicitHeight + _listBrowser.spacing*2
                active: appSettings.quickSidebarSection

                OpacityAnimator on opacity
                {
                    from: 0
                    to: 1
                    duration: Maui.Style.units.longDuration
                    running: _quickSectionLoader.status === Loader.Ready
                }

                sourceComponent: GridLayout
                {
                    id: _quickSection

                    rows: 3
                    columns: 3

                    columnSpacing: Maui.Style.defaultSpacing
                    rowSpacing: Maui.Style.defaultSpacing

                    Repeater
                    {
                        model: inx.quickPaths()

                        delegate: Maui.GridBrowserDelegate
                        {
                            Maui.Theme.colorSet: Maui.Theme.Button
                            Maui.Theme.inherit: false

                            Layout.preferredHeight: Math.min(50, width)
                            Layout.preferredWidth: 50
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            Layout.columnSpan: modelData.path === "overview:///" ? 2 : 1

                            isCurrentItem: modelData.path === "overview:///" ? _stackView.depth === 2 : (currentBrowser.currentPath === modelData.path && _stackView.depth === 1)
                            iconSource: modelData.icon +  (Qt.platform.os == "android" || Qt.platform.os == "osx" ? ("-sidebar") : "-symbolic")
                            iconSizeHint: 16
                            template.isMask: true
                            label1.text: modelData.label
                            labelsVisible: false
                            tooltipText: modelData.label
                            flat: false

                            onClicked: (mouse) =>
                                       {
                                           if(modelData.path === "overview:///")
                                           {
                                               _stackView.push(_homeViewComponent)
                                               if(control.collapsed)
                                               control.close()
                                               return
                                           }

                                           openPlace(modelData.path, mouse)

                                       }

                            onRightClicked:
                            {
                                _menuLoader.item.path = modelData.path
                                _menuLoader.item.show()
                            }

                            onPressAndHold:
                            {
                                _menuLoader.item.path = modelData.path
                                _menuLoader.item.show()
                            }
                        }
                    }
                }
            }

            model: Maui.BaseModel
            {
                id: placesModel
                list: FB.PlacesList
                {
                    id: placesList
                    groups: appSettings.sidebarSections
                }
            }

            Component.onCompleted:
            {
                _listBrowser.flickable.positionViewAtBeginning()
            }

            delegate: Maui.ListDelegate
            {
                isCurrentItem: ListView.isCurrentItem && _stackView.depth === 1
                width: ListView.view.width

                iconSize: Maui.Style.iconSize
                label: model.label
                iconName: model.icon +  (Qt.platform.os == "android" || Qt.platform.os == "osx" ? ("-sidebar") : "")
                iconVisible: true
                template.isMask: iconSize <= Maui.Style.iconSizes.medium

                template.content: ToolButton
                {
                    visible: placesList.isDevice(index) && placesList.setupNeeded(index)
                    icon.name: "media-mount"
                    flat: true
                    icon.height: Maui.Style.iconSizes.small
                    icon.width: Maui.Style.iconSizes.small
                    onClicked: placesList.requestSetup(index)
                }

                Action
                {
                    id: _mountAction
                    text: i18n("Mount")
                    onTriggered: placesList.requestSetup(index);
                }

                onClicked: (mouse) =>
                           {
                               if( placesList.isDevice(index) && placesList.setupNeeded(index))
                               {
                                   notify(model.icon, model.label, i18n("This device needs to be mounted before accessing it. Do you want to set up this device?"), [_mountAction])
                               }

                               openPlace(model.path, mouse)
                           }

                onRightClicked:
                {
                    _menuLoader.item.path = model.path
                    _menuLoader.item.bookmarkIndex = index
                    _menuLoader.item.show()
                }

                onPressAndHold:
                {
                    _menuLoader.item.path = model.path
                    _menuLoader.item.bookmarkIndex = index
                    _menuLoader.item.show()
                }
            }

            section.property: "type"
            section.criteria: ViewSection.FullString
            section.delegate: Maui.LabelDelegate
            {
                width: ListView.view.width
                text: section
                isSection: true
                //                height: Maui.Style.toolBarHeightAlt
            }
        }
    }

    function openPlace(path, mouse)
    {

        if(mouse.modifiers & Qt.ControlModifier)
        {
            openTab(path)
        }else if(mouse.modifiers & Qt.AltModifier)
        {
            currentTab.split(path)
        }
        else
        {
            currentBrowser.openFolder(path)
        }

        if(_sideBarView.sideBar.collapsed)
            _sideBarView.sideBar.close()

        if(_stackView.depth === 2)
            _stackView.pop()

        if(control.collapsed)
            control.close()

    }
}


