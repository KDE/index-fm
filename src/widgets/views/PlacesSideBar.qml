// Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2018-2020 Nitrux Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later


import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import org.kde.mauikit 1.2 as Maui
import org.kde.kirigami 2.6 as Kirigami

Maui.SideBar
{
    id: control
    property alias list : placesList
    property alias itemMenu : _menu
    collapsedSize: stick ?  Maui.Style.iconSizes.medium + (Maui.Style.space.medium*4) - Maui.Style.space.tiny : 0
    signal placeClicked (string path)
    focus: true

    model: Maui.BaseModel
    {
        list:  Maui.PlacesList
        {
            id: placesList
            onBookmarksChanged:
            {
                syncSidebar(currentPath)
            }
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

    onItemClicked:
    {
        var item = list.get(index)
        var path = item.path
        console.log(path)
        placesList.clearBadgeCount(index)

        placeClicked(path)
        if(control.collapsed)
            control.collapse()
    }

    onItemRightClicked: _menu.popup()

    Menu
    {
        id: _menu

        MenuItem
        {
            text: i18n("Remove")
            Kirigami.Theme.textColor: Kirigami.Theme.negativeTextColor
            onTriggered: list.removePlace(control.currentIndex)
        }
    }

    background: Rectangle
    {
        color: Kirigami.Theme.backgroundColor
        opacity: translucency ? 0.5 : 1
    }
}
