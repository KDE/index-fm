// Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2018-2020 Slike Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later


import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3

import org.mauikit.controls 1.3 as Maui
import org.mauikit.filebrowsing 1.0 as FB
import Qt.labs.platform 1.1

import org.maui.index 1.0 as Index

import "home"

Maui.Page
{
    id: control

    Maui.Theme.colorSet: Maui.Theme.View
    Maui.Theme.inherit: false
    headBar.forceCenterMiddleContent: false
    altHeader: Maui.Handy.isMobile

    Maui.ContextualMenu
    {
        id: _fileItemMenu
        property url url

        MenuItem
        {
            text: i18n("Open")
            onTriggered: currentBrowser.openFile(_fileItemMenu.url)
        }

        MenuItem
        {
            text: i18n("Open with")
            onTriggered: openWith([_fileItemMenu.url])
        }

        MenuItem
        {
            text: i18n("Share")
            onTriggered: shareFiles([_fileItemMenu.url])
        }

        MenuItem
        {
            text: i18n("Open folder")
            onTriggered: openTab(FB.FM.fileDir(_fileItemMenu.url))
        }
    }

    headBar.middleContent: Maui.SearchField
    {
        id: _searchField
        Layout.fillWidth: true
        Layout.minimumWidth: 100
        Layout.maximumWidth: 500
        Layout.alignment: Qt.AlignCenter
        placeholderText: i18n("Search for files")
        onAccepted:
        {
            currentBrowser.search(text)
        }
    }

    headBar.farLeftContent: ToolButton
    {
        icon.name: "go-previous"
        text: i18n("Browser")
        display: isWide ? ToolButton.TextBesideIcon : ToolButton.IconOnly
        visible: _stackView.depth === 2
        onClicked: _stackView.pop()
    }

    ScrollView
    {
        anchors.fill: parent
        contentHeight: _layout.implicitHeight
        contentWidth: availableWidth

        background: null
        padding: Maui.Style.space.medium

        property int itemWidth : Math.min(140, _layout.width * 0.3)

        Flickable
        {
            boundsBehavior: Flickable.StopAtBounds
            boundsMovement: Flickable.StopAtBounds

            ColumnLayout
            {
                id: _layout
                width: parent.width
                spacing: Maui.Style.space.huge

                Loader
                {
                    Layout.fillWidth: true
                    asynchronous: true

                    sourceComponent: PlacesSection
                    {
                    }
                }


                Loader
                {
                    Layout.fillWidth: true
                    asynchronous: true

                    sourceComponent: FavoritesSection
                    {
                    }
                }

                Loader
                {
                    asynchronous: true

                    Layout.fillWidth: true

                    sourceComponent: RecentSection
                    {
                        id: _recentGrid
                        title: i18n("Downloads")
                        description: i18n("Your most recent downloaded files")

                        list.url: StandardPaths.writableLocation(StandardPaths.DownloadLocation)


                        browser.delegate:  Item
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
                                iconSizeHint: height * 0.5
                                checkable: selectionMode

                                onClicked:
                                {
                                    _recentGrid.currentIndex = index
                                    openPreview(_recentGrid.baseModel, index)
                                }
                            }
                        }
                    }
                }


                Loader
                {
                    Layout.fillWidth: true
                    asynchronous: true
                    sourceComponent: RecentSection
                    {
                        id: _recentMusic
                        title: i18n("Music")
                        description: i18n("Your most recent music files")

                        list.url: StandardPaths.writableLocation(StandardPaths.MusicLocation)
                        list.filters: FB.FM.nameFilters(FB.FMList.AUDIO)

                        browser.delegate: Item
                        {
                            height: GridView.view.cellHeight
                            width: GridView.view.cellWidth
                            AudioCard
                            {
                                anchors.fill: parent
                                anchors.margins: Maui.Style.space.small
                                iconSource: model.icon
                                iconSizeHint: Maui.Style.iconSizes.big
                                imageSource: model.thumbnail
                                player.source: model.url
                                isCurrentItem: parent.ListView.isCurrentItem


                                label1.text: player.metaData.title && player.metaData.title.length ? player.metaData.title :  model.name
                                label2.text: player.metaData.albumArtist || player.metaData.albumTitle
                                onClicked:
                                {
                                    _recentMusic.currentIndex = index
                                    openPreview(_recentMusic.baseModel, index)
                                }
                            }
                        }
                    }
                }

                Loader
                {
                    Layout.fillWidth: true
                    asynchronous: true
                    sourceComponent: RecentSection
                    {
                        id: _recentPics
                        title: i18n("Images")
                        description: i18n("Your most recent image files")

                        browser.itemSize: 180
                        browser.itemHeight: 180
                        browser.implicitHeight: 180

                        list.url: StandardPaths.writableLocation(StandardPaths.PicturesLocation)
                        list.filters: FB.FM.nameFilters(FB.FMList.IMAGE)

                        //                        url: inx.screenshotsPath()
                        //                        filters: FB.FM.nameFilters(FB.FMList.IMAGE)

                        browser.delegate: Item
                        {
                            height: GridView.view.cellHeight
                            width: GridView.view.cellWidth
                            ImageCard
                            {
                                anchors.fill: parent
                                anchors.margins: Maui.Style.space.small
                                imageSource: model.thumbnail
                                isCurrentItem: parent.ListView.isCurrentItem
                                onClicked:
                                {
                                    _recentPics.currentIndex = index
                                    openPreview(_recentPics.baseModel, index)
                                }
                            }
                        }
                    }
                }


                Loader
                {
                    Layout.fillWidth: true
                    asynchronous: true
                    sourceComponent:  DisksSection
                    {
                        id: _disksSection
                    }

                }
            }
        }
    }
}
