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

import "home"

ColumnLayout
{
    id: control

    spacing: Maui.Style.space.big

    Maui.SectionDropDown
    {
        id: _dropDown
        Layout.fillWidth: true
        label1.text: i18n("Downloads")
        label2.text: i18n("Your most recent downloaded files")
        checked: true
    }

    Maui.GridView
    {
        id: _recentGrid
        Layout.fillWidth: true
        enableLassoSelection: true
        visible: _dropDown.checked
        itemSize: Math.min(width * 0.3, 180)
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

    Button
    {
        text: i18n("More")
        icon.name: "list-add"
        onClicked: openTab(_recentGrid.model.list.url)
    }

    Maui.SectionDropDown
    {
        id: _dropDownAudio
        Layout.fillWidth: true
        label1.text: i18n("Audio")
        label2.text: i18n("Your most recent audio files")
        checked: true
    }

    Maui.GridView
    {
        id: _recentGridAudio
        Layout.fillWidth: true
        enableLassoSelection: true
        visible: _dropDown.checked
        itemSize: Math.min(width, 220)
        itemHeight: 80

        model: Maui.BaseModel
        {
            list: Index.RecentFiles
            {
                url: StandardPaths.writableLocation(StandardPaths.MusicLocation)
                filters: Maui.FM.nameFilters(Maui.FMList.AUDIO)
            }
        }

        delegate: Item
        {
            property bool isCurrentItem : GridView.isCurrentItem
            width: _recentGridAudio.cellWidth
            height: _recentGridAudio.itemHeight

            AudioCard
            {
                anchors.fill: parent
                anchors.margins: Maui.Style.space.medium
                iconSource: model.icon
                iconSizeHint: Maui.Style.iconSizes.big
                player.source: model.url
                checkable: selectionMode

                onClicked:
                {
                }
            }
        }
    }

    Button
    {
        text: i18n("More")
        icon.name: "list-add"
        onClicked: openTab(_recentGridAudio.model.list.url)
    }

    Maui.SectionDropDown
    {
        id: _dropDownPictures
        Layout.fillWidth: true
        label1.text: i18n("Pictures")
        label2.text: i18n("Your most recent image files")
        checked: true
    }

    Maui.ListBrowser
    {
        id: _recentGridPictures
        orientation: ListView.Horizontal
        Layout.fillWidth: true
        implicitHeight: 220
        enableLassoSelection: true
        visible: _dropDownPictures.checked

        model: Maui.BaseModel
        {
            list: Index.RecentFiles
            {
                url: StandardPaths.writableLocation(StandardPaths.PicturesLocation)
                filters: Maui.FM.nameFilters(Maui.FMList.IMAGE)
            }
        }

        delegate: Item
        {
            property bool isCurrentItem : ListView.isCurrentItem
            width: 180
            height: 180

            ImageCard
            {
                anchors.fill: parent
                anchors.margins: Maui.Style.space.medium
                imageSource: model.thumbnail
//                checkable: selectionMode

                onClicked:
                {
                }
            }
        }
    }

    Button
    {
        text: i18n("More")
        icon.name: "list-add"
        onClicked: openTab(_recentGridPictures.model.list.url)
    }
}

