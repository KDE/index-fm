import QtQuick
import QtQuick.Controls

import org.mauikit.controls as Maui

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
