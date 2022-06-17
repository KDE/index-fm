// Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2018-2020 Slike Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later


import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3
import org.mauikit.controls 1.3 as Maui

import org.mauikit.filebrowsing 1.0 as FB

Maui.SettingsSection
{
    id: control
    property alias listModel : _model
    property alias currentIndex : _favsGrid.currentIndex

    signal itemClicked(url url)

    title: i18n("Favorite files")
    description: i18n("Your files marked as favorites")

    Maui.GridView
    {
        id: _favsGrid
        verticalScrollBarPolicy: ScrollBar.AlwaysOff
                        horizontalScrollBarPolicy:  ScrollBar.AsNeeded
        currentIndex: -1
        Layout.fillWidth: true
        Layout.preferredHeight: 220
        flickable.flow: GridView.FlowTopToBottom
        itemSize: 220
        itemHeight: 70
        adaptContent: false

        model: Maui.BaseModel
        {
            id: _model
            list: FB.FMList
            {
                path: "tags:///fav"
            }
        }

        delegate: Item
        {
            height: GridView.view.cellHeight
            width: GridView.view.cellWidth

            Maui.ListBrowserDelegate
            {
                anchors.fill: parent
                anchors.margins: Maui.Style.space.small
                iconVisible: true

                label1.text: model.label
                iconSource: model.icon
                imageSource: model.thumbnail
                template.fillMode: Image.PreserveAspectFit
                checkable: selectionMode
                isCurrentItem : ListView.isCurrentItem

                onClicked:
                {
                    _favsGrid.currentIndex = index
                    openPreview(listModel, currentIndex)
                }
            }
        }
    }
}
