import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "../../../widgets_templates"


Pane
{
    property alias grid : grid
    signal itemClicked (string path)
    signal itemSelected(var item)
    IndexGrid
    {
        id: grid
        onFolderClicked: itemClicked(model.get(index).path)
        itemIconSize: 48
    }
}
