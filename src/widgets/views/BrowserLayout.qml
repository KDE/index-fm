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

    property alias count : _splitView.count
    property alias browser : _splitView.currentItem
    property url path

    ObjectModel { id: splitObjectModel }

    SplitView
    {
        id: _splitView

        anchors.fill: parent

        orientation: Qt.Horizontal


    //    property alias path : currentItem.currentPath

        focus: true

        Repeater
        {
            model: splitObjectModel
        }

        onOrientationChanged:
        {
            _splitView.width = _splitView.width +1
            _splitView.width = _splitView.width -1
    //        _splitView.height = _splitView.height +1
    //        _splitView.height = _splitView.height
        }

        onCurrentItemChanged:
        {
            currentItem.forceActiveFocus()
        }

        Component.onCompleted: split(Qt.Vertical)
    }

    function split(orientation)
    {
        _splitView.orientation = orientation

        if(_splitView.count === 2)
            return;

        const component = Qt.createComponent("Browser.qml");

        if (component.status === Component.Ready)
        {
            const object = component.createObject(splitObjectModel, {'index': _splitView.count, 'currentPath': control.path});
            splitObjectModel.append(object)
            _splitView.currentIndex = splitObjectModel.count - 1
        }
    }

    function pop()
    {
        splitObjectModel.remove(_splitView.currentIndex === 1 ? 0 : 1)
    }
}


