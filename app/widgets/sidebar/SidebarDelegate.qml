import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import org.kde.kirigami 2.2 as Kirigami
import org.kde.maui 1.0 as Maui
import "../../widgets_templates"

ItemDelegate
{
    property bool isCurrentListItem :  ListView.isCurrentItem

    property int sidebarIconSize : isMobile ? iconSizes.big : iconSizes.small
    width: parent.width
    height: sidebarIconSize + space.big

    clip: true

    property string labelColor: ListView.isCurrentItem ? highlightedTextColor : textColor

    Rectangle
    {
        anchors.fill: parent
        color: isCurrentListItem ? highlightColor :
                                   index % 2 === 0 ? Qt.lighter(backgroundColor,1.2) :
                                                     backgroundColor
    }

    RowLayout
    {
        anchors.fill: parent

        Item
        {
            Layout.fillHeight: true
            width: parent.height

            Maui.ToolButton
            {
                anchors.centerIn: parent
                iconName: model.icon? model.icon : ""
                size: sidebarIconSize
                isMask: !isMobile
                iconColor: labelColor
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

                text: model.label
                font.bold: false
                elide: Text.ElideRight

                font.pointSize: isMobile ? fontSizes.big : fontSizes.default
                color: labelColor
            }
        }
    }
}
