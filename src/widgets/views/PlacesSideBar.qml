// Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2018-2020 Nitrux Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later


import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3
import org.kde.mauikit 1.2 as Maui
import org.kde.kirigami 2.6 as Kirigami

Maui.SideBar
{
    id: control

    property alias list : placesList

    signal placeClicked (string path)

    collapsible: true
    collapsed : !root.isWide
    preferredWidth: Math.min(Kirigami.Units.gridUnit * (Maui.Handy.isWindows ?  15 : 11), root.width)

    onPlaceClicked:
    {
        currentBrowser.openFolder(path)
        if(placesSidebar.collapsed)
            placesSidebar.collapse()

        if(_stackView.depth === 2)
            _stackView.pop()
    }

    listView.flickable.header: Maui.ListDelegate
    {
        width: parent.width
        iconSize: Maui.Style.iconSizes.small
        label: i18n("Overview")
        iconName: "start-here-symbolic"
        iconVisible: true

        onClicked: _stackView.push(_homeViewComponent)
    }

    model: Maui.PlacesList
    {
        id: placesList

        groups: [
                Maui.FMList.QUICK_PATH,
                Maui.FMList.PLACES_PATH,
                Maui.FMList.REMOTE_PATH,
                Maui.FMList.REMOVABLE_PATH,
                Maui.FMList.DRIVES_PATH]

        onBookmarksChanged:
        {
            syncSidebar(currentPath)
        }
    }

    delegate: Maui.ListDelegate
    {
        width: ListView.view.width
        iconSize: Maui.Style.iconSizes.small
        label: model.name
        count: model.count > 0 ? model.count : ""
        iconName: model.icon.name() +  (Qt.platform.os == "android" || Qt.platform.os == "osx" ? ("-sidebar") : "")
        iconVisible: true

        onClicked:
        {
            control.currentIndex = index
            placesList.clearBadgeCount(index)



            placeClicked(model.url)
            if(control.collapsed)
                control.close()
        }

        onRightClicked:
        {
            control.currentIndex = index
            _menu.popup()
        }

        onPressAndHold:
        {
            control.currentIndex = index
            _menu.popup()
        }

        ToolButton
        {
            flat: true
            icon.name: "media-eject"
            visible: model.setup
        }
    }

    section.property: "type"
    section.criteria: ViewSection.FullString
    section.delegate: Maui.LabelDelegate
    {
        id: delegate
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

    Menu
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
            visible: root.currentTab.count === 1 && settings.supportSplit
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
}
