import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.2 as Kirigami

ItemDelegate
{
    property int folderSize : 32

    property bool showLabel : true
    property bool showSelectionBackground : true
    property bool showTooltip : false

    property bool emblemAdded : false
    property bool keepEmblemOverlay : false

    property color labelColor : (GridView.isCurrentItem || (keepEmblemOverlay && emblemAdded)) && !hovered && showSelectionBackground? highlightedTextColor : textColor
    property color hightlightedColor : GridView.isCurrentItem || hovered || (keepEmblemOverlay && emblemAdded) ? highlightColor : "transparent"

    signal rightClicked();
    signal emblemClicked(int index);

    height: folderSize + (folderSize * 0.6)
    width: folderSize+ (folderSize * 0.7)
    focus: true
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

    IndexButton
    {
        id: emblem
        iconName: (keepEmblemOverlay && emblemAdded) ? "emblem-remove" : "emblem-added"
        visible: parent.hovered /*|| (keepEmblemOverlay && emblemAdded)*/
        isMask: false
        z: 999
        anchors
        {
            top: parent.top
            left: parent.left
        }

        onClicked:
        {
            emblemAdded = !emblemAdded
            emblemClicked(index)
        }
    }

    ColumnLayout
    {
        anchors.fill: parent


        Item
        {
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignCenter
            Kirigami.Icon
            {
                anchors.centerIn: parent
                source: iconName
                isMask: false

                width: folderSize
                height: folderSize
            }

            ToolTip.delay: 1000
            ToolTip.timeout: 5000
            ToolTip.visible: hovered && showTooltip
            ToolTip.text: path
        }


        Label
        {
            visible: showLabel
            text: label
            width: parent.width
            Layout.fillWidth: true
            horizontalAlignment: Qt.AlignHCenter
            elide: Qt.ElideRight
            font.pointSize: fontSizes.default
            color: labelColor

            Rectangle
            {
                visible: parent.visible && showSelectionBackground
                anchors.fill: parent
                z: -1
                radius: 3
                color: hightlightedColor
                opacity: hovered ? 0.25 : 1
            }

        }
    }

}
