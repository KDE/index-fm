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

    Menu
    {
        id: _fileItemMenu
        property url url

        MenuItem
        {
            text: i18n("Open")
        }

        MenuItem
        {
            text: i18n("Open with")
        }

        MenuItem
        {
            text: i18n("Share")
        }

        MenuItem
        {
            text: i18n("Open folder")
        }
    }

    Kirigami.ScrollablePage
    {
        anchors.fill: parent
        contentHeight: _layout.implicitHeight
        //    contentWidth: width
        background: null
        padding: 0
        leftPadding: padding
        rightPadding: padding
        topPadding: padding

        property int itemWidth : Math.min(140, _layout.width * 0.3)

        ColumnLayout
        {
            id: _layout
            width: parent.width
            spacing: 0


            Maui.AlternateListItem
            {
                Layout.fillWidth: true
                implicitHeight: _favSection.implicitHeight + Maui.Style.space.huge

                FavoritesSection
                {
                    id: _favSection
                    width: parent.width
                    anchors.centerIn: parent
                }
            }

            Maui.AlternateListItem
            {
                alt: true
                Layout.fillWidth: true
                implicitHeight: _recentSection.implicitHeight + Maui.Style.space.huge

                RecentSection
                {
                    id:_recentSection
                    width: parent.width
                    anchors.centerIn: parent

                    onItemClicked:
                    {
                        _fileItemMenu.url = url
                        _fileItemMenu.popup()
                    }
                }
            }

            Maui.AlternateListItem
            {
                Layout.fillWidth: true
                implicitHeight: _sysInfoSection.implicitHeight + Maui.Style.space.huge

                SystemInfo
                {
                    id: _sysInfoSection
                    width: parent.width
                    anchors.centerIn: parent
                }
            }

//            Maui.AlternateListItem
//            {
//                alt: true
//                Layout.fillWidth: true
//                implicitHeight: _bookmarksSection.implicitHeight + Maui.Style.space.huge

//                PlacesSection
//                {
//                    id: _bookmarksSection
//                    width: parent.width
//                    anchors.centerIn: parent
//                }
//            }

            Maui.AlternateListItem
            {
                Layout.fillWidth: true
                implicitHeight: _tagsSection.implicitHeight + Maui.Style.space.huge

                TagsSection
                {
                    id: _tagsSection
                    width: parent.width
                    anchors.centerIn: parent

                }
            }

            Maui.AlternateListItem
            {
                alt: true
                lastOne: true
                Layout.fillWidth: true
                implicitHeight: _disksSection.implicitHeight + Maui.Style.space.huge

                DisksSection
                {
                    id: _disksSection
                    width: parent.width
                    anchors.centerIn: parent

                }
            }
        }
    }
}
