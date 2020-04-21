import QtQuick 2.9
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
        orientation: Qt.Horizontal
        clip: true
        focus: true

        handle: Rectangle
        {
            implicitWidth: 4
            implicitHeight: 4
            color: SplitHandle.pressed ? Kirigami.Theme.highlightColor
                                       : (SplitHandle.hovered ? Qt.lighter(Kirigami.Theme.backgroundColor, 1.1) : Kirigami.Theme.backgroundColor)

            Kirigami.Separator
            {
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left
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
        _splitView.orientation = orientation

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
        _splitView.takeItem(index)
        _splitView.currentIndex = 0
    }
}


