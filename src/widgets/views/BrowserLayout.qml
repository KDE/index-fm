// Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2018-2020 Nitrux Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later


import QtQuick 2.14
import QtQuick.Controls 2.13

import org.mauikit.controls 1.3 as Maui
import org.mauikit.filebrowsing 1.0 as FB

Maui.TabViewItem
{
    id: control

    property url path
    property url path2

    readonly property int orientation : splitView.orientation
    readonly property int currentIndex : splitView.currentIndex
    readonly property int count : splitView.count

    readonly property Browser currentItem : splitView.currentItem
    readonly property QtObject model : splitView.contentModel
    readonly property string title : item ? count === 2 ?  model.get(0).browser.title + "  -  " + model.get(1).browser.title : browser.title : FB.FM.getFileInfo(path).name

    readonly property FB.FileBrowser browser : currentItem.browser
    readonly property Maui.SplitView splitView : item ? item : null

    Maui.TabViewInfo.tabTitle: title
    Maui.TabViewInfo.tabToolTipText: browser.currentPath

    sourceComponent: Maui.SplitView
    {
        orientation: width > 600 ? Qt.Horizontal :  Qt.Vertical
    }

    onLoaded: split(control.path, Qt.Vertical)

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

        splitView.addSplit(_browserComponent, {'browser.currentPath': path, 'browser.settings.viewType': settings.viewType})

        if(path2.toString().length > 0 && splitView.count === 1)
        {
            splitView.addSplit(_browserComponent, {'browser.currentPath': path2, 'browser.settings.viewType': settings.viewType})
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


