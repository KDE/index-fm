import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.0 as Kirigami
import "../../widgets_templates"

Item
{
    property alias selectionList : selectionList
    property alias anim : anim
    property int barHeight : iconSizes.big + (isMobile ? space.big : space.large)
    property color animColor : "black"

    height: barHeight
    width: parent.width

    Rectangle
    {
        id: bg
        anchors.fill: parent
        z:-1
        color: Kirigami.Theme.complementaryBackgroundColor
        radius: 4
        opacity: 0.6
        border.color: "black"

        SequentialAnimation
        {
            id: anim
            PropertyAnimation
            {
                target: bg
                property: "color"
                easing.type: Easing.InOutQuad
                from: animColor
                to: Kirigami.Theme.complementaryBackgroundColor
                duration: 500
            }
        }
    }

    RowLayout
    {
        anchors.fill: parent
        Rectangle
        {
            height: iconSizes.medium
            width: iconSizes.medium
            radius: Math.min(width, height)
            color: Kirigami.Theme.complementaryBackgroundColor

            anchors.verticalCenter: parent.top
            anchors.horizontalCenter: parent.left

            IndexButton
            {
                anchors.centerIn: parent
                isMask: true
                iconName: "window-close"
                iconColor: "white"
                size: iconSizes.small
                flat: true
                onClicked: clearSelection()
            }
        }


        ListView
        {
            id: selectionList
            Layout.fillHeight: true
            Layout.fillWidth: true
            anchors.verticalCenter: parent.verticalCenter
            height: parent.height

            orientation: ListView.Horizontal
            clip: true
            spacing: space.small

            focus: true
            interactive: true

            model: ListModel{}

            delegate: IndexIconDelegate
            {
                id: delegate
                anchors.verticalCenter: parent.verticalCenter
                height:  iconSizes.big + (isMobile ? space.medium : space.big)
                width: iconSizes.big + (isMobile? space.big : space.large)
                folderSize: iconSizes.big
                showLabel: true
                emblemAdded: true
                keepEmblemOverlay: true
                showSelectionBackground: false
                labelColor: "white"
                showTooltip: true
                Connections
                {
                    target: delegate
                    onEmblemClicked: removeSelection(index)
                }
            }
        }

        Item
        {
            Layout.alignment: Qt.AlignRight
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.maximumWidth: iconSizes.medium

            IndexButton
            {
                anchors.centerIn: parent
                iconName: "overflow-menu"
                iconColor: "white"
                onClicked: itemMenu.showMultiple()
            }
        }

        Rectangle
        {
            height: iconSizes.medium
            width: iconSizes.medium
            radius: Math.min(width, height)
            color: highlightColor

            anchors.verticalCenter: parent.top
            anchors.horizontalCenter: parent.right

            Label
            {
                anchors.fill: parent
                anchors.centerIn: parent
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                font.pointSize: fontSizes.default
                font.weight: Font.Bold
                font.bold: true
                color: highlightedTextColor
                text: selectionList.count
            }

            MouseArea
            {
                anchors.fill: parent
                onClicked: clean()
            }
        }

    }

    function removeSelection(index)
    {
        var item = selectionList.model.get(index)

        var indexof = selectedPaths.indexOf(item.path)
        if (indexof !== -1)
        {
            selectedPaths.splice(index, 1)
            selectionList.model.remove(index)
        }

    }

    function append(item)
    {
        for(var i = 0; i < selectionList.count ; i++ )
            if(selectionList.model.get(i).path === item.path)
            {
                selectionList.model.remove(i)
                return
            }

        selectionList.model.append(item)
        selectionList.positionViewAtEnd()
    }

    function animate(color)
    {
        animColor = color
        anim.running = true
    }
}
