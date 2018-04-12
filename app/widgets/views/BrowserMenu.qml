import QtQuick 2.9
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3

Menu
{
    x: parent.width / 2 - width / 2
    y: parent.height / 2 - height / 2
    modal: true
    focus: true
    parent: ApplicationWindow.overlay
    margins: 1
    padding: 2

    Column
    {
        MenuItem
        {
            text: qsTr("Paste ")+"["+copyPaths.length+"]"
            enabled: copyPaths.length > 0
            onTriggered: browser.paste()
        }

    }

}
