// Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2018-2020 Nitrux Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later


import QtQuick 2.14
import QtQml 2.14

import QtQuick.Controls 2.14

import org.mauikit.controls 1.3 as Maui
import org.mauikit.filebrowsing 1.0 as FB

import org.kde.kirigami 2.6 as Kirigami

Maui.AbstractSideBar
{
    id: control

    signal placeClicked (string path)

    collapsible: true
    collapsed : !root.isWide
    preferredWidth: Kirigami.Units.gridUnit * (Maui.Handy.isWindows ?  15 : 13)

    property alias list : placesList

    FB.PlacesList
    {
        id: placesList
        groups: appSettings.sidebarSections
    }

    Loader
    {
        id: _loader
        anchors.fill: parent
        asynchronous: true
        active: (control.enabled && control.visible) || item

        sourceComponent: Maui.ListBrowser
        {
            id: _listBrowser
            topPadding: 0
            bottomPadding: 0
            verticalScrollBarPolicy: ScrollBar.AlwaysOff

            onKeyPress:
            {
                if(event.key === Qt.Key_Return)
                {
                    control.itemClicked(_listBrowser.currentIndex)
                }
            }

            Binding on currentIndex
            {
                value: placesList.indexOfPath(currentBrowser.currentPath)
                restoreMode: Binding.RestoreBindingOrValue
            }

            Maui.Holder
            {
                anchors.bottom: parent.bottom
                height: parent.height - 200
                width: parent.width
                visible: parent.count === 0

                title: i18n("Bookmarks!")
                body: i18n("Your bookmarks will be listed here")
            }

            flickable.topMargin: Maui.Style.space.medium
            flickable.bottomMargin: Maui.Style.space.medium
            flickable.header: Loader
            {
                asynchronous: true
                width: parent.width
                height: item ? item.implicitHeight : 0
                active: appSettings.quickSidebarSection
                visible: active

                sourceComponent: Column
                {
                    spacing: Maui.Style.space.medium

                    Maui.ListBrowserDelegate
                    {
                        width: parent.width
                        iconSizeHint: Maui.Style.iconSizes.small
                        label1.text: i18n("Overview")
                        iconSource: "start-here-symbolic"
                        iconVisible: true
                        isCurrentItem: _stackView.depth === 2
                        onClicked:
                        {
                            if(control.collapsed)
                                control.close()

                            _stackView.push(_homeViewComponent)
                        }
                    }

                    GridView
                    {
                        id: _quickSection
                        implicitHeight: contentHeight +  topMargin+  bottomMargin
                        leftMargin: 0
                        rightMargin: 0
//                        padding: 0
                        currentIndex : _quickPacesList.indexOfPath(currentBrowser.currentPath)
                        width: parent.width
                        cellWidth: Math.floor(parent.width/3)
                        cellHeight: cellWidth
                        interactive: false

                        model: Maui.BaseModel
                        {
                            list: FB.PlacesList
                            {
                                id: _quickPacesList
                                groups: [FB.FMList.QUICK_PATH, FB.FMList.PLACES_PATH]
                            }
                        }

                        delegate: Item
                        {
                            height: GridView.view.cellHeight
                            width: GridView.view.cellWidth

                            Maui.GridBrowserDelegate
                            {
                                isCurrentItem: parent.GridView.isCurrentItem && _stackView.depth === 1
                                anchors.fill: parent
                                anchors.margins: Maui.Style.space.tiny
                                iconSource: model.icon +  (Qt.platform.os == "android" || Qt.platform.os == "osx" ? ("-sidebar") : "")
                                iconSizeHint: Maui.Style.iconSizes.medium
                                template.isMask: true
                                label1.text: model.label
                                labelsVisible: false
                                tooltipText: model.label
                                onClicked:
                                {
                                    placeClicked(model.path)
                                    if(control.collapsed)
                                        control.close()
                                }

                                onRightClicked:
                                {
                                    _menu.path = model.path
                                    _menu.show()
                                }

                                onPressAndHold:
                                {
                                    _menu.path = model.path
                                    _menu.show()
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

            delegate: Maui.ListDelegate
            {
                isCurrentItem: ListView.isCurrentItem && _stackView.depth === 1
                width: ListView.view.width
                template.headerSizeHint: iconSize + Maui.Style.space.small

                iconSize: Maui.Style.iconSizes.small
                label: model.label
                iconName: model.icon +  (Qt.platform.os == "android" || Qt.platform.os == "osx" ? ("-sidebar") : "")
                iconVisible: true

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

                    placeClicked(model.path)
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
                width: control.width
                label: section
                labelTxt.font.pointSize: Maui.Style.fontSizes.big
                isSection: true
                height: Maui.Style.toolBarHeightAlt
            }
        }

    }

    onPlaceClicked:
    {
        currentBrowser.openFolder(path)
        if(control.collapsed)
            control.close()

        if(_stackView.depth === 2)
            _stackView.pop()
    }

    onContentDropped:
    {
        placesList.addPlace(drop.text)
    }

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
            Kirigami.Theme.textColor: Kirigami.Theme.negativeTextColor
            onTriggered: placesList.removePlace(_menu.bookmarkIndex)
        }
    }
}
