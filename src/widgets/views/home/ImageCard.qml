import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.14 as Kirigami
import org.mauikit.controls 1.2 as Maui

Maui.ItemDelegate
{
    id: control

    property alias template : _template
    property alias imageSource: _template.imageSource

    Maui.GridItemTemplate
    {
        id: _template
        anchors.fill: parent
        labelsVisible: false
        fillMode: Image.PreserveAspectCrop
    }
}
