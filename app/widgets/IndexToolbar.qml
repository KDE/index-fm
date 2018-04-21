import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "../widgets_templates"
import "views"


ToolBar
{
    position: ToolBar.Header

    property alias pathBar : pathBar
    property string accentColor : highlightColor

    signal searchClicked()
    signal menuClicked()

    id: pixBar

    RowLayout
    {
        anchors.fill: parent

        Item
        {
            Layout.alignment: Qt.AlignLeft
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.maximumWidth: iconSize

            IndexButton
            {
                anchors.centerIn: parent

                iconName: "application-menu"
                onClicked: menuClicked()

                //                iconColor: globalDrawer.visible ? accentColor : textColor

                hoverEnabled: !isMobile
                ToolTip.delay: 1000
                ToolTip.timeout: 5000
                ToolTip.visible: hovered
                ToolTip.text: qsTr("Menu")
            }
        }


        Item { Layout.fillWidth: true; Layout.maximumWidth: parent.width*0.05 }

        PathBar
        {
            id: pathBar
            Layout.fillWidth: true
        }

        Item { Layout.fillWidth: true; Layout.maximumWidth: parent.width*0.05 }



        Item
        {
            Layout.alignment: Qt.AlignRight
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.maximumWidth: iconSize

            IndexButton
            {
                id: searchView
                anchors.centerIn: parent

                //                iconColor: currentIndex === views.search? accentColor : textColor

                iconName: "edit-find"
                onClicked: searchClicked()

                hoverEnabled: !isMobile
                ToolTip.delay: 1000
                ToolTip.timeout: 5000
                ToolTip.visible: hovered
                ToolTip.text: qsTr("Search")
            }
        }
    }
}

