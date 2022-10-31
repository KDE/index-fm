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

    property alias list : placesList

    FB.PlacesList
    {
        id: placesList
        groups: appSettings.sidebarSections
    }


    sourceComponent: Maui.ListBrowser
    {
        id: _listBrowser
        topPadding: 0
        bottomPadding: 0
        verticalScrollBarPolicy: ScrollBar.AlwaysOff

        signal placeClicked (string path, var mouse)

        holder.visible: count === 0
        holder.title: i18n("Bookmarks!")
        holder.body: i18n("Your bookmarks will be listed here")

        Binding on currentIndex
        {
            value: placesList.indexOfPath(currentBrowser.currentPath)
            restoreMode: Binding.RestoreBindingOrValue
        }

        onPlaceClicked:
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
        }

        //    onContentDropped:
        //    {
        //        placesList.addPlace(drop.text)
        //    }

        Maui.ContextualMenu
        {
            id: _menu

            property string path
            property int bookmarkIndex : -1

            onClosed: _menu.bookmarkIndex = -1

            MenuItem
            {
                text: i18n("Open in new tab")
                icon.name: "tab-new"
                onTriggered: openTab(_menu.path)
            }

            MenuItem
            {
                visible: root.currentTab.count === 1
                text: i18n("Open in split view")
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

        flickable.topMargin: Maui.Style.space.medium
        flickable.bottomMargin: Maui.Style.space.medium
        flickable.header: Loader
        {
            asynchronous: true
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

                        delegate: Item
                        {
                            Layout.preferredHeight: Math.min(50, width)
                            Layout.preferredWidth: 50
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            Layout.columnSpan: modelData.path === "overview:///" ? 2 : 1

                            Maui.GridBrowserDelegate
                            {
                                isCurrentItem: modelData.path === "overview:///" ? _stackView.depth === 2 : (currentBrowser.currentPath === modelData.path && _stackView.depth === 1)
                                anchors.fill: parent
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
                                        if(control.collapsed)
                                            control.close()

                                        _stackView.push(_homeViewComponent)
                                        return
                                    }

                                    placeClicked(modelData.path, mouse)
                                    if(control.collapsed)
                                        control.close()
                                }

                                onRightClicked:
                                {
                                    _menu.path = modelData.path
                                    _menu.show()
                                }

                                onPressAndHold:
                                {
                                    _menu.path = modelData.path
                                    _menu.show()
                                }
                            }
                        }
                    }
                }
            }
        }

        model: Maui.BaseModel
        {
            id: placesModel
            list: placesList
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
                    notify(model.icon, model.label, i18n("This device needs to be mounted before accessing it. Do you want to set up this device?"), mount)
                }

                placeClicked(model.path, mouse)
                if(control.collapsed)
                    control.close()
            }

            onRightClicked:
            {
                _menu.path = model.path
                _menu.bookmarkIndex = index
                _menu.show()
            }

            onPressAndHold:
            {
                _menu.path = model.path
                _menu.bookmarkIndex = index
                _menu.show()
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


