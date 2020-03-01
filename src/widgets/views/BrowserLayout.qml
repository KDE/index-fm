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

        focus: true

        Repeater
        {
            property int _index : index
            model: splitObjectModel
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
            const object = component.createObject(splitObjectModel, {'currentPath': control.path});
            splitObjectModel.append(object)
            _splitView.currentIndex = splitObjectModel.count - 1
        }
    }

    function pop()
    {
        if(_splitView.count === 1)
        {
            return //can not pop all the browsers, leave at leats 1
        }

        splitObjectModel.remove(_splitView.currentIndex === 1 ? 0 : 1)
        _splitView.currentIndex = 0
    }
}


