// Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2018-2020 Nitrux Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later


import QtQuick
import QtQuick.Controls
import QtQuick.Effects

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

    Loader
    {
        id: _actionsBarLoader
        active: settings.showActionsBar
        visible: status == Loader.Ready
        asynchronous: true

        sourceComponent: Pane
        {
            id: _pane
            Maui.Theme.colorSet: Maui.Theme.Complementary
            Maui.Theme.inherit: false

            x: control.width - width - Maui.Style.space.big
            y: control.height - height - currentItem.terminalPanelHeight - Maui.Style.space.big
            background: Rectangle
            {
                radius: Maui.Style.radiusV
                color: Maui.Theme.backgroundColor

                layer.enabled: GraphicsInfo.api !== GraphicsInfo.Software
                layer.effect: MultiEffect
                {
                    autoPaddingEnabled: true
                    shadowEnabled: true
                    shadowColor: "#000000"
                }
            }

            ScaleAnimator on scale
            {
                from: 0
                to: 1
                duration: Maui.Style.units.longDuration
                running: visible
                easing.type: Easing.OutInQuad
            }

            OpacityAnimator on opacity
            {
                from: 0
                to: 1
                duration: Maui.Style.units.longDuration
                running: visible
            }

            contentItem:  Maui.MenuItemActionRow
            {
                actions: [_newTabAction, _viewHiddenAction, _splitViewAction, _showTerminalAction]
                display: ToolButton.IconOnly
            }

            DragHandler
            {
                target: _pane
                // target: _actionsBarLoader
                // grabPermissions: PointerHandler.TakeOverForbidden | PointerHandler.CanTakeOverFromAnything
                xAxis.maximum: control.width - _pane.width
                xAxis.minimum: 0

                yAxis.enabled : false

                onActiveChanged:
                {
                    if(!active)
                    {
                        console.log(centroid.position, centroid.scenePosition, centroid.velocity.x)

                        let pos = centroid.velocity.x
                        _pane.x = Qt.binding(()=> { return pos < 0 ? Maui.Style.space.big : control.width - _pane.width - Maui.Style.space.big })
                        _pane.y = Qt.binding(()=> { return control.height - _pane.height - control.currentItem.terminalPanelHeight - Maui.Style.space.big })
                    }
                }
            }
        }
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


