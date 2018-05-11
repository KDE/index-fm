import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

ListView
{
    id: viewerRoot
    property bool detailsView : false
    property int itemSize : iconSizes.big
    signal itemClicked(int index)
    signal itemDoubleClicked(int index)

//    maximumFlickVelocity: 400

    snapMode: ListView.SnapToItem

    width: parent.width
    height: parent.height

    clip: true
    focus: true

    model: ListModel { id: listModel }
    delegate: IndexIconDelegate
    {
        id: delegate
        isDetails: true
        width: parent.width
        height: itemSize + space.big

        folderSize : itemSize
        showTooltip: true

        Connections
        {
            target: delegate
            onClicked:
            {
                viewerRoot.currentIndex = index
                itemClicked(index)
            }

            onDoubleClicked:
            {
                viewerRoot.currentIndex = index
                itemDoubleClicked(index)
            }

            onPressAndHold:
            {
                viewerRoot.currentIndex = index
                itemMenu.show(viewerRoot.model.get(index).path)
            }

            onRightClicked:
            {
                viewerRoot.currentIndex = index
                    itemMenu.show(viewerRoot.model.get(index).path)
            }

            onEmblemClicked:
            {
                var item = viewerRoot.model.get(index)
                browser.addToSelection(item, true)
            }
        }
    }

    ScrollBar.vertical: ScrollBar{ visible: true}

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
