// Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2018-2020 Slike Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later


import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3
import Qt.labs.platform 1.1

import org.mauikit.controls 1.3 as Maui
import org.mauikit.filebrowsing 1.0 as FB
import "home"

SectionGroup
{
    id: control
    title: i18n("Places")
    description: i18n("Quick access to common places.")

    browser.itemSize: 220
    browser.itemHeight: 70
    browser.implicitHeight: 140

    baseModel.list:  FB.PlacesList
    {
        id: placesList

        groups: [FB.FMList.PLACES_PATH]
    }

    template.template.content: Button
    {
        icon.name: "list-add"
        text: i18n("More")
        onClicked: openTab(StandardPaths.writableLocation(StandardPaths.HomeLocation))
    }

    browser.delegate: Item
    {
        height: GridView.view.cellHeight
        width: GridView.view.cellWidth

        Card
        {
            anchors.fill: parent
            anchors.margins: Maui.Style.space.small
            iconVisible: true
            iconSizeHint: Maui.Style.iconSizes.big
            label1.text: model.label
            label2.text: Qt.formatDateTime(new Date(model.modified), "d MMM yyyy")
            iconSource: model.icon
            checkable: selectionMode

            Maui.Badge
            {
                visible: model.count > 0
                text: model.count
            }

            onClicked: (index) =>
            {
                control.currentIndex = index
                model.count = 0
                _stackView.pop()
                currentBrowser.openFolder(model.path)
            }
        }
    }
}
