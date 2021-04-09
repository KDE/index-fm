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
import org.mauikit.filebrowsing 1.0 as FB

import Qt.labs.platform 1.1

ColumnLayout
{
    id: control

    Maui.SectionDropDown
    {
        id: _dropDown
        Layout.fillWidth: true
        label1.text: i18n("Collections")
        label1.font.pointSize: Maui.Style.fontSizes.huge
        label2.text: i18n("Quick access to common collections")
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

        model: ["camera", "screenshots", "videos", "fonts", "applications"]

        delegate: Item
        {
            property bool isCurrentItem : GridView.isCurrentItem
            width: _recentGrid.cellWidth
            height: _recentGrid.itemHeight

            Index.RecentFiles
            {
                id: _collectionFiles
                url: StandardPaths.writableLocation(StandardPaths.PicturesLocation)
                filters: FB.FM.nameFilters(FB.FMList.IMAGE)
//                onUrlsChanged: _collage.urls = urls
            }
            Maui.GalleryRollItem
            {
                id:_collage
                anchors.fill: parent
                anchors.margins: Maui.Style.space.medium

                template.label1.text: modelData
//                iconSource: model.icon
//                imageSource: model.thumbnail
//                template.fillMode: Image.PreserveAspectFit
//                iconSizeHint: height * 0.4
//                checkable: selectionMode

                onClicked: console.log(images)

               images: _collectionFiles.urls
            }
        }
    }
}
