import QtQuick 2.14
import QtQuick.Controls 2.14

import org.mauikit.controls 1.3 as Maui

Item
{
    id: control
    Loader
    {
        anchors.fill: parent
        asynchronous: true
        sourceComponent: iteminfo.mime === "image/gif" || iteminfo.mime === "image/avif" ? _animatedImgComponent : _imgComponent

        Component
        {
            id: _animatedImgComponent
            Maui.AnimatedImageViewer
            {
                source: currentUrl
            }
        }

        Component
        {
            id: _imgComponent
            Maui.ImageViewer
            {
                source: currentUrl
            }
        }
    }


}


