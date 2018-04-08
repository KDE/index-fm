import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import org.kde.kirigami 2.2 as Kirigami

ItemDelegate
{
    width: parent.width
    height: rowHeight
    clip: true

    property string labelColor: ListView.isCurrentItem ? highlightedTextColor : textColor

    Rectangle
    {
        anchors.fill: parent
        color: index % 2 === 0 ? Qt.darker(backgroundColor) : "transparent"
        opacity: 0.05
    }

    RowLayout
    {
        anchors.fill: parent

        Item
        {
            Layout.fillHeight: true
            width: parent.height

            Kirigami.Icon
            {
                anchors.centerIn: parent
                source: iconName? iconName : ""
                color: labelColor
                width: iconSizes.small
                height: iconSizes.small
            }
        }

        Item
        {
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter

            Label
            {
                height: parent.height
                width: parent.width
                verticalAlignment:  Qt.AlignVCenter
                horizontalAlignment: Qt.AlignLeft

                text: label
                font.bold: false
                elide: Text.ElideRight

                font.pointSize: fontSizes.default
                color: labelColor
            }
        }
    }
}
