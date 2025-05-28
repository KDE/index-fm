import QtQuick
import QtQuick.Controls

import org.mauikit.controls as Maui
import QtQuick.Effects

Maui.ListBrowserDelegate
{
    id: control

    //    template.headerSizeHint: iconSizeHint + Maui.Style.space.small

    label1.font.pointSize: Maui.Style.fontSizes.big
    label1.font.weight: Font.Bold
    label1.font.bold: true

    background: Rectangle
    {
        radius: Maui.Style.radiusV
        color: Qt.tint(control.Maui.Theme.textColor, Qt.rgba(control.Maui.Theme.backgroundColor.r, control.Maui.Theme.backgroundColor.g, control.Maui.Theme.backgroundColor.b, 0.9))

        Rectangle
        {
            id: _iconRec
            opacity: 0.3
            anchors.fill: parent
            color: Maui.Theme.backgroundColor
            clip: true


            MultiEffect
            {
                id: fastBlur
                visible: GraphicsInfo.api !== GraphicsInfo.Software

                blurEnabled: true
                blur: 1.0
                blurMax: 64
                brightness: 0.4
                saturation: 0.2

                height: parent.height * 2
                width: parent.width * 2
                anchors.centerIn: parent
                source: control.template.iconItem
            }

            Rectangle
            {
                anchors.fill: parent
                opacity: 0.5
                color: Qt.tint(control.Maui.Theme.textColor, Qt.rgba(control.Maui.Theme.backgroundColor.r, control.Maui.Theme.backgroundColor.g, control.Maui.Theme.backgroundColor.b, 0.9))
            }
        }

        // OpacityMask
        // {
        //     source: mask
        //     maskSource: _iconRec
        // }

        Rectangle
        {
            id: mask
            anchors.fill: parent
            gradient: Gradient
            {
                GradientStop { position: 0.2; color: "transparent"}
                GradientStop { position: 0.5; color: control.background.color}
            }
        }
    }

    layer.enabled: GraphicsInfo.api !== GraphicsInfo.Software
    layer.effect: MultiEffect
    {
        maskEnabled: true
        maskThresholdMin: 0.5
        maskSpreadAtMin: 1.0
        maskSpreadAtMax: 0.0
        maskThresholdMax: 1.0
        maskSource: ShaderEffectSource
        {
            sourceItem: Rectangle
            {
                width: control.width
                height: control.height
                radius: Maui.Style.radiusV
            }
        }
    }

}
