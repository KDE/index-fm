import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

GridView
{
    id: grid
    clip: true
    signal serviceClicked(int index)

    property int itemSize : isMobile ? iconSizes.big : iconSizes.big
    property int itemSpacing: isMobile ? space.large : space.huge

    width: parent.width
    height: parent.height

    cellWidth: itemSize + itemSpacing
    cellHeight: itemSize + itemSpacing

    focus: true

    boundsBehavior: Flickable.StopAtBounds
    flickableDirection: Flickable.AutoFlickDirection
    snapMode: GridView.SnapToRow

    model: ListModel {id: gridModel}
    highlightFollowsCurrentItem: true
    highlight: Rectangle
    {
        width: cellWidth
        height: cellHeight
        color: highlightColor
        radius: 3
    }

    delegate: ShareDelegate
    {
        id: delegate
        iconSize : itemSize

        height: grid.cellHeight
        width: grid.cellWidth * 0.8

        Connections
        {
            target: delegate
            onClicked:
            {
                currentIndex = index
                serviceClicked(index)
            }
        }
    }

    onWidthChanged:
    {
        var amount = parseInt(grid.width/(itemSize + itemSpacing),10)
        var leftSpace = parseInt(grid.width-(amount*(itemSize + itemSpacing)), 10)
        var size = parseInt((itemSize + itemSpacing)+(parseInt(leftSpace/amount, 10)), 10)

        size = size > itemSize + itemSpacing ? size : itemSize + itemSpacing

        grid.cellWidth = size
        //            grid.cellHeight = size
    }

}
