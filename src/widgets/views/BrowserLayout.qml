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

    property alias orientation : _splitView.orientation
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
        orientation: width > 600 ? Qt.Horizontal :  Qt.Vertical

        clip: true
        focus: true

        handle: Item
        {
            implicitWidth: 20
            implicitHeight: 20

            Rectangle
            {
                width : _splitView.orientation == Qt.Horizontal ? 6 : 200
                height : _splitView.orientation == Qt.Horizontal ? 200 : 6
                anchors.centerIn: parent
                radius: Maui.Style.radiusV
                color: SplitHandle.pressed ? Kirigami.Theme.highlightColor : Qt.tint(control.Kirigami.Theme.textColor, Qt.rgba(control.Kirigami.Theme.backgroundColor.r, control.Kirigami.Theme.backgroundColor.g, control.Kirigami.Theme.backgroundColor.b, 0.9))

                Rectangle
                {
                    anchors.centerIn: parent
                    height: _splitView.orientation == Qt.Horizontal ? 48 : parent.height -2
                    width:  _splitView.orientation == Qt.Horizontal ? parent.width-2 : 48
                    color: SplitHandle.pressed || SplitHandle.hovered ? Kirigami.Theme.highlightColor : Kirigami.Theme.backgroundColor
                }
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

        if(_splitView.count === 1 && !settings.supportSplit)
        {
            return
        }

        if(_splitView.count === 2)
        {
            return
        }
        console.log("ERROR")

        const component = Qt.createComponent("qrc:/widgets/views/Browser.qml");
        console.log("ERROR", component.errorString())

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
            return //can not pop all the browsers, leave at least 1
        }
        const index = _splitView.currentIndex === 1 ? 0 : 1
        splitObjectModel.remove(index)
        var item = _splitView.takeItem(index)
        item.destroy()
        _splitView.currentIndex = 0
    }
}


