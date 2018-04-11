import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "../../widgets_templates"
import "icons"
import "../terminal"
import org.kde.kirigami 2.0 as Kirigami


ColumnLayout
{
    property string currentPath: inx.homePath()
    property alias terminal : konsole
    property var previousPath: []
    property var nextPath: []

    property var views : ({
                              icon : 0,
                              details : 1,
                              tree : 2
                          })
    property int currentView : views.icon



    IndexPage
    {
        Layout.fillHeight: true
        Layout.fillWidth: true

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

        contentItem:ColumnLayout
        {

            spacing: 0
            IconsView
            {
                id: iconsGrid
                Layout.fillWidth: true
                Layout.fillHeight: true
                onItemClicked: inx.isDir(path) ?
                                   browser.openFolder(path):
                                   browser.openFile(path)
                anchors.top: parent.top
                anchors.bottom: handle.top

            }

            Rectangle
            {
                id: handle
                Layout.fillWidth: true
                height: 5
                color: "transparent"
                Kirigami.Separator
                {
                    color: "#333"

                    anchors
                    {
                        bottom: parent.bottom
                        right: parent.right
                        left: parent.left
                    }
                }

                MouseArea
                {
                    anchors.fill: parent
                    drag.target: parent
                    drag.axis: Drag.YAxis
                    drag.smoothed: true
                    cursorShape: Qt.SizeVerCursor
                }
            }


            Terminal
            {
                id: konsole
                focus: true
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignBottom
                Layout.minimumHeight: 100
                anchors.bottom: parent.bottom
                anchors.top: handle.bottom
            }

        }
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
        konsole.session.sendText("cd " + currentPath + "\n")

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
