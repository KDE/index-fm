import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "../../widgets_templates"

ToolBar
{
    position: ToolBar.Footer

    RowLayout
    {
        anchors.fill: parent

        Item
        {
            Layout.alignment: Qt.AlignLeft
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.maximumWidth: iconSize*2

            IndexButton
            {
                id: viewBtn
                anchors.centerIn: parent
                isMask: true
                iconName:  browser.grid.detailsView ? "view-list-icons" : "view-list-details"
                iconColor: highlightColor

                onClicked: browser.grid.switchView()
            }

        }

        Item { Layout.fillWidth: true }

        Item
        {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.maximumWidth: iconSize*2

            IndexButton
            {
                anchors.centerIn: parent

                iconName: "go-previous"
                onClicked: browser.goBack()
            }
        }

        Item
        {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.maximumWidth: iconSize*2

            IndexButton
            {
                id: favIcon
                anchors.centerIn: parent

                iconName: "go-up"
                onClicked: browser.goUp()

            }
        }

        Item
        {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.maximumWidth: iconSize*2

            IndexButton
            {
                anchors.centerIn: parent

                iconName: "go-next"
                onClicked: browser.goNext()
            }
        }

        Item { Layout.fillWidth: true }

        Item
        {
            Layout.alignment: Qt.AlignRight
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.maximumWidth: iconSize*2


            IndexButton
            {
                anchors.centerIn: parent
                iconName: "documentinfo"
            }
        }

    }
}
