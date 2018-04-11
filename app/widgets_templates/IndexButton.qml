import QtQuick 2.9
import QtQuick.Controls 2.2
import org.kde.kirigami 2.2 as Kirigami

ToolButton
{
    id: babeButton

    property string iconName
    property int iconSize : iconSizes.medium
    property color iconColor: textColor
    readonly property string defaultColor :  textColor
    property bool anim : false

    Kirigami.Icon
    {
        id: pixIcon
        anchors.centerIn: parent
        width: iconSize
        height: iconSize
        visible: true
        color: iconColor
        source: iconName
        isMask: true
    }


    onClicked: if(anim) animIcon.running = true

    flat: true
    highlighted: false


    SequentialAnimation
    {
        id: animIcon
        PropertyAnimation
        {
            target: pixIcon
            property: "color"
            easing.type: Easing.InOutQuad
            from: highlightColor
            to: iconColor
            duration: 500
        }
    }
}


