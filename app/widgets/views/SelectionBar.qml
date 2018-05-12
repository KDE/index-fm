import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.0 as Kirigami
import "../../widgets_templates"
import org.kde.maui 1.0 as Maui

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
        color: altColor
        radius: 4
        opacity: 0.6
        border.color: Qt.darker(altColor, 1.6)

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
            color: altColor

            anchors.verticalCenter: parent.top
            anchors.horizontalCenter: parent.left

            Maui.ToolButton
            {
                anchors.centerIn: parent
                iconName: "window-close"
                iconColor: altColorText
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
                labelColor: altColorText
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

            Maui.ToolButton
            {
                anchors.centerIn: parent
                iconName: "overflow-menu"
                iconColor: altColorText
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
