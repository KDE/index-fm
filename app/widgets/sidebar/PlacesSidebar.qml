import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import org.kde.maui 1.0 as Maui
import "../../widgets_templates"

Maui.SideBar
{
    id: placesList

    signal placeClicked (string path)
    focus: true
    clip: true

    section.property :  !placesList.isCollapsed ? "type" : ""
    section.criteria: ViewSection.FullString
    section.delegate: IndexDelegate
    {
        id: delegate
        label: section
        labelTxt.font.pointSize: fontSizes.big

        isSection: true
        boldLabel: true
        height: toolBarHeightAlt
    }

    onItemClicked:
    {
        placeClicked(item.path)

        if(pageStack.currentIndex === 0 && !pageStack.wideMode)
            pageStack.currentIndex = 1
    }

    Component.onCompleted: populate()

    function populate()
    {
        clear()
        var places = inx.getDefaultPaths()
        places.push(inx.getCustomPaths())
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
