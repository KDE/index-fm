import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.14 as Kirigami
import org.mauikit.controls 1.2 as Maui
import QtGraphicalEffects 1.0

Maui.ItemDelegate
{
    id: control

    property alias label1 : _template.label1
    property alias label2 : _template.label2
    property alias label3 : _template.label3
    property alias iconSource : _template.iconSource
    property alias iconSizeHint: _template.iconSizeHint
    property alias template : _template

    background: Rectangle
    {
        radius: Maui.Style.radiusV
        color: Qt.tint(control.Kirigami.Theme.textColor, Qt.rgba(control.Kirigami.Theme.backgroundColor.r, control.Kirigami.Theme.backgroundColor.g, control.Kirigami.Theme.backgroundColor.b, 0.9))

        border.color: control.isCurrentItem || control.hovered ? Kirigami.Theme.highlightColor : "transparent"

    }

    Rectangle
    {
        id: _iconRec
        opacity: 0.3
        anchors.fill: parent
        color: Kirigami.Theme.backgroundColor
        clip: true

        FastBlur
        {
            id: fastBlur
            height: parent.height * 2
            width: parent.width * 2
            anchors.centerIn: parent
            source: _template.iconItem
            radius: 64
            transparentBorder: true
            cached: true
        }

        Rectangle
        {
            anchors.fill: parent
            opacity: 0.5
            color: Qt.tint(control.Kirigami.Theme.textColor, Qt.rgba(control.Kirigami.Theme.backgroundColor.r, control.Kirigami.Theme.backgroundColor.g, control.Kirigami.Theme.backgroundColor.b, 0.9))
        }
    }

    OpacityMask
    {
        source: mask
        maskSource: _iconRec
    }

    LinearGradient
    {
        id: mask
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.2; color: "transparent"}
            GradientStop { position: 0.5; color: control.background.color}
        }

        start: Qt.point(0, 0)
        end: Qt.point(_iconRec.width, _iconRec.height)
    }

    Maui.ListItemTemplate
    {
        id: _template
        anchors.fill: parent
        headerSizeHint: iconSizeHint + Maui.Style.space.small

        label1.font.pointSize: Maui.Style.fontSizes.big
        label1.font.weight: Font.Bold
        label1.font.bold: true
    }

    Rectangle
    {
        Kirigami.Theme.inherit: false
        anchors.fill: parent
        color: "transparent"
        radius: Maui.Style.radiusV
        border.color: control.isCurrentItem || control.hovered ? Kirigami.Theme.highlightColor : Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.2)

        Rectangle
        {
            anchors.fill: parent
            color: "transparent"
            radius: parent.radius - 0.5
            border.color: Qt.lighter(Kirigami.Theme.backgroundColor, 2)
            opacity: 0.2
            anchors.margins: 1
        }
    }

    layer.enabled: true
    layer.effect: OpacityMask
    {
        maskSource: Item
        {
            width: control.width
            height: control.height

            Rectangle
            {
                anchors.fill: parent
                radius: Maui.Style.radiusV
            }
        }
    }

}
