// Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2018-2020 Slike Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later


import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3

import org.mauikit.controls 1.3 as Maui
import org.mauikit.filebrowsing 1.0 as FB
import "home"

Maui.SettingsSection
{
    id: control
    title: i18n("Bookmarks")
    description: i18n("Quick access to most common places and bookmarks")

    Maui.GridView
    {
        id: _placesGrid
        verticalScrollBarPolicy: ScrollBar.AlwaysOff
                        horizontalScrollBarPolicy:  ScrollBar.AsNeeded
        currentIndex: -1
        Layout.fillWidth: true
        Layout.preferredHeight: 140
        flickable.flow: GridView.FlowTopToBottom
        itemSize: 220
        itemHeight: 70
        adaptContent: false

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
