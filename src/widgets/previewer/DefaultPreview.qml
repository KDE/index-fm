import QtQuick 2.9
import QtQuick.Controls 2.2

import org.kde.kirigami 2.7 as Kirigami

Item
{
    Kirigami.Icon
    {
        anchors.centerIn: parent
        source: iteminfo.icon
        height: Maui.Style.iconSizes.huge
        width: height
    }
}
