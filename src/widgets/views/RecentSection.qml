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

    Loader
    {
        Layout.fillWidth: true
        asynchronous: true

        sourceComponent: Maui.ListBrowser
        {
            id: _recentGrid
            implicitHeight: visible ? 180 : 0

            enableLassoSelection: true
            visible: _dropDown.checked && count > 0
            orientation: ListView.Horizontal
            verticalScrollBarPolicy: ScrollBar.AlwaysOff

//            flickable.footer: Item
//            {
//                height: 140
//                width: height

//                ToolButton
//                {
//                    anchors.centerIn: parent
//                    icon.name: "list-add"
//                    display: ToolButton.TextUnderIcon
//                    flat: true
//                    text: i18n("Downloads")
//                    onClicked: openTab(_recentGrid.model.list.url)
//                }
//            }

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
                width: height
                height: ListView.view.height

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
                    isCurrentItem: parent.ListView.isCurrentItem

                    onClicked:
                    {
                        _recentGrid.currentIndex = index
                        openPreview(_recentDownloadsModel, index)
                    }
                }
            }
        }
    }


    Loader
    {
        Layout.fillWidth: true
        asynchronous: true

        sourceComponent: Maui.ListBrowser
        {
            id: _recentGridAudio
            implicitHeight: visible ? 110 : 0
            enableLassoSelection: true
            visible: _dropDown.checked && count > 0
            orientation: ListView.Horizontal
            verticalScrollBarPolicy: ScrollBar.AlwaysOff

//            flickable.footer: Item
//            {
//                height: 80
//                width: height

//                ToolButton
//                {
//                    anchors.centerIn: parent
//                    icon.name: "list-add"
//                    display: ToolButton.TextUnderIcon
//                    flat: true
//                    text: i18n("Music")
//                    onClicked: openTab(_recentGridAudio.model.list.url)
//                }
//            }

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
                width: 300
                height: ListView.view.height

                AudioCard
                {
                    anchors.fill: parent
                    anchors.margins: Maui.Style.space.medium
                    iconSource: model.icon
                    iconSizeHint: Maui.Style.iconSizes.big
                    imageSource: model.thumbnail
                    player.source: model.url
                    isCurrentItem: parent.ListView.isCurrentItem
                    onClicked:
                    {
                        _recentGridAudio.currentIndex = index
                        openPreview(_recentMusicModel, index)
                    }
                }
            }
        }
    }


    Loader
    {
        Layout.fillWidth: true
        asynchronous: true

        sourceComponent: Maui.ListBrowser
        {
            id: _recentGridPictures
            orientation: ListView.Horizontal
            implicitHeight: visible ? 180 : 0

            enableLassoSelection: true
            visible: _dropDown.checked && count > 0
            verticalScrollBarPolicy: ScrollBar.AlwaysOff

//            flickable.footer: Item
//            {
//                height: 140
//                width: height

//                ToolButton
//                {
//                    anchors.centerIn: parent
//                    icon.name: "list-add"
//                    display: ToolButton.TextUnderIcon
//                    flat: true
//                    text: i18n("Pictures")
//                    onClicked: openTab(_recentGridPictures.model.list.url)
//                }
//            }


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
                width: height
                height: ListView.view.height

                ImageCard
                {
                    anchors.fill: parent
                    anchors.margins: Maui.Style.space.medium
                    imageSource: model.thumbnail
                    //                checkable: selectionMode
                    isCurrentItem: parent.ListView.isCurrentItem
                    onClicked:
                    {
                        _recentGridPictures.currentIndex = index
                        openPreview(_recentPicturesModel, index)
                    }
                }
            }
        }
    }

    Loader
    {
        Layout.fillWidth: true
        asynchronous: true

        sourceComponent: Maui.ListBrowser
        {
            id: _recentCamera
            orientation: ListView.Horizontal
            implicitHeight: visible ? 180 : 0
            enableLassoSelection: true
            visible: _dropDown.checked && count > 0
            verticalScrollBarPolicy: ScrollBar.AlwaysOff

//            flickable.footer: Item
//            {
//                height: 140
//                width: height

//                ToolButton
//                {
//                    anchors.centerIn: parent
//                    icon.name: "list-add"
//                    display: ToolButton.TextUnderIcon
//                    flat: true
//                    text: i18n("Camera")
//                    onClicked: openTab(_recentCamera.model.list.url)
//                }
//            }


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
    }

    Loader
    {
        Layout.fillWidth: true
        asynchronous: true

        sourceComponent: Maui.ListBrowser
        {
            id: _recentScreenshots
            orientation: ListView.Horizontal
            implicitHeight: visible ? 180 : 0

            enableLassoSelection: true
            visible: _dropDown.checked && count > 0
            //verticalScrollBarPolicy: ScrollBar.AlwaysOff

//            flickable.footer: Item
//            {
//                height: 140
//                width: height

//                ToolButton
//                {
//                    anchors.centerIn: parent
//                    icon.name: "list-add"
//                    display: ToolButton.TextUnderIcon
//                    flat: true
//                    text: i18n("Screenshots")
//                    onClicked: openTab(_recentScreenshots.model.list.url)
//                }
//            }

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
}

