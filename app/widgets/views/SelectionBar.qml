import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.0 as Kirigami
import "../../widgets_templates"

Item
{
    property alias selectionList : selectionList

    property int barHeight : 54

    height: barHeight
    width: parent.width


    Rectangle
    {
        anchors.fill: parent
        z:-1
        color: Kirigami.Theme.complementaryBackgroundColor
        radius: 4
        opacity: 0.8
        border.color: "black"
    }

    ListView
    {
        id: selectionList
        width: parent.width* 0.9
        height: parent.height * 0.9
        anchors.centerIn: parent

        orientation: ListView.Horizontal
        clip: true
        spacing: 2

        focus: true
        interactive: true

        model: ListModel{}

        delegate: IndexIconDelegate
        {
            id: delegate
            folderSize: 32
            showLabel: true
            emblemAdded: true
            keepEmblemOverlay: true
            showSelectionBackground: false
            labelColor: "white"
            Connections
            {
                target: delegate
                onEmblemClicked: selectionList.model.remove(index)
            }
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
    }
}
