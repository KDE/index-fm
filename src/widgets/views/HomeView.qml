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

import org.maui.index 1.0 as Index

import "home"

Maui.Page
{
    id: control

    Kirigami.Theme.colorSet: Kirigami.Theme.View
    Kirigami.Theme.inherit: false

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

   headBar.middleContent: Maui.TextField
    {
        id: _searchField
        Layout.fillWidth: true
        Layout.minimumWidth: 100
        Layout.maximumWidth: 500
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

    Kirigami.ScrollablePage
    {
        anchors.fill: parent
        contentHeight: _layout.implicitHeight
        background: null
        padding: 0
        leftPadding: padding
        rightPadding: padding
        topPadding: padding

        Kirigami.Theme.colorSet: Kirigami.Theme.View
        Kirigami.Theme.inherit: false

        property int itemWidth : Math.min(140, _layout.width * 0.3)

        ColumnLayout
        {
            id: _layout
            width: parent.width
            spacing: 0

            Loader
            {
                Layout.fillWidth: true
                asynchronous: true

                sourceComponent: Maui.AlternateListItem
                {
                    implicitHeight: _favSection.implicitHeight + Maui.Style.space.huge

                    FavoritesSection
                    {
                        id: _favSection
                        width: parent.width
                        anchors.centerIn: parent
                    }
                }
            }

            Loader
            {
                Layout.fillWidth: true
                asynchronous: true
                sourceComponent:  Maui.AlternateListItem
                {
                    implicitHeight: _recentSection.implicitHeight + Maui.Style.space.huge

                    RecentSection
                    {
                        id:_recentSection
                        width: parent.width
                        anchors.centerIn: parent
                    }
                }
            }

            Loader
            {
                Layout.fillWidth: true
                asynchronous: true
                sourceComponent:  Maui.AlternateListItem
                {
                    implicitHeight: _sysInfoSection.implicitHeight + Maui.Style.space.huge

                    SystemInfo
                    {
                        id: _sysInfoSection
                        width: parent.width
                        anchors.centerIn: parent

                        onItemClicked:
                        {
                            openTab(url)
                        }
                    }
                }
            }

//            Loader
//            {
//                Layout.fillWidth: true
//                asynchronous: true
//                sourceComponent:  Maui.AlternateListItem
//                {
//                    implicitHeight: _tagsSection.implicitHeight + Maui.Style.space.huge

//                    TagsSection
//                    {
//                        id: _tagsSection
//                        width: parent.width
//                        anchors.centerIn: parent
//                    }
//                }
//            }

            Loader
            {
                Layout.fillWidth: true
                asynchronous: true
                sourceComponent:  Maui.AlternateListItem
                {
                    lastOne: true
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
}
