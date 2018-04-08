import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "../../widgets_templates"
import "icons"

IndexPage
{

    property string currentPath: inx.homePath()
    property var previousPath: []
    property var nextPath: []

    property var views : ({
                              icon : 0,
                              details : 1,
                              tree : 2
                          })
    property int currentView : views.icon


    headerbarTitle: iconsGrid.grid.count + qsTr(" files")
    headerbarExit: false
    headerBarLeft: [
        IndexButton
        {
            iconName: "view-list-icons"
            iconColor: currentView === views.icon ? highlightColor : textColor
        },
        IndexButton
        {
            iconName: "view-list-details"
            iconColor: currentView === views.details ? highlightColor : textColor

        },
        IndexButton
        {
            iconName: "view-list-tree"
            iconColor: currentView === views.tree ? highlightColor : textColor

        }

    ]

    headerBarRight: [


        IndexButton
        {
            iconName: "view-preview"
        },
        IndexButton
        {
            iconName: "overflow-menu"
        }
    ]

    footer: BrowserFooter
    {
        id: browserFooter
    }

    contentItem: IconsView
    {
        id: iconsGrid
        onItemClicked: inx.isDir(path) ?
                           browser.openFolder(path):
                           browser.openFile(path)

    }

    function clear()
    {
        iconsGrid.grid.model.clear()
    }

    function openFile(path)
    {
        inx.openFile(path)
    }

    function openFolder(path)
    {
        previousPath.push(currentPath)
        populate(path)

    }

    function populate(path)
    {
        currentPath = path

        clear()

        var items = inx.getPathContent(path)
        if(items.length > 0)
            for(var i in items)
                iconsGrid.grid.model.append(items[i])

        for(i=0; i < placesSidebar.placesList.count; i++)
            if(currentPath === placesSidebar.placesList.model.get(i).path)
                placesSidebar.placesList.currentIndex = i

        mainHeader.pathBar.append(currentPath)
    }

    function goBack()
    {
        nextPath.push(currentPath)
        populate(previousPath.pop())
    }

    function goNext()
    {
        openFolder(nextPath.pop())

    }

    function goUp()
    {
        openFolder(inx.parentDir(currentPath))
    }


}
