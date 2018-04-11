import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.0 as Kirigami

ItemDelegate
{
    height: 30
    width: 80
    property color labelColor : ListView.isCurrentItem ? highlightColor : textColor
    property color borderColor : Qt.tint(Kirigami.Theme.textColor, Qt.rgba(Kirigami.Theme.backgroundColor.r, Kirigami.Theme.backgroundColor.g, Kirigami.Theme.backgroundColor.b, 0.7))
    anchors.verticalCenter: parent.verticalCenter
    background: Rectangle
    {
        color: buttonBackgroundColor

        Kirigami.Separator
        {
            anchors
            {
                top: parent.top
                bottom: parent.bottom
                right: parent.right
            }
            color: borderColor
        }
    }

    RowLayout
    {
        width: parent.width
        height: parent.height
        Item
        {
            id: pathLabel

            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignHCenter
            Layout.margins: 10

            Label
            {
                text: label
                anchors.fill: parent
                horizontalAlignment: Qt.AlignHCenter

                elide: Qt.ElideRight
                font.pointSize: fontSizes.default
                color: labelColor
            }
        }
    }
}
