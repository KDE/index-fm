// Copyright 2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2020 Slike Latinoamericana S.C.
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
        label1.text: i18n("Recent files")
        label1.font.pointSize: Maui.Style.fontSizes.huge
        label1.font.bold: true
        label1.font.weight: Font.Bold
        label2.text: i18n("Your most recent files")

        ToolButton
        {
            icon.name: checked ? "arrow-up" : "arrow-down"
            checked: !_recentGrid.visible
            onClicked: _recentGrid.visible = !_recentGrid.visible
        }
    }

    Maui.GridView
    {
        id: _recentGrid
        width: parent.width
        enableLassoSelection: true

        itemSize: 200
        itemHeight: 140

        model: Maui.BaseModel
        {
            list: Maui.FMList
            {
                path: "recentdocuments:///"
            }
        }

        delegate: Item
        {
            property bool isCurrentItem : GridView.isCurrentItem
            width: _recentGrid.cellWidth
            height: _recentGrid.itemHeight

            Maui.GridBrowserDelegate
            {
                anchors.fill: parent
                anchors.margins: Maui.Style.space.medium
                label1.text: model.label
                iconSource: model.icon
                imageSource: model.thumbnail
                template.fillMode: Image.PreserveAspectFit
                iconSizeHint: height * 0.6
                checkable: selectionMode

                onClicked:
                {
                    _previewer.show(_recentGrid.model, index)
                }

                template.content: Label
                {
                    visible: parent.height > 100
                    opacity: 0.5
                    color: Kirigami.Theme.textColor
                    font.pointSize: Maui.Style.fontSizes.tiny
                    horizontalAlignment: Qt.AlignHCenter
                    Layout.fillWidth: true
                    text: Qt.formatDateTime(new Date(model.modified), "d MMM yyyy")
                }
            }
        }
    }
}

