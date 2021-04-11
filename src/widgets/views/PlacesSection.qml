// Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2018-2020 Slike Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later


import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3

import org.mauikit.controls 1.3 as Maui
import org.mauikit.filebrowsing 1.0 as FB
import org.kde.kirigami 2.14 as Kirigami
import "home"

ColumnLayout
{
    id: control

    Maui.SectionDropDown
    {
        id: _dropDown
        Layout.fillWidth: true
        label1.text: i18n("Bookmarks")
        label2.text: i18n("Quick access to most common places and bookmarks")
        checked: true
    }

    Maui.GridView
    {
        id: _placesGrid
        visible: _dropDown.checked
        Layout.fillWidth: true
        itemSize: Math.min(width, 180)
        itemHeight: 80

        model: Maui.BaseModel
        {
            list:  FB.PlacesList
            {
                id: placesList

                groups: [FB.FMList.PLACES_PATH]
            }
        }

        delegate: Item
        {
            width: _placesGrid.cellWidth
            height: _placesGrid.itemHeight

            Card
            {
                anchors.fill: parent
                anchors.margins: Maui.Style.space.medium

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

                onClicked:
                {
                    _placesGrid.currentIndex = index
                    model.count = 0
                    _stackView.pop()
                    currentBrowser.openFolder(model.path)
                }
            }
        }
    }
}
