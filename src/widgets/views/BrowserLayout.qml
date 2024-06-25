// Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2018-2020 Nitrux Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later


import QtQuick
import QtQuick.Controls

import org.mauikit.controls as Maui
import org.mauikit.filebrowsing as FB

Item
{
    id: control

    focus: true

    property url path
    property url path2

    readonly property alias orientation : _splitView.orientation
    readonly property alias currentIndex : _splitView.currentIndex
    readonly property alias count : _splitView.count

    readonly property alias currentItem : _splitView.currentItem
    readonly property alias model : _splitView.contentModel
    readonly property string title : count === 2 ?  model.get(0).browser.title + "  -  " + model.get(1).browser.title : browser.title

    readonly property FB.FileBrowser browser : currentItem.browser
    readonly property Maui.SplitView splitView : _splitView

    Maui.Controls.title: title
    Maui.Controls.toolTipText: browser.currentPath
    Maui.Controls.iconName: "folder"

    Maui.SplitView
    {
        id: _splitView
        anchors.fill: parent
        orientation: width > 600 ? Qt.Horizontal :  Qt.Vertical
    }

    Component.onCompleted: split(control.path, Qt.Vertical)

    Component
    {
        id: _browserComponent
        Browser {}
    }

    function forceActiveFocus()
    {
        control.currentItem.forceActiveFocus()
    }

    function split(path, orientation)
    {
        if(splitView.count === 2)
        {
            return
        }

        splitView.addSplit(_browserComponent, {'browser.currentPath': path})

        if(path2.toString().length > 0 && splitView.count === 1)
        {
            splitView.addSplit(_browserComponent, {'browser.currentPath': path2})
        }
    }

    function pop()
    {
        if(splitView.count === 1)
        {
            return //can not pop all the browsers, leave at least 1
        }
        const index = splitView.currentIndex === 1 ? 0 : 1
        splitView.closeSplit(index)
    }
}


