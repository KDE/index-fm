// Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2018-2020 Slike Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later


import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3
import org.mauikit.controls 1.3 as Maui
import org.mauikit.filebrowsing 1.3 as FB

ColumnLayout
{
    id: control

    Maui.SectionHeader
    {
        id: _dropDown
        Layout.fillWidth: true
        label1.text: i18n("Tags")
        label2.text: i18n("Tagged files for quick access")
        checked: true
        template.iconSource: "tag"
        template.iconSizeHint: Maui.Style.iconSizes.medium
    }

    Loader
    {
        Layout.fillWidth: true
        asynchronous: true

        sourceComponent: Maui.GridBrowser
        {
            id: _tagsGrid
            itemSize: 140
            itemHeight: Maui.Style.rowHeight * 2

            model: Maui.BaseModel
            {
                list:  FB.TagsListModel {urls: []; strict: false }
            }

            delegate: Item
            {
                width: GridView.view.cellWidth
                height: GridView.view.itemHeight

                Maui.ListBrowserDelegate
                {
                    anchors.fill: parent
                    anchors.margins: Maui.Style.space.medium

                    iconSizeHint: Maui.Style.iconSizes.small
                    label1.text: model.tag
                    iconSource: model.icon
                    iconVisible: true

                    onClicked:
                    {
                        _tagsGrid.currentIndex = index
                        openTab("tags:///"+model.tag)
                    }
                }
            }
        }
    }
}
