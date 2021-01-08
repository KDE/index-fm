// Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2018-2020 Slike Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later


import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3
import org.kde.mauikit 1.2 as Maui
import org.kde.kirigami 2.14 as Kirigami

Column
{
    Maui.ListItemTemplate
    {
        width: parent.width
        implicitHeight: Maui.Style.rowHeight * 2
        label1.text: i18n("Bookmarks")
        label1.font.pointSize: Maui.Style.fontSizes.huge
        label1.font.bold: true
        label1.font.weight: Font.Bold
        label2.text: i18n("Quick access to most common places and bookmarks")

        ToolButton
        {
            icon.name: checked ? "arrow-up" : "arrow-down"
            checked: !_placesGrid.visible
            onClicked: _placesGrid.visible = !_placesGrid.visible
        }
    }

    Maui.GridView
    {
        id: _placesGrid
        width: parent.width
        itemSize: Math.min(width, 180)
        itemHeight: Maui.Style.rowHeight * 2.5

        model: Maui.BaseModel
        {
            list:  Maui.PlacesList
            {
                id: placesList

                groups: [Maui.FMList.PLACES_PATH]
            }
        }

        delegate: Item
        {
            width: _placesGrid.cellWidth
            height: _placesGrid.itemHeight

            Maui.ListBrowserDelegate
            {
                anchors.fill: parent
                anchors.margins: Maui.Style.space.medium

                iconSizeHint: Maui.Style.iconSizes.big
                label1.text: model.label
                label2.text: Qt.formatDateTime(new Date(model.modified), "d MMM yyyy")
                iconSource: model.icon
                template.leftMargin: Maui.Style.space.small
                iconVisible: true
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

                //                    Kirigami.ImageColors
                //                    {
                //                        id: _colors
                //                        source: model.icon
                //                    }

                background: Rectangle
                {
                    color: Qt.tint(Kirigami.Theme.textColor, Qt.rgba(Kirigami.Theme.backgroundColor.r, Kirigami.Theme.backgroundColor.g, Kirigami.Theme.backgroundColor.b, 0.9))
                    opacity: 0.8
                    radius: Maui.Style.radiusV
                }
            }
        }
    }
}
