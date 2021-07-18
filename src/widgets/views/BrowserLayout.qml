// Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2018-2020 Nitrux Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later


import QtQuick 2.14
import QtQuick.Controls 2.13

import org.kde.kirigami 2.7 as Kirigami

import org.mauikit.controls 1.3 as Maui
import org.mauikit.filebrowsing 1.0 as FB

Item
{
    id: control
    height: ListView.view.height
    width:  ListView.view.width
    focus: true

    property url path

    property alias orientation : _splitView.orientation
    property alias currentIndex : _splitView.currentIndex
    property alias count : _splitView.count

    readonly property alias currentItem : _splitView.currentItem
    readonly property alias model : _splitView.contentModel
    readonly property string title : count === 2 ?  model.get(0).browser.title + "  -  " + model.get(1).browser.title : browser.title

    Maui.TabViewInfo.tabTitle: title
    Maui.TabViewInfo.tabToolTipText:  browser.currentPath

    readonly property FB.FileBrowser browser : currentItem.browser

    Maui.SplitView
    {
        id: _splitView
        anchors.fill: parent
        orientation: width > 600 ? Qt.Horizontal :  Qt.Vertical

        Component.onCompleted: split(control.path, Qt.Vertical)
    }

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
        if(_splitView.count === 2)
        {
            return
        }

        _splitView.addSplit(_browserComponent, {'browser.currentPath': path, 'browser.settings.viewType': settings.viewType})

    }

    function pop()
    {
        if(_splitView.count === 1)
        {
            return //can not pop all the browsers, leave at least 1
        }
        const index = _splitView.currentIndex === 1 ? 0 : 1
        _splitView.closeSplit(index)
    }
}


