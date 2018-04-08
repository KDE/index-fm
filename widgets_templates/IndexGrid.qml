import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3


GridView
{
    id: folderGridRoot
    property int gridSize : 64

    signal folderClicked(int index)

    clip: true
    width: parent.width
    height: parent.height

    cellHeight: gridSize+(contentMargins*2)
    cellWidth: gridSize+gridSize

    focus: true

    boundsBehavior: Flickable.StopAtBounds
    flickableDirection: Flickable.AutoFlickDirection
    snapMode: GridView.SnapToRow

    model: ListModel {id: gridModel  }

    delegate: IndexIconDelegate
    {
        id: delegate
        folderSize : 32

        Connections
        {
            target: delegate
            onClicked:
            {
                folderGridRoot.currentIndex = index
                folderClicked(index)
            }

            onRightClicked: itemMenu.show(folderGridRoot.model.get(index).path)

        }
    }

    ScrollBar.vertical: ScrollBar{ visible: true}

}
