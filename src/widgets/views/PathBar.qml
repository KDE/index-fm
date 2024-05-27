/*
 *   Copyright 2018 Camilo Higuita <milo.h@aol.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import org.mauikit.controls as Maui

import org.maui.index as Index

Item
{
    id: control

    property int preferredWidth: visible ? Math.max(500, item.implicitWidth): 0

    Behavior on preferredWidth
    {
        NumberAnimation
        {
            duration: Maui.Style.units.shortDuration
        }
    }

    implicitHeight: _loader.item.implicitHeight
    implicitWidth: preferredWidth
    /**
      * url : string
      */
    property url url

    /**
      * pathEntry : bool
      */
    property bool pathEntry: false

    /**
      * item : Item
      */
    readonly property alias item : _loader.item

    /**
      * pathChanged :
      */
    signal pathChanged(string path)

    /**
      * homeClicked :
      */
    signal homeClicked()

    /**
      * placeClicked :
      */
    signal placeClicked(string path)

    signal menuClicked()

    /**
      * placeRightClicked :
      */
    signal placeRightClicked(string path)

    PathBarDelegate
    {
        id: _dummyDelegate
        visible: false
        text: "test"
    }

    Loader
    {
        id: _loader
        anchors.fill: parent
        asynchronous: true
        sourceComponent: Item
        {
            implicitWidth: _layout.implicitWidth
            implicitHeight: _layout.implicitHeight           

            TextField
            {
                id: entry
                anchors.fill: parent
                visible: pathEntry
                enabled: visible
                text: control.url
                inputMethodHints: Qt.ImhUrlCharactersOnly | Qt.ImhNoAutoUppercase
                implicitWidth: 500
                horizontalAlignment: Qt.AlignLeft
                onAccepted:
                {
                    pathChanged(text)
                }

                onActiveFocusChanged:
                {
                    if(!activeFocus)
                    {
                        control.pathEntry = false
                    }
                }

                actions: Action
                {
                    icon.name: "go-next"
                    icon.color: control.Maui.Theme.textColor
                    onTriggered:
                    {
                        entry.accepted()
                    }
                }

                onVisibleChanged:
                {
                    if(visible)
                    {
                        entry.forceActiveFocus()
                        entry.selectAll()
                    }
                }

                Keys.enabled: true
                Keys.onEscapePressed: control.pathEntry = false
            }

            ScrollView
            {
                id: _layout
                visible: !pathEntry
                anchors.fill: parent

                orientation: Qt.Horizontal
                implicitWidth: contentWidth + leftPadding + rightPadding

                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                ScrollBar.vertical.policy: ScrollBar.AlwaysOff

                implicitHeight: _listView.currentItem ? _listView.currentItem.implicitHeight + topPadding + bottomPadding : _dummyDelegate.implicitHeight
                contentHeight: availableHeight
                leftPadding: 8

                background: Rectangle
                {
                    radius: Maui.Style.radiusV
                    color : _mouseArea.containsMouse ? Maui.Theme.backgroundColor : Maui.Theme.alternateBackgroundColor
                }

                ListView
                {
                    id: _listView

                    Maui.Theme.colorSet: control.Maui.Theme.colorSet
                    Maui.Theme.inherit: false

                    orientation: ListView.Horizontal
                    clip: true
                    spacing: -6
                    currentIndex: _pathList.count - 1

                    Component.onCompleted:
                    {
                        console.log("PATHBAR LIST READY",  _pathList.count)
                        _listView.currentIndex = Qt.binding( ()=>{return  _pathList.count - 1} )
                        _layout.implicitHeight = Qt.binding( ()=>{return _listView.itemAtIndex( _pathList.count - 1).implicitHeight} )
                    }

                    focus: true
                    interactive: Maui.Handy.isTouch
                    highlightFollowsCurrentItem: true
                    snapMode: ListView.NoSnap

                    boundsBehavior: Flickable.StopAtBounds
                    boundsMovement :Flickable.StopAtBounds

                    ListView.onAdd: _listView.positionViewAtEnd()
                    ListView.onRemove: _listView.positionViewAtEnd()

                    footerPositioning: ListView.OverlayFooter
                    footer: ToolButton
                    {
                        height: parent.height
                        flat: true
                        icon.name: "filename-space-amarok"
                        onClicked:  control.showEntryBar()
                    }

                    MouseArea
                    {
                        id: _mouseArea
                        z: -1
                        anchors.fill: parent
                        hoverEnabled: true
                        preventStealing: true
                        onClicked:
                        {
                            console.log("PATHBAR CLICKED")
                            control.showEntryBar()
                        }
                    }

                    model: Maui.BaseModel
                    {
                        id: _pathModel
                        list: Index.PathList
                        {
                            id: _pathList
                            path: control.url
                        }
                    }

                    delegate: PathBarDelegate
                    {
//                        height: ListView.view.height
                        width: Math.max(Maui.Style.iconSizes.medium * 2, implicitWidth)

                        onClicked:
                        {
                            control.placeClicked(model.path)
                        }

                        onRightClicked:
                        {
                            control.placeRightClicked(model.path)
                        }

                        onPressAndHold:
                        {
                            control.placeRightClicked(model.path)
                        }
                    }
                }
            }
        }
    }

    /**
      *
      */
    function showEntryBar()
    {
        control.pathEntry = !control.pathEntry
    }
}
