import QtQuick 2.9
import QtQuick.Controls 2.2

ToolButton
{
    id: babeButton

    property bool isMask :  false
    property string iconName
    property int size : iconSizes.medium
    property color iconColor: textColor
    readonly property string defaultColor :  textColor
    property bool anim : false

    icon.name:  iconName
    icon.width:  size
    icon.height:  size
    icon.color: !isMask  ?  "transparent" : (down ? highlightColor : (iconColor || defaultColor))

    onClicked: if(anim) animIcon.running = true

    flat: true
    highlighted: false


    SequentialAnimation
    {
        id: animIcon
        PropertyAnimation
        {
            target: babeButton
            property: "color"
            easing.type: Easing.InOutQuad
            from: highlightColor
            to: iconColor
            duration: 500
        }
    }
}


