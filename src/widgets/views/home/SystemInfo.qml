// Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2018-2020 Slike Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later


import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3

import Qt.labs.platform 1.1
import QtGraphicalEffects 1.0

import org.mauikit.controls 1.3 as Maui

import org.mauikit.filebrowsing 1.0 as FB

import org.maui.index 1.0 as Index

Maui.ListBrowser
{
    id: control

    signal itemClicked(url url)

    orientation: ListView.Horizontal
    implicitHeight: 220
//    verticalScrollBarPolicy: ScrollBar.AlwaysOff
//    horizontalScrollBarPolicy: ScrollBar.AlwaysOff

    model: [StandardPaths.writableLocation(StandardPaths.MusicLocation), StandardPaths.writableLocation(StandardPaths.DownloadLocation), StandardPaths.writableLocation(StandardPaths.MoviesLocation), StandardPaths.writableLocation(StandardPaths.DocumentsLocation)]

    delegate: Maui.ItemDelegate
    {
        id: _delegate
        property bool isCurrentItem : ListView.isCurrentItem
        anchors.verticalCenter: parent.verticalCenter
        width: 320
        height: 180
//        color: Maui.Theme.backgroundColor
//        radius: Maui.Style.radiusV

        property var info : FB.FM.getFileInfo(modelData)

        background: Item {}

        onClicked:
        {
            control.currentIndex = index
            control.itemClicked(modelData)
        }

//        Index.DirInfo
//        {
//            id: _dirInfo
//            url: modelData
//        }

        Rectangle
        {
            id: _iconRec
            opacity: 0.3
            anchors.fill: parent
            color: Maui.Theme.backgroundColor
            clip: true

            FastBlur
            {
                id: fastBlur
                height: parent.height * 2
                width: parent.width * 2
                anchors.centerIn: parent
                source: _icon
                radius: 64
                transparentBorder: true
                cached: true
            }

            Rectangle
            {
                anchors.fill: parent
                opacity: 0.5
                color: Qt.tint(control.Maui.Theme.textColor, Qt.rgba(control.Maui.Theme.backgroundColor.r, control.Maui.Theme.backgroundColor.g, control.Maui.Theme.backgroundColor.b, 0.9))
            }
        }

        OpacityMask
        {
            source: mask
            maskSource: _iconRec
        }

        LinearGradient
        {
            id: mask
            anchors.fill: parent
            gradient: Gradient {
                GradientStop { position: 0.2; color: "transparent"}
                GradientStop { position: 0.5; color: _iconRec.color}
            }

            start: Qt.point(0, 0)
            end: Qt.point(_iconRec.width, _iconRec.height)
        }

        ColumnLayout
        {
            anchors.fill: parent
            anchors.margins: Maui.Style.space.big
            id: _layout

            Maui.Icon
            {
                id: _icon
                Layout.leftMargin: Maui.Style.space.medium
                implicitHeight: Maui.Style.iconSizes.large
                implicitWidth: height
                source: info.icon
            }

            Maui.FlexListItem
            {
                Layout.fillWidth: true
                label1.font.pointSize: Maui.Style.fontSizes.huge
                label1.font.weight: Font.Bold
                label1.font.bold: true
                label1.text: info.label
//                label2.text: i18n("%1 Directories - %2 Files", _dirInfo.dirCount, _dirInfo.filesCount)

                onClicked:
                {
                    control.currentIndex = index
                    control.itemClicked(modelData)
                }

                Rectangle
                {
                    radius: Maui.Style.radiusV
                    color: "#333"
                    Layout.preferredWidth: _sizeLabel.implicitWidth + Maui.Style.space.big
                    implicitHeight: 36

                    Label
                    {
                        id: _sizeLabel
                        font.pointSize: Maui.Style.fontSizes.huge
                        font.bold: true
                        font.weight: Font.Bold
                        anchors.centerIn: parent
//                        text:  _dirInfo.sizeString
                        color: "#fafafa"
                    }
                }
            }

            ProgressBar
            {
                Layout.fillWidth: true
                Layout.margins: Maui.Style.space.medium
//                value:  Math.round((_dirInfo.size * 100) / _dirInfo.totalSpace)
                from: 0
                to : 100
            }
        }

        layer.enabled: true
        layer.effect: OpacityMask
        {
            maskSource: Item
            {
                width: _delegate.width
                height: _delegate.height

                Rectangle
                {
                    anchors.fill: parent
                    radius: Maui.Style.radiusV
                }
            }
        }
    }
}
