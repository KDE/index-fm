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
    collapsedSize: stick ?  Maui.Style.iconSizes.medium + (Maui.Style.space.medium*4) - Maui.Style.space.tiny : 0
    collapsed : !root.isWide
    stick: Maui.FM.loadSettings("STICK_SIDEBAR", "UI", true)
    preferredWidth: Math.min(Kirigami.Units.gridUnit * (Maui.Handy.isWindows ?  15 : 11), root.width)
    iconSize: privateProperties.isCollapsed && stick ? Maui.Style.iconSizes.medium : Maui.Style.iconSizes.small

    Behavior on iconSize
    {
        NumberAnimation
        {
            duration: Kirigami.Units.shortDuration
            easing.type: Easing.InOutQuad
        }
    }

    onPlaceClicked:
    {
        currentBrowser.openFolder(path)
        if(placesSidebar.modal)
            placesSidebar.collapse()
    }

    model: Maui.BaseModel
    {
        list:  Maui.PlacesList
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
    }

    delegate: Maui.ListDelegate
    {
        id: itemDelegate
        width: ListView.view.width
        iconSize: control.iconSize
        labelVisible: control.showLabels
        label: model.label
        count: model.count > 0 ? model.count : ""
        iconName: model.icon +  (Qt.platform.os == "android" || Qt.platform.os == "osx" ? ("-sidebar") : "")
        iconVisible: true
//        template.leftMargin: privateProperties.isCollapsed && stick ? 0 : Maui.Style.space.medium

        onClicked:
        {
            control.currentIndex = index
            placesList.clearBadgeCount(index)

            placeClicked(model.path)
            if(control.collapsed)
                control.collapse()
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
    }

    section.property: !showLabels ? "" : "type"
    section.criteria: ViewSection.FullString
    section.delegate: Maui.LabelDelegate
    {
        id: delegate
        width: control.width
        label: section
        labelTxt.font.pointSize: Maui.Style.fontSizes.big
        isSection: true
        height: Maui.Style.toolBarHeightAlt

        onClicked:
        {
            placesList.toggleSection(Maui.FMList.QUICK_PATH)
        }
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
            visible: root.currentTab.count === 1 && root.supportSplit
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
