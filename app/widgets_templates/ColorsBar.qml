import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

GridLayout
{
    signal colorPicked(string color)
    anchors.verticalCenter: parent.verticalCenter
    rowSpacing: space.medium
    property string currentColor
    property int size : iconSizes.medium
    columns: 5
    rows: 1
    Item
    {

        Layout.fillHeight: true
        Layout.fillWidth: true
        Layout.row: 1
        Layout.column: 1

        Rectangle
        {
            color:"#f21b51"
            anchors.centerIn: parent
            height: size
            width: height
            radius: unit*4
            border.color: Qt.darker(color, 1.7)

            MouseArea
            {
                anchors.fill: parent
                onClicked:
                {
                    currentColor = parent.color
                    colorPicked("folder-red")
                }
            }
        }
    }

    Item
    {
        Layout.fillHeight: true
        Layout.fillWidth: true
        Layout.row: 1
        Layout.column: 2

        Rectangle
        {
            color:"#f9a32b"
            anchors.centerIn: parent
            height: size
            width: height
            radius: unit*4
            border.color: Qt.darker(color, 1.7)

            MouseArea
            {
                anchors.fill: parent
                onClicked:
                {
                    currentColor = parent.color
                    colorPicked("folder-orange")
                }
            }
        }
    }

    Item
    {
        Layout.fillHeight: true
        Layout.fillWidth: true
        Layout.row: 1
        Layout.column: 3

        Rectangle
        {
            color:"#3eb881"
            anchors.centerIn: parent
            height: size
            width: height
            radius: unit*4
            border.color: Qt.darker(color, 1.7)

            MouseArea
            {
                anchors.fill: parent
                onClicked:
                {
                    currentColor = parent.color
                    colorPicked("folder-green")
                }
            }
        }
    }


    Item
    {
        Layout.fillHeight: true
        Layout.fillWidth: true
        Layout.row: 1
        Layout.column: 4

        Rectangle
        {
            color:"#b2b9bd"
            anchors.centerIn: parent
            height: size
            width: height
            radius: unit*4
            border.color: Qt.darker(color, 1.7)

            MouseArea
            {
                anchors.fill: parent
                onClicked:
                {
                    currentColor = parent.color
                    colorPicked("folder-grey")
                }
            }
        }
    }


    Item
    {
        Layout.fillHeight: true
        Layout.fillWidth: true
        Layout.row: 1
        Layout.column: 5

        Rectangle
        {
            color:"#474747"
            anchors.centerIn: parent
            height: size
            width: height
            radius: unit*4
            border.color: Qt.darker(color, 1.7)

            MouseArea
            {
                anchors.fill: parent
                onClicked:
                {
                    currentColor = parent.color
                    colorPicked("folder-black")
                }
            }
        }
    }


//    Item
//    {
//        Layout.fillHeight: true
//        Layout.fillWidth: true
//        Layout.row: 2
//        Layout.column: 3

//        Rectangle
//        {
//            color:"#c10070"
//            anchors.centerIn: parent
//            height: size
//            width: height
//            radius: unit*4
//            border.color: Qt.darker(color, 1.7)

//            MouseArea
//            {
//                anchors.fill: parent
//                onClicked:
//                {
//                    currentColor = parent.color
//                    colorPicked(currentColor)
//                }
//            }
//        }
//    }

//    Item
//    {
//        Layout.fillHeight: true
//        Layout.fillWidth: true
//        Layout.row: 2
//        Layout.column: 4

//        Rectangle
//        {
//            color:"#f3d053"
//            anchors.centerIn: parent
//            height: size
//            width: height
//            radius: unit*4
//            border.color: Qt.darker(color, 1.7)

//            MouseArea
//            {
//                anchors.fill: parent
//                onClicked:
//                {
//                    currentColor = parent.color
//                    colorPicked(currentColor)
//                }
//            }
//        }
//    }

//    Item
//    {

//            Layout.fillHeight: true
//            Layout.fillWidth: true
//            Layout.row: 1
//            Layout.column: 1
//              Rectangle
//        {
//            color:"#474747"
//            anchors.centerIn: parent
//            height: size
//            width: height
//            radius: unit*4
//            border.color: Qt.darker(color, 1.7)

//            MouseArea
//            {
//                anchors.fill: parent
//                onClicked:
//                {
//                    currentColor = parent.color
//                    colorPicked(currentColor)
//                }
//            }
//        }
//    }
}
