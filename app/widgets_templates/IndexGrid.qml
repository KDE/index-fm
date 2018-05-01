import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3


GridView
{
    id: folderGridRoot

    property bool detailsView : false
    property int itemSize : iconSizes.large
    property int itemSpacing: itemSize * 0.5 + (isMobile ? (detailsView ? space.medium : space.big) :
                                                           (detailsView ? space.big : space.large))

    signal folderClicked(int index)
    signal folderDoubleClicked(int index)

    flow: detailsView ? GridView.FlowTopToBottom : GridView.FlowLeftToRight
    clip: true
    width: parent.width
    height: parent.height

    cacheBuffer: cellHeight * 2

    cellWidth: (itemSize * (detailsView ? 5 : 1)) + itemSpacing
    cellHeight: itemSize + itemSpacing

    focus: true

    boundsBehavior: Flickable.StopAtBounds
    flickableDirection: Flickable.AutoFlickDirection
    snapMode: GridView.SnapToRow

    model: ListModel { id: gridModel  }

    delegate: IndexIconDelegate
    {
        id: delegate

        isDetails: detailsView
        width: cellWidth * (detailsView ? 1 : 0.9)
        height: cellHeight * (detailsView ? 0.5 : 0.9)

        folderSize : itemSize
        showTooltip: true

        Connections
        {
            target: delegate
            onClicked:
            {
                folderGridRoot.currentIndex = index
                if(isMobile)
                    folderClicked(index)
            }

            onDoubleClicked:
            {
                folderGridRoot.currentIndex = index
                if(!isMobile)
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

    ScrollBar.horizontal: ScrollBar{ visible: folderGridRoot.flow === GridView.FlowTopToBottom}
    // ScrollBar.vertical: ScrollBar{ visible: folderGridRoot.flow === GridView.FlowLeftToRight}

    onWidthChanged: adaptGrid()

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

    function switchView()
    {
        detailsView = !detailsView
        adaptGrid()

    }

    function adaptGrid()
    {
        if(detailsView)
            cellWidth = (itemSize * (detailsView ? 5 : 1))+ itemSpacing
        else {
            var amount = parseInt(width/(itemSize + itemSpacing),10)
            var leftSpace = parseInt(width-(amount*(itemSize + itemSpacing)), 10)
            var size = parseInt((itemSize + itemSpacing)+(parseInt(leftSpace/amount, 10)), 10)

            size = size > itemSize + itemSpacing ? size : itemSize + itemSpacing

            cellWidth = size
        }

    }

}
