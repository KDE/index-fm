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

Maui.SideBar
{
    id: control

    property alias list : placesList

    signal placeClicked (string path)

    collapsible: true
    collapsed : !root.isWide
    preferredWidth: Kirigami.Units.gridUnit * (Maui.Handy.isWindows ?  15 : 13)

    Binding on currentIndex
    {
        value: placesList.indexOfPath(currentPath)
        restoreMode: Binding.RestoreBindingOrValue
    }

    Maui.Holder
    {
        anchors.bottom: parent.bottom
        height: parent.height - 200
        width: parent.width
        visible: listView.count === 0

        title: i18n("Bookmarks!")
        body: i18n("Your bookmarks will be listed here")
    }

    onPlaceClicked:
    {
        currentBrowser.openFolder(path)
        if(placesSidebar.collapsed)
            placesSidebar.close()

        if(_stackView.depth === 2)
            _stackView.pop()
    }

    //    listView.flickable.headerPositioning: ListView.OverlayHeader
    listView.flickable.topMargin: Maui.Style.space.medium
    listView.flickable.bottomMargin: Maui.Style.space.medium
    listView.flickable.header: Column
    {
        id:  _defaultSection
        width: parent.width
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
                if(placesSidebar.collapsed)
                    placesSidebar.close()

                _stackView.push(_homeViewComponent)
            }
        }

        GridView
        {
            id: _toggles
            implicitHeight: contentHeight + Maui.Style.space.medium * 1.5
            currentIndex : _quickPacesList.indexOfPath(currentPath)
            width: parent.width
            cellWidth: Math.floor(parent.width/3)
            cellHeight: cellWidth

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
            control.currentIndex = index
            _menu.show()
        }

        onPressAndHold:
        {
            control.currentIndex = index
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
            onTriggered: list.removePlace(control.currentIndex)
        }
    }

    function syncSidebar(path)
    {
        console.log("Sync sidebar", path)
        //        control.currentIndex = control.list.indexOfPath(path)
    }
}
