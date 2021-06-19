// Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2018-2020 Slike Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later


import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3
import org.mauikit.controls 1.3 as Maui
import org.kde.kirigami 2.14 as Kirigami
import org.mauikit.filebrowsing 1.0 as FB

ColumnLayout
{
    id: control

    Maui.SectionDropDown
    {
        id: _dropDown
        Layout.fillWidth: true
        label1.text: i18n("Devices and Remote")
        label2.text: i18n("Remote locations and devices like disks, phones and cameras")
        checked: _othersGrid.count > 0
        enabled: _othersGrid.count > 0
    }

    Maui.GridView
    {
        id: _othersGrid
        Layout.fillWidth: true
        visible: _dropDown.checked
        itemSize: Math.min(width * 0.3, 180)
        itemHeight: 180

        model: Maui.BaseModel
        {
            list:  FB.PlacesList
            {
                groups: [FB.FMList.DRIVES_PATH, FB.FMList.REMOTE_PATH]
            }
        }

        delegate: Item
        {
            width: GridView.view.cellWidth
            height: GridView.view.cellHeight

            Maui.GridBrowserDelegate
            {
                anchors.fill: parent
                anchors.margins: Maui.Style.space.medium

                iconSizeHint: Maui.Style.iconSizes.huge
                label1.text: model.label
                iconSource: model.icon
                iconVisible: true

                onClicked:
                {
                    _othersGrid.currentIndex = index
                    open(model.path)
                }
            }
        }
    }
}
