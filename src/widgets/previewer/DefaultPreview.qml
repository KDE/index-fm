import QtQuick 2.14
import QtQuick.Controls 2.14

import org.mauikit.controls 1.3 as Maui

Item
{
    Maui.Icon
    {
        anchors.centerIn: parent
        source: iteminfo.icon
        height: Maui.Style.iconSizes.huge
        width: height
    }
}
