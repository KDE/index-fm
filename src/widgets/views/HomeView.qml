// Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2018-2020 Slike Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later


import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3
import org.kde.mauikit 1.2 as Maui
import org.kde.kirigami 2.14 as Kirigami
import org.maui.index 1.0 as Index

import TagsList 1.0
import "home"

Maui.Page
{
    id: control

    headBar.visible: false

    Kirigami.ScrollablePage
    {
        anchors.fill: parent
        contentHeight: _layout.implicitHeight
        //    contentWidth: width
        background: null
        padding: isWide ? Maui.Style.space.big : Maui.Style.space.tiny
        leftPadding: padding
        rightPadding: padding

        property int itemWidth : Math.min(140, _layout.width * 0.3)


        ColumnLayout
        {
            id: _layout
            width: parent.width
            spacing: Maui.Style.space.huge

            FavoritesSection
            {
                Layout.fillWidth: true
            }

            PlacesSection
            {
                Layout.fillWidth: true
            }

            RecentSection
            {
                Layout.fillWidth: true
            }

            QuickCommonSection
            {
                Layout.fillWidth: true
            }

            TagsSection
            {
                Layout.fillWidth: true

            }

            DisksSection
            {
                Layout.fillWidth: true

            }
        }
    }
}
