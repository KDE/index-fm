import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Item
{
    height: layout.implicitHeight

      ColumnLayout
    {
        id: layout
        anchors.fill: parent

        Item
        {
            Layout.fillWidth: true
            height: parent.width *0.7
            Layout.margins: contentMargins

            Image
            {
                anchors.centerIn: parent
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                width: parent.width
                height: parent.height
                source: "file://"+currentUrl
                fillMode: Image.PreserveAspectFit
                asynchronous: true
                sourceSize.height: height
                sourceSize.width: width
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
            Layout.alignment: Qt.AlignVCenter
            Layout.margins: contentMargins

            Column
            {
                spacing: space.small
                width: parent.width

                Label
                {

                    text: qsTr("Type: ")+ iteminfo.mimetype
                    elide: Qt.ElideRight
                    wrapMode: Text.Wrap
                    font.pointSize: fontSizes.default
                    color: altColorText

                }
                Label
                {

                    text: qsTr("Date: ")+ iteminfo.date

                    elide: Qt.ElideRight
                    wrapMode: Text.Wrap
                    font.pointSize: fontSizes.default
                    color: altColorText

                }
                Label
                {

                    text: qsTr("Modified: ")+ iteminfo.modified

                    elide: Qt.ElideRight
                    wrapMode: Text.Wrap
                    font.pointSize: fontSizes.default
                    color: altColorText

                }
                Label
                {

                    text: qsTr("Owner: ")+ iteminfo.owner

                    elide: Qt.ElideRight
                    wrapMode: Text.Wrap
                    font.pointSize: fontSizes.default
                    color: altColorText

                }
                Label
                {

                    text: qsTr("Tags: ")+ iteminfo.tags

                    elide: Qt.ElideRight
                    wrapMode: Text.Wrap
                    font.pointSize: fontSizes.default
                    color: altColorText

                }
                Label
                {

                    text: qsTr("Permisions: ")+ iteminfo.permissions

                    elide: Qt.ElideRight
                    wrapMode: Text.Wrap
                    font.pointSize: fontSizes.default
                    color: altColorText
                }
            }
        }
    }
}
