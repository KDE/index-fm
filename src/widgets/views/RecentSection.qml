// Copyright 2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2020 Slike Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3
import org.kde.mauikit 1.3 as Maui
import org.kde.kirigami 2.14 as Kirigami
import org.maui.index 1.0 as Index
 import Qt.labs.platform 1.1

ColumnLayout
{
    id: control

    Maui.SectionDropDown
    {
        id: _dropDown
        Layout.fillWidth: true
        label1.text: i18n("Downloads")
        label1.font.pointSize: Maui.Style.fontSizes.huge
        label2.text: i18n("Your most recent downloaded files")
        checked: true
    }

    Maui.GridView
    {
        id: _recentGrid
        Layout.fillWidth: true
        enableLassoSelection: true
visible: _dropDown.checked
        itemSize: 180
        itemHeight: 180

        model: Maui.BaseModel
        {
            list: Index.RecentFiles
            {
                url: StandardPaths.writableLocation(StandardPaths.DownloadLocation)
//                filters: Maui.FM.nameFilters(Maui.FMList.AUDIO_TYPE)
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
                iconSizeHint: height * 0.4
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

