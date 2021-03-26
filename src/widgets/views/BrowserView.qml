// Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2018-2020 Nitrux Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.3

import Qt.labs.settings 1.0
import QtQml.Models 2.3

import org.kde.kirigami 2.14 as Kirigami
import org.kde.mauikit 1.3 as Maui

import org.maui.index 1.0 as Index


Maui.Page
{
    id: control
    //    spacing: 0

    property alias selectionBar: _selectionBar
    property alias currentTabIndex : _browserList.currentIndex
    property alias currentTab : _browserList.currentItem
    property alias viewTypeGroup: _viewTypeGroup
    property alias browserList : _browserList

    altHeader: Kirigami.Settings.isMobile
    flickable: root.flickable
    floatingFooter: true
    floatingHeader: false

    headBar.visible: !currentTab.currentItem.previewerVisible
    headBar.rightContent:[

        ToolButton
        {
            visible: currentTab && currentTab.currentItem ? currentTab.currentItem.supportsTerminal : false
            icon.name: "utilities-terminal"
            onClicked: currentTab.currentItem.toogleTerminal()
            checked : currentTab && currentBrowser ? currentTab.currentItem.terminalVisible : false
            checkable: true
        },

        Maui.ToolButtonMenu
        {
            visible: !sortSettings.globalSorting
            icon.name: "view-sort"

            MenuItem
            {
                text: i18n("Show Folders First")
                checked: currentBrowser.settings.foldersFirst
                checkable: true
                onTriggered: currentBrowser.settings.foldersFirst = !currentBrowser.settings.foldersFirst
            }

            MenuSeparator {}

            MenuItem
            {
                text: i18n("Type")
                checked: currentBrowser.settings.sortBy === Maui.FMList.MIME
                checkable: true
                onTriggered: currentBrowser.settings.sortBy = Maui.FMList.MIME
                autoExclusive: true
            }

            MenuItem
            {
                text: i18n("Date")
                checked:currentBrowser.settings.sortBy === Maui.FMList.DATE
                checkable: true
                onTriggered: currentBrowser.settings.sortBy = Maui.FMList.DATE
                autoExclusive: true
            }

            MenuItem
            {
                text: i18n("Modified")
                checkable: true
                checked: currentBrowser.settings.sortBy === Maui.FMList.MODIFIED
                onTriggered: currentBrowser.settings.sortBy = Maui.FMList.MODIFIED
                autoExclusive: true
            }

            MenuItem
            {
                text: i18n("Size")
                checkable: true
                checked: currentBrowser.settings.sortBy === Maui.FMList.SIZE
                onTriggered: currentBrowser.settings.sortBy = Maui.FMList.SIZE
                autoExclusive: true
            }

            MenuItem
            {
                text: i18n("Name")
                checkable: true
                checked: currentBrowser.settings.sortBy === Maui.FMList.LABEL
                onTriggered: currentBrowser.settings.sortBy = Maui.FMList.LABEL
                autoExclusive: true
            }

            MenuSeparator{}

            MenuItem
            {
                id: groupAction
                text: i18n("Group")
                checkable: true
                checked: currentBrowser.settings.group
                onTriggered:
                {
                    currentBrowser.settings.group = !currentBrowser.settings.group
                }
            }
        },

        ToolButton
        {
            visible: settings.supportSplit
            icon.name: currentTab.orientation === Qt.Horizontal ? "view-split-left-right" : "view-split-top-bottom"
            checked: currentTab.count == 2
            autoExclusive: true
            onClicked: toogleSplitView()
        },

        ToolButton
        {
            icon.name: "edit-find"
            checked: currentBrowser.headBar.visible
            onClicked:
            {
                currentBrowser.headBar.visible = !currentBrowser.headBar.visible
            }
        },

        ToolButton
        {
            id: _optionsButton
            icon.name: "overflow-menu"
            enabled: root.currentBrowser && root.currentBrowser.currentFMList.pathType !== Maui.FMList.TAGS_PATH && root.currentBrowser.currentFMList.pathType !== Maui.FMList.TRASH_PATH && root.currentBrowser.currentFMList.pathType !== Maui.FMList.APPS_PATH

            onClicked: currentBrowser.browserMenu.show(_optionsButton, 0, height + Maui.Style.space.medium)

            checked: currentBrowser.browserMenu.visible
            checkable: false
        }
    ]

    headBar.farLeftContent: ToolButton
    {
        visible: placesSidebar.collapsed
        icon.name: placesSidebar.visible ? "sidebar-collapse" : "sidebar-expand"
        onClicked: placesSidebar.toggle()

        ToolTip.delay: 1000
        ToolTip.timeout: 5000
        ToolTip.visible: hovered
        ToolTip.text: i18n("Toogle SideBar")
    }

    headBar.leftContent: [

        Maui.ToolActions
        {
            expanded: true
            autoExclusive: false
            checkable: false

            Action
            {
                text: i18n("Previous")
                icon.name: "go-previous"
                onTriggered : currentBrowser.goBack()
            }

            Action
            {
                text: i18n("Next")
                icon.name: "go-next"
                onTriggered: currentBrowser.goNext()
            }
        },

        Maui.ToolActions
        {
            id: _viewTypeGroup
            autoExclusive: true
            cyclic: true
            expanded: headBar.width > Kirigami.Units.gridUnit * 32

            Binding on currentIndex
            {
                value: currentBrowser ? currentBrowser.settings.viewType : -1
                //                    restoreMode: Binding.RestoreBinding
                delayed: true
            }

            //                    display: ToolButton.TextBesideIcon
            onCurrentIndexChanged:
            {
                if(currentBrowser)
                currentBrowser.settings.viewType = currentIndex
                settings.viewType = currentIndex
            }

            Action
            {
                icon.name: "view-list-icons"
                text: i18n("Grid")
                shortcut: "Ctrl+G"
            }

            Action
            {
                icon.name: "view-list-details"
                text: i18n("List")
                shortcut: "Ctrl+L"
            }
        }
    ]

    footer: Maui.SelectionBar
    {
        id: _selectionBar

        padding: Maui.Style.space.big
        anchors.horizontalCenter: parent.horizontalCenter
        width: Math.min(parent.width-(Maui.Style.space.medium*2), implicitWidth)
        maxListHeight: _browserList.height - (Maui.Style.contentMargins*2)

        onCountChanged:
        {
            if(_selectionBar.count < 1)
            {
                root.selectionMode = false
            }
        }

        onUrisDropped:
        {
            for(var i in uris)
            {
                if(!Maui.FM.fileExists(uris[i]))
                    continue;

                const item = Maui.FM.getFileInfo(uris[i])
                _selectionBar.append(item.path, item)
            }
        }

        onExitClicked: clear()

        listDelegate: Maui.ListBrowserDelegate
        {
            isCurrentItem: false
            Kirigami.Theme.inherit: true
            width: ListView.view.width
            height: Maui.Style.iconSizes.big + Maui.Style.space.big
            imageSource: root.showThumbnails ? model.thumbnail : ""
            iconSource: model.icon
            label1.text: model.label
            label2.text: model.path
            label3.text: ""
            label4.text: ""
            checkable: true
            checked: true
            iconSizeHint: Maui.Style.iconSizes.big
            onToggled: _selectionBar.removeAtIndex(index)
            background: Item {}
            onClicked:
            {
                _selectionBar.selectionList.currentIndex = index
            }

            onPressAndHold: removeAtIndex(index)
        }

        Action
        {
            text: i18n("Open")
            icon.name: "document-open"
            onTriggered:
            {
                for(var i in selectionBar.uris)
                    currentBrowser.openFile(_selectionBar.uris[i])
            }
        }

        Action
        {
            text: i18n("Compress")
            icon.name: "archive-insert"
            onTriggered:
            {
                dialogLoader.sourceComponent= _compressDialogComponent
                dialog.urls = selectionBar.uris
                dialog.open()
            }
        }

        Action
        {
            text: i18n("Tags")
            icon.name: "tag"
            onTriggered:
            {
                tagFiles(_selectionBar.uris)
            }
        }

        Action
        {
            text: i18n("Share")
            icon.name: "document-share"
            onTriggered:
            {
                shareFiles(_selectionBar.uris)
            }
        }

        Action
        {
            text: i18n("Copy")
            icon.name: "edit-copy"
            onTriggered:
            {
                _selectionBar.animate()
                currentBrowser.copy(_selectionBar.uris)
            }
        }

        Action
        {
            text: i18n("Cut")
            icon.name: "edit-cut"
            onTriggered:
            {
                _selectionBar.animate()
                currentBrowser.cut(_selectionBar.uris)
            }
        }

        Action
        {
            text: i18n("Remove")
            icon.name: "edit-delete"

            onTriggered:
            {
                currentBrowser.remove(_selectionBar.uris)
            }
        }
    }

    Maui.TabView
    {
        id: _browserList
        anchors.fill: parent       
        confirmClose: true
        onNewTabClicked: openTab(currentPath)

        onCurrentItemChanged:
        {
            if(currentBrowser)
            {
                currentBrowser.currentView.forceActiveFocus()
            }
        }
    }

    DropArea
    {
        id: _dropArea
        anchors.fill: parent
        z: parent.z -2
        onDropped:
        {
            const urls = drop.urls
            for(var i in urls)
            {
                const item = Maui.FM.getFileInfo(urls[i])
                if(item.isdir == "true")
                {
                    control.openTab(urls[i])
                }
            }
        }
    }
}

