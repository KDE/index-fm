// Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2018-2020 Nitrux Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.13
import QtQuick.Controls 2.13

import org.mauikit.controls 1.3 as Maui
import org.mauikit.filebrowsing 1.0 as FB

Maui.Page
{
    id: control

    property alias selectionBar: _selectionBar
    property alias currentTabIndex : _browserList.currentIndex
    property alias currentTab : _browserList.currentItem
    property Browser currentSplit: currentTab.currentItem
    property alias browserList : _browserList

    floatingFooter: true
    headBar.visible: false

    footer: Maui.SelectionBar
    {
        id: _selectionBar
        anchors.horizontalCenter: parent.horizontalCenter
        width: Math.min(parent.width-(Maui.Style.space.medium*2), implicitWidth)

        maxListHeight: _browserList.height - (Maui.Style.contentMargins*2)

        display: ToolButton.IconOnly

        onVisibleChanged:
        {
            if(!visible)
            {
                root.selectionMode = false
            }
        }

        onUrisDropped: (uris) =>
                       {
                           for(var i in uris)
                           {
                               if(!FB.FM.fileExists(uris[i]))
                               continue;

                               const item = FB.FM.getFileInfo(uris[i])
                               _selectionBar.append(item.path, item)
                           }
                       }

        onExitClicked: clear()

        listDelegate: Maui.ListBrowserDelegate
        {
            isCurrentItem: false
            Maui.Theme.inherit: true
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
            onClicked: (mouse) =>
                       {
                           _selectionBar.selectionList.currentIndex = index
                       }

            onPressAndHold: (mouse) => removeAtIndex(index)
        }

        Action
        {
            text: i18n("Copy")
            icon.name: "edit-copy"
            onTriggered:
            {
                currentBrowser.copy(_selectionBar.uris)
            }
        }

        Action
        {
            text: i18n("Cut")
            icon.name: "edit-cut"
            onTriggered:
            {
                currentBrowser.cut(_selectionBar.uris)
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

        hiddenActions:[
            Action
            {
                text: i18n("Open")
                icon.name: "document-open"
                onTriggered:
                {
                    for(var i in selectionBar.uris)
                        currentBrowser.openFile(_selectionBar.uris[i])
                }
            },

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
            },

            Action
            {
                text: i18n("Tags")
                icon.name: "tag"
                onTriggered:
                {
                    tagFiles(_selectionBar.uris)
                }
            },

            Action
            {
                text: i18n("Remove")
                icon.name: "edit-delete"

                onTriggered:
                {
                    currentBrowser.remove(_selectionBar.uris)
                }
            }
        ]
    }

    Maui.TabView
    {
        id: _browserList
        anchors.fill: parent
        currentIndex : -1
        onNewTabClicked: openTab(currentBrowser.currentPath)
        onCloseTabClicked: (index) => closeTab(index)

        menuActions: Action
        {
            enabled: Maui.Handy.isLinux
            text: i18n("Detach Tab")
            onTriggered:
            {
                inx.openNewWindow(_browserList.contentModel.get(_browserList.menu.index).path)
                closeTab(_browserList.menu.index)
            }
        }
    }

    function isUrlOpen(url : string) : bool
    {
        for(var i = 0; i < browserList.count; i++)
        {
            console.log("It TABS", i)
            var tab = browserList.contentModel.get(i)
            for(var j = 0; j < tab.count; j++)
            {
                console.log("It SPlits", j)
                var view = tab.model.get(j)
                if(url === view.currentPath)
                {
                    return true;
                }
            }
        }

        return false;
    }
}

