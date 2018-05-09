import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.2 as Kirigami

Page
{
    property int pageMargins : contentMargins
    property bool headerbarVisible : true
    property bool headerbarExit : true
    property string headerbarExitIcon : "dialog-close"
    property string headerbarTitle: ""
    property alias headerBar: headerBar
    property alias headerBarRight : headerbarActionsRight.children
    property alias headerBarLeft : headerbarActionsLeft.children


    signal exit();

    clip: true
    padding: 0

    header: ToolBar
    {
        id: headerBar
        height: implicitHeight
        visible: headerbarVisible
        position: ToolBar.Header

        RowLayout
        {
            id: headerbarLayout
            anchors.fill: parent

            IndexButton
            {
                id: exitBtn
                Layout.alignment : Qt.AlignLeft
                visible: headerbarExit
                anim : true
                iconName : headerbarExitIcon
                onClicked : exit()
            }

            Row
            {
                id: headerbarActionsLeft
                Layout.alignment : Qt.AlignLeft
                spacing: space.small
            }

            Label
            {
                text : headerbarTitle || ""
                Layout.fillHeight : true
                Layout.fillWidth : true
                Layout.alignment : Qt.AlignCenter

                elide : Text.ElideRight
                font.bold : false
                color : textColor
                font.pointSize: fontSizes.big
                horizontalAlignment : Text.AlignHCenter
                verticalAlignment :  Text.AlignVCenter
            }

            Row
            {
                id: headerbarActionsRight
                spacing: space.small
                Layout.alignment : Qt.AlignRight
            }
        }
    }
}
