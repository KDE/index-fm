import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.2 as Kirigami

ItemDelegate
{
    property int iconSize : iconSizes.big
    property string labelColor: GridView.isCurrentItem ? highlightedTextColor : textColor

    background: Rectangle
    {
        color: "transparent"
    }

    ColumnLayout
    {
        anchors.fill: parent

        Item
        {
            Layout.fillHeight: true
            Layout.fillWidth: true

            Kirigami.Icon
            {
                anchors.centerIn: parent
                source: serviceIcon
                isMask: false

                height: iconSize
                width: iconSize

            }
        }

        Item
        {
            Layout.fillHeight: true
            Layout.fillWidth: true
            Label
            {
                text: serviceLabel
                width: parent.width
                height: parent.height * 0.8
                horizontalAlignment: Qt.AlignHCenter
                elide: Qt.ElideRight
                wrapMode: Text.Wrap
                font.pointSize: fontSizes.default
                color: labelColor
            }
        }
    }
}
