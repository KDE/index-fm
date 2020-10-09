// Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2018-2020 Nitrux Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later


import QtQuick 2.14
import QtQml 2.12
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.7 as Kirigami
import org.kde.mauikit 1.0 as Maui
import QtQml.Models 2.3

Item
{
    id: control
    height: _browserList.height
    width: _browserList.width

    property url path

    property alias currentIndex : _splitView.currentIndex
    property alias count : _splitView.count
    readonly property alias currentItem : _splitView.currentItem
    readonly property alias model : splitObjectModel
    readonly property string title : count === 2 ?  model.get(0).browser.title + "  -  " + model.get(1).browser.title : browser.title

    readonly property Maui.FileBrowser browser : currentItem.browser

    ObjectModel { id: splitObjectModel }

    SplitView
    {
        id: _splitView

        anchors.fill: parent
        orientation: isWide ? Qt.Horizontal :  Qt.Vertical

        clip: true
        focus: true

        handle: Rectangle
        {
            implicitWidth: Maui.Handy.isTouch ? 10 : 6
            implicitHeight: Maui.Handy.isTouch ? 10 : 6

            color: SplitHandle.pressed ? Kirigami.Theme.highlightColor
                                       : (SplitHandle.hovered ? Qt.lighter(Kirigami.Theme.backgroundColor, 1.1) : Kirigami.Theme.backgroundColor)

            Rectangle
            {
                anchors.centerIn: parent
                height: _splitView.orientation == Qt.Horizontal ? 48 : parent.height
                width:  _splitView.orientation == Qt.Horizontal ? parent.width : 48
                color: _splitSeparator1.color
            }


            states: [  State
                {
                    when: _splitView.orientation === Qt.Horizontal

                    AnchorChanges
                    {
                        target: _splitSeparator1
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.right: undefined
                    }

                    AnchorChanges
                    {
                        target: _splitSeparator2
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.right: parent.right
                        anchors.left: undefined
                    }
                },

                State
                {
                    when: _splitView.orientation === Qt.Vertical

                    AnchorChanges
                    {
                        target: _splitSeparator1
                        anchors.top: parent.top
                        anchors.bottom: undefined
                        anchors.left: parent.left
                        anchors.right: parent.right
                    }

                    AnchorChanges
                    {
                        target: _splitSeparator2
                        anchors.top: undefined
                        anchors.bottom: parent.bottom
                        anchors.right: parent.right
                        anchors.left: parent.left
                    }
                }

            ]


            Kirigami.Separator
            {
                id: _splitSeparator1
            }

            Kirigami.Separator
            {
                id: _splitSeparator2
            }
        }

        onCurrentItemChanged:
        {
            currentItem.forceActiveFocus()
        }

        Component.onCompleted: split(control.path, Qt.Vertical)
    }

    function split(path, orientation)
    {
//        _splitView.orientaion = orientation

        if(_splitView.count === 1 && !root.supportSplit)
        {
            return
        }

        if(_splitView.count === 2)
        {
            return
        }

        const component = Qt.createComponent("qrc:/widgets/views/Browser.qml");

        if (component.status === Component.Ready)
        {
            const object = component.createObject(splitObjectModel, {'browser.currentPath': path, 'browser.settings.viewType': _viewTypeGroup.currentIndex});
            splitObjectModel.append(object)
            _splitView.insertItem(splitObjectModel.count, object) // duplicating object insertion due to bug on android not picking the repeater
            _splitView.currentIndex = splitObjectModel.count - 1
        }
    }

    function pop()
    {
        if(_splitView.count === 1)
        {
            return //can not pop all the browsers, leave at leats 1
        }
        const index = _splitView.currentIndex === 1 ? 0 : 1
        splitObjectModel.remove(index)
        var item = _splitView.takeItem(index)
        item.destroy()
        _splitView.currentIndex = 0
    }
}


