import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3


GridView
{
    id: folderGridRoot

    property int itemSize : iconSizes.large
    property int itemSpacing: itemSize*0.5 + (isMobile ? space.small : space.large)

    signal folderClicked(int index)

    clip: true
    width: parent.width
    height: parent.height

    cellWidth: itemSize + itemSpacing
    cellHeight: itemSize + itemSpacing

    focus: true

    boundsBehavior: Flickable.StopAtBounds
    flickableDirection: Flickable.AutoFlickDirection
    snapMode: GridView.SnapToRow

    model: ListModel {id: gridModel  }

    delegate: IndexIconDelegate
    {
        id: delegate

        width: cellWidth * 0.9
        height: cellHeight * 0.9

        folderSize : itemSize
        showTooltip: true

        Connections
        {
            target: delegate
            onClicked:
            {
                folderGridRoot.currentIndex = index
                folderClicked(index)
            }

            onPressAndHold:
            {
                folderGridRoot.currentIndex = index
                itemMenu.show(folderGridRoot.model.get(index).path)
            }

            onRightClicked:
            {
                folderGridRoot.currentIndex = index
                itemMenu.show(folderGridRoot.model.get(index).path)
            }

            onEmblemClicked:
            {
                var item = folderGridRoot.model.get(index)
                browser.addToSelection(item, true)
            }
        }
    }

    ScrollBar.vertical: ScrollBar{ visible: true}

    onWidthChanged:
    {
        var amount = parseInt(width/(itemSize + itemSpacing),10)
        var leftSpace = parseInt(width-(amount*(itemSize + itemSpacing)), 10)
        var size = parseInt((itemSize + itemSpacing)+(parseInt(leftSpace/amount, 10)), 10)

        size = size > itemSize + itemSpacing ? size : itemSize + itemSpacing

        cellWidth = size
        //            grid.cellHeight = size
    }

    MouseArea
    {
        anchors.fill: parent
        z: -1
        acceptedButtons:  Qt.RightButton | Qt.LeftButton
        onClicked:
        {
            if(!isMobile && mouse.button === Qt.RightButton)
                browserMenu.show()
            else
                clearSelection()
        }

        onPressAndHold: browserMenu.show()
    }
}
