// Copyright 2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2020 Slike Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3

import org.mauikit.controls 1.3 as Maui
import org.mauikit.filebrowsing 1.0 as FB

import org.kde.kirigami 2.14 as Kirigami

import org.maui.index 1.0 as Index

import Qt.labs.platform 1.1

import "home"

ColumnLayout
{
    id: control

    spacing: Maui.Style.space.medium

    signal itemClicked(url url)

    Maui.SectionDropDown
    {
        id: _dropDown
        Layout.fillWidth: true
        label1.text: i18n("Downloads, Audio & Pictures")
        label2.text: i18n("Your most recent downloaded files, audio and images")
        checked: true
        template.iconSource: "view-media-recent"
        template.iconSizeHint: Maui.Style.iconSizes.medium
    }

    Maui.ListBrowser
    {
        id: _recentGrid
        Layout.fillWidth: true
        enableLassoSelection: true
        visible: _dropDown.checked && count > 0
        implicitHeight: 180
        orientation: ListView.Horizontal
        verticalScrollBarPolicy: ScrollBar.AlwaysOff

        flickable.footer: Item
        {
            height: 140
            width: height

            ToolButton
            {
                anchors.centerIn: parent
                icon.name: "list-add"
                display: ToolButton.TextUnderIcon
                flat: true
                text: i18n("Downloads")
                onClicked: openTab(_recentGrid.model.list.url)
            }
        }

        model: Maui.BaseModel
        {
            id: _recentDownloadsModel
            list: Index.RecentFiles
            {
                url: StandardPaths.writableLocation(StandardPaths.DownloadLocation)
                //                filters: FB.FM.nameFilters(FB.FMList.AUDIO_TYPE)
            }
        }

        delegate: Item
        {
            property bool isCurrentItem : ListView.isCurrentItem

            width: 140
            height: width
            anchors.verticalCenter: parent.verticalCenter

            Maui.GridBrowserDelegate
            {
                anchors.fill: parent
                anchors.margins: Maui.Style.space.medium
                label1.text: model.label
                iconSource: model.icon
                imageSource: model.thumbnail
                template.fillMode: Image.PreserveAspectFit
                iconSizeHint: height * 0.5
                checkable: selectionMode

                onClicked:
                {
                    _recentGrid.currentIndex = index
                    openPreview(_recentDownloadsModel, index)
                }

//                template.content: Label
//                {
//                    visible: parent.height > 100
//                    opacity: 0.5
//                    color: Kirigami.Theme.textColor
//                    font.pointSize: Maui.Style.fontSizes.tiny
//                    horizontalAlignment: Qt.AlignHCenter
//                    Layout.fillWidth: true
//                    text: Qt.formatDateTime(new Date(model.modified), "d MMM yyyy")
//                }
            }
        }
    }

    Maui.ListBrowser
    {
        id: _recentGridAudio
        Layout.fillWidth: true
        enableLassoSelection: true
        visible: _dropDown.checked && count > 0
        implicitHeight: 120
        orientation: ListView.Horizontal
        verticalScrollBarPolicy: ScrollBar.AlwaysOff

        flickable.footer: Item
        {
            height: 80
            width: height

            ToolButton
            {
                anchors.centerIn: parent
                icon.name: "list-add"
                display: ToolButton.TextUnderIcon
                flat: true
                text: i18n("Music")
                onClicked: openTab(_recentGridAudio.model.list.url)
            }
        }

        model: Maui.BaseModel
        {
            id: _recentMusicModel
            list: Index.RecentFiles
            {
                url: StandardPaths.writableLocation(StandardPaths.MusicLocation)
                filters: FB.FM.nameFilters(FB.FMList.AUDIO)
            }
        }

        delegate: Item
        {
            property bool isCurrentItem : ListView.isCurrentItem
            width: 220
            height: 80
            anchors.verticalCenter: parent.verticalCenter

            AudioCard
            {
                anchors.fill: parent
                anchors.margins: Maui.Style.space.medium
                iconSource: model.icon
                iconSizeHint: Maui.Style.iconSizes.big
                player.source: model.url

                onClicked:
                {
                    _recentGridAudio.currentIndex = index
                    openPreview(_recentMusicModel, index)
                }
            }
        }
    }

    Maui.ListBrowser
    {
        id: _recentGridPictures
        orientation: ListView.Horizontal
        Layout.fillWidth: true
        implicitHeight: 180
        enableLassoSelection: true
        visible: _dropDown.checked && count > 0
        verticalScrollBarPolicy: ScrollBar.AlwaysOff

        flickable.footer: Item
        {
            height: 140
            width: height

            ToolButton
            {
                anchors.centerIn: parent
                icon.name: "list-add"
                display: ToolButton.TextUnderIcon
                flat: true
                text: i18n("Pictures")
                onClicked: openTab(_recentGridPictures.model.list.url)
            }
        }


        model: Maui.BaseModel
        {
            id: _recentPicturesModel
            list: Index.RecentFiles
            {
                url: StandardPaths.writableLocation(StandardPaths.PicturesLocation)
                filters: FB.FM.nameFilters(FB.FMList.IMAGE)
            }
        }

        delegate: Item
        {
            property bool isCurrentItem : ListView.isCurrentItem
            width: 140
            height: width
            anchors.verticalCenter: parent.verticalCenter

            ImageCard
            {
                anchors.fill: parent
                anchors.margins: Maui.Style.space.medium
                imageSource: model.thumbnail
                //                checkable: selectionMode
                onClicked:
                {
                    _recentGridPictures.currentIndex = index
                    openPreview(_recentPicturesModel, index)
                }
            }
        }
    }

    Maui.ListBrowser
    {
        id: _recentCamera
        orientation: ListView.Horizontal
        Layout.fillWidth: true
        implicitHeight: 180
        enableLassoSelection: true
        visible: _dropDown.checked && count > 0
        verticalScrollBarPolicy: ScrollBar.AlwaysOff

        flickable.footer: Item
        {
            height: 140
            width: height

            ToolButton
            {
                anchors.centerIn: parent
                icon.name: "list-add"
                display: ToolButton.TextUnderIcon
                flat: true
                text: i18n("Camera")
                onClicked: openTab(_recentCamera.model.list.url)
            }
        }


        model: Maui.BaseModel
        {
            id: _recentCameraModel
            list: Index.RecentFiles
            {
                url: inx.cameraPath()
                filters: FB.FM.nameFilters(FB.FMList.IMAGE)
            }
        }

        delegate: Item
        {
            property bool isCurrentItem : ListView.isCurrentItem
            width: 140
            height: width
            anchors.verticalCenter: parent.verticalCenter

            ImageCard
            {
                anchors.fill: parent
                anchors.margins: Maui.Style.space.medium
                imageSource: model.thumbnail
                onClicked:
                {
                    _recentCamera.currentIndex = index
                    openPreview(_recentCameraModel, index)
                }
            }
        }
    }

    Maui.ListBrowser
    {
        id: _recentScreenshots
        orientation: ListView.Horizontal
        Layout.fillWidth: true
        implicitHeight: 180
        enableLassoSelection: true
        visible: _dropDown.checked && count > 0
        verticalScrollBarPolicy: ScrollBar.AlwaysOff

        flickable.footer: Item
        {
            height: 140
            width: height

            ToolButton
            {
                anchors.centerIn: parent
                icon.name: "list-add"
                display: ToolButton.TextUnderIcon
                flat: true
                text: i18n("Screenshots")
                onClicked: openTab(_recentScreenshots.model.list.url)
            }
        }


        model: Maui.BaseModel
        {
            id: _recentScreenshotsModel
            list: Index.RecentFiles
            {
                url: inx.screenshotsPath()
                filters: FB.FM.nameFilters(FB.FMList.IMAGE)
            }
        }

        delegate: Item
        {
            property bool isCurrentItem : ListView.isCurrentItem
            width: 140
            height: width
            anchors.verticalCenter: parent.verticalCenter

            ImageCard
            {
                anchors.fill: parent
                anchors.margins: Maui.Style.space.medium
                imageSource: model.thumbnail
                onClicked:
                {
                    _recentScreenshots.currentIndex = index
                    openPreview(_recentScreenshotsModel, index)
                }
            }
        }
    }
}

