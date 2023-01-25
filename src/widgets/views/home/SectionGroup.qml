// Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2018-2020 Slike Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later


import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3

import org.mauikit.controls 1.3 as Maui

Maui.SettingsSection
{
    id: control
    Maui.Theme.colorSet: Maui.Theme.Window
    Maui.Theme.inherit: false

    property alias browser: _gridView
    property alias baseModel: _baseModel
    property alias currentIndex : _gridView.currentIndex

    padding: Maui.Style.space.medium

    background: Rectangle
    {
        color: Maui.Theme.backgroundColor
        radius: Maui.Style.radiusV
    }

    Maui.GridView
    {
        id: _gridView
        clip: true

        verticalScrollBarPolicy: ScrollBar.AlwaysOff
        horizontalScrollBarPolicy:  ScrollBar.AsNeeded
        currentIndex: -1
        Layout.fillWidth: true
        Layout.preferredHeight: visible ? implicitHeight : 0
        Layout.fillHeight: true
        flickable.flow: GridView.FlowTopToBottom
        scrollView.orientation: Qt.Horizontal

        itemSize: 220
        itemHeight: 70
        adaptContent: false

        holder.visible: count === 0
        holder.title: i18n("Nothing in here yet.")
        holder.body: i18n("Check back later.")

        model: Maui.BaseModel
        {
            id: _baseModel
        }

    }
}
