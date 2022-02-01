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
    property alias listModel : _model
    property alias currentIndex : _favsGrid.currentIndex

    signal itemClicked(url url)

    Maui.SectionDropDown
    {
        id: _dropDown
        Layout.fillWidth: true
        label1.text: i18n("Favorite files")

        label2.text: i18n("Your files marked as favorites")
        checked: _favsGrid.count > 0
        enabled: _favsGrid.count > 0
        template.iconSource: "love"
        template.iconSizeHint: Maui.Style.iconSizes.medium
    }

    ListView
    {
        id: _favsGrid
        Layout.fillWidth: true
        visible: _dropDown.checked
        boundsBehavior: ListView.StopAtBounds
        spacing: Maui.Style.space.medium
        implicitHeight: 180
        orientation: ListView.Horizontal

        model: Maui.BaseModel
        {
            id: _model
            list: FB.FMList
            {
                path: "tags:///fav"
            }
        }

        delegate: Maui.GridBrowserDelegate
        {
            width: height
            height: ListView.view.height
            label1.text: model.label
            iconSource: model.icon
            imageSource: model.thumbnail
            template.fillMode: Image.PreserveAspectFit
            template.labelSizeHint: 32
            iconSizeHint: height * 0.5
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
