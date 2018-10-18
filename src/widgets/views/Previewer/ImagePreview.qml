import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

    ColumnLayout
    {
        id: layout
        anchors.fill: parent

        Item
        {
            Layout.fillWidth: true
            Layout.fillHeight: true
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

            Label
            {
                Layout.fillWidth: true
                Layout.preferredHeight: rowHeight
                Layout.margins: contentMargins

                text: iteminfo.name

                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                elide: Qt.ElideRight
                wrapMode: Text.Wrap
                font.pointSize: fontSizes.big
                font.weight: Font.Bold
                font.bold: true

            }


        Label
        {

            text: qsTr("Type: ")+ iteminfo.mime
            elide: Qt.ElideRight
            wrapMode: Text.Wrap
            font.pointSize: fontSizes.default


        }
        Label
        {

            text: qsTr("Date: ")+ iteminfo.date

            elide: Qt.ElideRight
            wrapMode: Text.Wrap
            font.pointSize: fontSizes.default


        }
        Label
        {
            text: qsTr("Modified: ")+ iteminfo.modified

            elide: Qt.ElideRight
            wrapMode: Text.Wrap
            font.pointSize: fontSizes.default


        }
        Label
        {
            text: qsTr("Owner: ")+ iteminfo.owner

            elide: Qt.ElideRight
            wrapMode: Text.Wrap
            font.pointSize: fontSizes.default


        }
        Label
        {
            text: qsTr("Tags: ")+ iteminfo.tags

            elide: Qt.ElideRight
            wrapMode: Text.Wrap
            font.pointSize: fontSizes.default
        }
        Label
        {
            text: qsTr("Permisions: ")+ iteminfo.permissions

            elide: Qt.ElideRight
            wrapMode: Text.Wrap
            font.pointSize: fontSizes.default
        }
    }

