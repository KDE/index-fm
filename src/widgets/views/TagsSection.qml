// Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2018-2020 Slike Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later


import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3
import org.kde.mauikit 1.2 as Maui
import org.kde.kirigami 2.14 as Kirigami

import TagsList 1.0

Column
{
    Maui.ListItemTemplate
    {
        width: parent.width
        implicitHeight: Maui.Style.rowHeight * 2
        label1.text: i18n("Tags")
        label1.font.pointSize: Maui.Style.fontSizes.huge
        label1.font.bold: true
        label1.font.weight: Font.Bold
        label2.text: i18n("Tagged files for quick access")

        ToolButton
        {
            icon.name: checked ? "arrow-up" : "arrow-down"
            checked: !_tagsGrid.visible
            onClicked: _tagsGrid.visible = !_tagsGrid.visible
        }
    }

    Maui.GridView
    {
        id: _tagsGrid
        width: parent.width
        itemSize: 140
        itemHeight: Maui.Style.rowHeight * 2

        model: Maui.BaseModel
        {
            list:  TagsList {urls: []; strict: false }
        }

        delegate: Item
        {
            width: _tagsGrid.cellWidth
            height: _tagsGrid.itemHeight

            Maui.ListBrowserDelegate
            {
                anchors.fill: parent
                anchors.margins: Maui.Style.space.medium

                iconSizeHint: Maui.Style.iconSizes.big
                label1.text: model.tag
                iconSource: model.icon
                iconVisible: true
                template.leftMargin: Maui.Style.space.small

                onClicked:
                {
                    _tagsGrid.currentIndex = index
                    open("tags:///"+model.tag)
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
