import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "../../../widgets_templates"

Item
{
    anchors.fill: parent

    ColumnLayout
    {
        anchors.fill: parent

        Item
        {

            Layout.fillWidth: true
            height: parent.width *0.3
            Layout.margins: contentMargins

            IndexButton
            {
                anchors.centerIn: parent
                flat: true
                size: iconSizes.huge
                iconName: iteminfo.iconName
            }
        }

        Item
        {
            Layout.fillWidth: true
            height: rowHeight
            width: parent.width* 0.8

            Layout.margins: contentMargins

            Label
            {
                text: iteminfo.name
                width: parent.width
                height: parent.height
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                elide: Qt.ElideRight
                wrapMode: Text.Wrap
                font.pointSize: fontSizes.big
                font.weight: Font.Bold
                font.bold: true
                color: altColorText

            }
        }

        Item
        {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: contentMargins

            Column
            {
                spacing: space.small
                width: parent.width
                height: parent.height
                Label
                {
                    text: qsTr("Type: ")+ iteminfo.mimetype
                    horizontalAlignment: Qt.AlignHCenter
                    verticalAlignment: Qt.AlignVCenter
                    elide: Qt.ElideRight
                    wrapMode: Text.Wrap
                    font.pointSize: fontSizes.default
                    color: altColorText

                }
                Label
                {
                    text: qsTr("Date: ")+ iteminfo.date
                    horizontalAlignment: Qt.AlignHCenter
                    verticalAlignment: Qt.AlignVCenter
                    elide: Qt.ElideRight
                    wrapMode: Text.Wrap
                    font.pointSize: fontSizes.default
                    color: altColorText

                }
                Label
                {
                    text: qsTr("Modified: ")+ iteminfo.modified
                    horizontalAlignment: Qt.AlignHCenter
                    verticalAlignment: Qt.AlignVCenter
                    elide: Qt.ElideRight
                    wrapMode: Text.Wrap
                    font.pointSize: fontSizes.default
                    color: altColorText

                }
                Label
                {
                    text: qsTr("Owner: ")+ iteminfo.owner
                    horizontalAlignment: Qt.AlignHCenter
                    verticalAlignment: Qt.AlignVCenter
                    elide: Qt.ElideRight
                    wrapMode: Text.Wrap
                    font.pointSize: fontSizes.default
                    color: altColorText

                }
                Label
                {
                    text: qsTr("Tags: ")+ iteminfo.tags
                    horizontalAlignment: Qt.AlignHCenter
                    verticalAlignment: Qt.AlignVCenter
                    elide: Qt.ElideRight
                    wrapMode: Text.Wrap
                    font.pointSize: fontSizes.default
                    color: altColorText

                }
                Label
                {
                    text: qsTr("Permisions: ")+ iteminfo.permissions
                    horizontalAlignment: Qt.AlignHCenter
                    verticalAlignment: Qt.AlignVCenter
                    elide: Qt.ElideRight
                    wrapMode: Text.Wrap
                    font.pointSize: fontSizes.default
                    color: altColorText

                }
            }
        }
    }
}
