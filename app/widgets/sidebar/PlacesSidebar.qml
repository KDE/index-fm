import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "../../widgets_templates"

ColumnLayout
{
    property alias placesList : placesList
    signal placeClicked (string path)
    focus: true

    ListView
    {
        id: placesList
        clip: true
        Layout.fillHeight: true
        Layout.fillWidth: true

        keyNavigationEnabled: true

        focus: true
        interactive: true
        highlightFollowsCurrentItem: true
        highlightMoveDuration: 0
        snapMode: ListView.SnapToItem

        section.property : "type"
        section.criteria: ViewSection.FullString
        section.delegate: IndexDelegate
        {
            id: delegate
            label: section
            labelTxt.font.pointSize: fontSizes.big

            isSection: true
            boldLabel: true
            height: mainHeader.height
        }


        model: ListModel {}

        delegate: SidebarDelegate
        {
            id: placeDelegate

            Connections
            {
                target: placeDelegate

                onClicked:
                {
                    placesList.currentIndex = index
                    placeClicked(placesList.model.get(index).path)

                    if(pageStack.currentIndex === 0 && !pageStack.wideMode)
                        pageStack.currentIndex = 1
                }
            }

        }
    }

    Component.onCompleted: populate()

    function populate()
    {
        clear()
        var places = inx.getDefaultPaths()
        places.push(inx.getBookmarks())
        places.push(inx.getDevices())

        if(places.length > 0)
            for(var i in places)
                placesList.model.append(places[i])

    }

    function clear()
    {
        placesList.model.clear()
    }
}
