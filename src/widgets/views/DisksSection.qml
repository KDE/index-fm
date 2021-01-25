// Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2018-2020 Slike Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later


import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3
import org.kde.mauikit 1.3 as Maui
import org.kde.kirigami 2.14 as Kirigami

import TagsList 1.0

ColumnLayout
{

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

//        model: Maui.BaseModel
//        {
//            list:  Maui.PlacesList
//            {
//                groups: [Maui.FMList.DRIVES_PATH, Maui.FMList.REMOTE_PATH]
//            }
//        }

        delegate: Item
        {
            width: _othersGrid.cellWidth
            height: _othersGrid.itemHeight

            Maui.GridBrowserDelegate
            {
                anchors.fill: parent
                anchors.margins: Maui.Style.space.medium

                iconSizeHint: height * 0.7
                label1.text: model.label
                iconSource: model.icon
                iconVisible: true

                onClicked:
                {
                    _othersGrid.currentIndex = index
                    open(model.path)
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
