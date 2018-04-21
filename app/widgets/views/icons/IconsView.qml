import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "../../../widgets_templates"


Pane
{
    property alias grid : grid
    signal itemClicked (var item)
    signal itemSelected(var item)
    IndexGrid
    {
        id: grid
        onFolderClicked: itemClicked(model.get(index))

        itemSize: browser.grid.detailsView ?  iconSizes.medium : iconSizes.large
        detailsView: false
    }
}
