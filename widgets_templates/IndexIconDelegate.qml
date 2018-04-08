import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.2 as Kirigami

ItemDelegate
{
    property int folderSize : 32
    property color labelColor : GridView.isCurrentItem && !hovered ? highlightedTextColor : textColor
    property color hightlightedColor : GridView.isCurrentItem || hovered ? highlightColor : "transparent"
    signal rightClicked();

    height: folderSize*2
    width: folderSize*3

    hoverEnabled: true

    background: Rectangle
    {
        color: "transparent"
    }

    MouseArea
    {
        anchors.fill: parent
        acceptedButtons:  Qt.RightButton
        onClicked:
        {
            if(!isMobile && mouse.button === Qt.RightButton)
                rightClicked()
        }
    }

    ColumnLayout
    {
        anchors.fill: parent

        Kirigami.Icon
        {
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignCenter
            source: iconName
            isMask: false

            height: folderSize

        }


        Label
        {
            text: label
            width: parent.width
            Layout.fillWidth: true
            horizontalAlignment: Qt.AlignHCenter
            elide: Qt.ElideRight
            font.pointSize: fontSizes.default
            color: labelColor

            Rectangle
            {
                anchors.fill: parent
                z: -1
                radius: 3
                color: hightlightedColor
                opacity: hovered ? 0.25 : 1
            }

        }
    }
}
