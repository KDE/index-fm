// Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2018-2020 Nitrux Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later


import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.12

import org.mauikit.controls 1.3 as Maui
import org.mauikit.filebrowsing 1.0 as FB
import org.kde.kirigami 2.6 as Kirigami

Maui.AbstractSideBar
{
    id: control

    property alias list : placesList

    signal placeClicked (string path)

    collapsible: true
    collapsed : !root.isWide
    preferredWidth: Kirigami.Units.gridUnit * (Maui.Handy.isWindows ?  15 : 13)

    onPlaceClicked:
    {
        currentBrowser.openFolder(path)
        if(placesSidebar.collapsed)
            placesSidebar.close()

        if(_stackView.depth === 2)
            _stackView.pop()
    }

    Maui.Page
    {
        anchors.fill: parent
        altHeader: Kirigami.Settings.isMobile

        headBar.farLeftContent: ToolButton
        {
            icon.name: "sidebar-collapse"
            onClicked: placesSidebar.toggle()
            checked: placesSidebar.visible
            ToolTip.delay: 1000
            ToolTip.timeout: 5000
            ToolTip.visible: hovered
            ToolTip.text: i18n("Toogle SideBar")
        }

        headBar.middleContent: Maui.ListBrowserDelegate
        {
            Layout.fillWidth: true
            iconSizeHint: Maui.Style.iconSizes.small
            label1.text: i18n("Overview")
            iconSource: "start-here-symbolic"
            iconVisible: true
            isCurrentItem: _stackView.depth === 2
            onClicked:
            {
                if(placesSidebar.collapsed)
                    placesSidebar.close()

                _stackView.push(_homeViewComponent)
            }
        }

        Maui.ListBrowser
        {
            id: _listView
            anchors.fill: parent
            currentIndex: list.indexOfPath(currentPath)
            topPadding: 0

            //    listView.flickable.headerPositioning: ListView.OverlayHeader
            flickable.header: Column
            {
                width: parent.width
                spacing: Maui.Style.space.medium

                Maui.LabelDelegate
                {
                    width: control.width
                    label: i18n("Places")
                    labelTxt.font.pointSize: Maui.Style.fontSizes.big
                    isSection: true
                    height: Maui.Style.toolBarHeightAlt
                }

                Maui.GridView
                {
                    id: _toggles
                    clip: true
                    implicitHeight: contentHeight + Maui.Style.space.medium * 2
                    //verticalSrollBarPolicy: ScrollBar.AlwaysOff
                    currentIndex : _quickPacesList.indexOfPath(currentPath)
                    width: parent.width
                    itemSize: width * 0.3
                    padding: 0

                    model: Maui.BaseModel
                    {
                        list: FB.PlacesList
                        {
                            id: _quickPacesList

                            groups: [
                                FB.FMList.QUICK_PATH,
                                FB.FMList.PLACES_PATH
                            ]
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
                            label1.text: model.label
                            labelsVisible: false
                            tooltipText: model.label
                            onClicked:
                            {
                                placeClicked(model.path)
                                if(control.collapsed)
                                    control.close()
                            }
                        }
                    }
                }

            }

            model: Maui.BaseModel
            {
                list: FB.PlacesList
                {
                    id: placesList

                    groups: [
                        FB.FMList.BOOKMARKS_PATH,
                        FB.FMList.REMOTE_PATH,
                        FB.FMList.REMOVABLE_PATH,
                        FB.FMList.DRIVES_PATH]

                    onBookmarksChanged:
                    {
                        syncSidebar(currentPath)
                    }
                }
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
                    _listView.currentIndex = index
                    _menu.show()
                }

                onPressAndHold:
                {
                    _listView.currentIndex = index
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


    onContentDropped:
    {
        placesList.addPlace(drop.text)
    }

    Maui.ContextualMenu
    {
        id: _menu

        MenuItem
        {
            text: i18n("Open in new tab")
            icon.name: "tab-new"
            onTriggered: openTab(control.model.get(placesSidebar.currentIndex).path)
        }

        MenuItem
        {
            visible: root.currentTab.count === 1
            text: i18n("Open in split view")
            icon.name: "view-split-left-right"
            onTriggered: currentTab.split(control.model.get(placesSidebar.currentIndex).path, Qt.Horizontal)
        }

        MenuSeparator{}

        MenuItem
        {
            text: i18n("Remove")
            Kirigami.Theme.textColor: Kirigami.Theme.negativeTextColor
            onTriggered: list.removePlace(_listView.currentIndex)
        }
    }

    function syncSidebar(path)
    {
        console.log("Sync sidebar", path)
        //        control.currentIndex = control.list.indexOfPath(path)
    }
}
