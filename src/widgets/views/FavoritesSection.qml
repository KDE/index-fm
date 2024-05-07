// Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2018-2020 Slike Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later


import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.mauikit.controls as Maui

import org.mauikit.filebrowsing as FB

import "home"

SectionGroup
{
    id: control

    title: i18n("Favorite files")
    description: i18n("Your files marked as favorites")

    browser.implicitHeight: 220
    browser.itemSize: 220
    browser.itemHeight: 70

    baseModel.list: FB.FMList
    {
        path: "tags:///fav"
    }

    browser.delegate: Item
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
                control.currentIndex = index
                openPreview(control.baseModel, currentIndex)
            }
        }
    }
}
