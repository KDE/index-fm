import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.0 as Kirigami

Drawer
{
    edge: Qt.RightEdge
    width: Kirigami.Units.gridUnit * 17
    height: browserContainer.height
    y: headerBar.height + mainHeader.height
//    visible: opened ? pageStack.currentIndex = 1 && pageStack.wideMode : false

    function show(path)
    {
        console.log(path)
        open()
    }
}
