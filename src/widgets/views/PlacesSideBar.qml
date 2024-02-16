// Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2018-2020 Nitrux Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later


import QtQuick 2.14
import QtQml 2.14

import QtQuick.Controls 2.14
import QtQuick.Layouts 1.12

import org.mauikit.controls 1.3 as Maui
import org.mauikit.filebrowsing 1.0 as FB

Loader
{
    id: control
    asynchronous: true
    active: (control.enabled && control.visible) || item

    readonly property var list: item.list

    sourceComponent: Maui.ListBrowser
    {
        id: _listBrowser
        topPadding: 0
        bottomPadding: 0
        verticalScrollBarPolicy: ScrollBar.AlwaysOff

        readonly property alias list : placesList

        signal placeClicked (string path, var mouse)

        holder.visible: count === 0
        holder.title: i18n("Bookmarks")
        holder.body: i18n("Your bookmarks will be listed here")

        Binding on currentIndex
        {
            value: placesList.indexOfPath(currentBrowser.currentPath)
            restoreMode: Binding.RestoreBindingOrValue
        }

        onPlaceClicked: (path, mouse) =>
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

        //    onContentDropped:
        //    {
        //        placesList.addPlace(drop.text)
        //    }

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
                    enabled: control.isDir && Maui.Handy.isLinux
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
                    Maui.Theme.textColor: Maui.Theme.negativeTextColor
                    onTriggered: placesList.removePlace(_menu.bookmarkIndex)
                }
            }
        }

        flickable.topMargin: Maui.Style.contentMargins
        flickable.bottomMargin: Maui.Style.contentMargins
        flickable.header: Loader
        {
            //            asynchronous: true
            width: parent.width
            //                height: item ? item.implicitHeight : 0
            active: appSettings.quickSidebarSection
            visible: active

            sourceComponent: Item
            {
                implicitHeight: _quickSection.implicitHeight

                GridLayout
                {
                    id: _quickSection
                    width: Math.min(parent.width, 180)
                    anchors.centerIn: parent
                    rows: 3
                    columns: 3
                    columnSpacing: Maui.Style.space.small
                    rowSpacing: Maui.Style.space.small

                    Repeater
                    {
                        model: inx.quickPaths()

                        delegate: Maui.GridBrowserDelegate
                        {
                            Layout.preferredHeight: Math.min(50, width)
                            Layout.preferredWidth: 50
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            Layout.columnSpan: modelData.path === "overview:///" ? 2 : 1

                            isCurrentItem: modelData.path === "overview:///" ? _stackView.depth === 2 : (currentBrowser.currentPath === modelData.path && _stackView.depth === 1)
                            iconSource: modelData.icon +  (Qt.platform.os == "android" || Qt.platform.os == "osx" ? ("-sidebar") : "")
                            iconSizeHint: Maui.Style.iconSize
                            template.isMask: true
                            label1.text: modelData.label
                            labelsVisible: false
                            tooltipText: modelData.label
                            flat: false
                            onClicked:
                            {
                                if(modelData.path === "overview:///")
                                {
                                    _stackView.push(_homeViewComponent)
                                    if(control.collapsed)
                                        control.close()
                                    return
                                }

                                placeClicked(modelData.path, mouse)
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

            function mount()
            {
                placesList.requestSetup(index);
            }

            onClicked:
            {
                if( placesList.isDevice(index) && placesList.setupNeeded(index))
                {
                    notify(model.icon, model.label, i18n("This device needs to be mounted before accessing it. Do you want to set up this device?"), mount, i18n("Mount"))
                }

                placeClicked(model.path, mouse)
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
            label: section
            isSection: true
            //                height: Maui.Style.toolBarHeightAlt
        }
    }
}


