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
    property var selectedPaths : []
    property var copyPaths : []
    property var cutPaths : []

    property alias terminal : konsole
    property var previousPath: []
    property var nextPath: []
    property bool terminalVisible : inx.loadSettings("TERMINAL_VISIBLE", "INX", false) === "true" ? true : false
    property var views : ({
                              icon : 0,
                              details : 1,
                              tree : 2
                          })
    property int currentView : views.icon

    Connections
    {
        target: inx
        onPathModified: browser.refresh()
    }

    BrowserOptions
    {
        id: browserOptions
    }

    BrowserMenu
    {
        id: browserMenu
    }



    IndexPage
    {
        Layout.fillHeight: true
        Layout.fillWidth: true
        focus: true
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
                onClicked:  browserOptions.popup()
            }
        ]

        footer: BrowserFooter
        {
            id: browserFooter
        }

        contentItem : ColumnLayout
        {
            spacing: 0

            Item
            {
                id: browserContainer
                Layout.fillWidth: true
                Layout.fillHeight: true

                ColumnLayout
                {
                    anchors.fill: parent
                    IconsView
                    {
                        id: iconsGrid
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        onItemClicked: inx.isDir(path) ?
                                           browser.openFolder(path):
                                           browser.openFile(path)

                    }

                    SelectionBar
                    {
                        id: selectionBar
                        y: -20
                        visible: selectionList.count > 0
                        Layout.fillWidth: true
                        Layout.leftMargin: contentMargins*2
                        Layout.rightMargin: contentMargins*2
                        Layout.bottomMargin: contentMargins*2
                    }
                }

                anchors.top: parent.top
                anchors.bottom: terminalVisible ? handle.top : parent.bottom
            }

            Rectangle
            {
                id: handle
                visible: terminalVisible

                Layout.fillWidth: true
                height: 5
                color: "transparent"
                Kirigami.Separator
                {
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
                visible: terminalVisible
                focus: true
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignBottom
                Layout.minimumHeight: 100
                Layout.maximumHeight: parent.height *0.5
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
        konsole.session.sendText("cd " + currentPath + "\n")
        //        if(selectedPaths.length > 0)
        //            clearSelection()
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
        inx.watchPath(currentPath)

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

    function refresh()
    {
        populate(currentPath)
    }

    function addToSelection(item, append)
    {

        var index = selectedPaths.indexOf(item.path)
        if(index<0)
        {
            selectedPaths.push(item.path)
            selectionBar.append(item)
        }
        //        else
        //        {
        //            if (index !== -1)
        //                selectedPaths.splice(index, 1)
        //        }
    }


    function handleSelection()
    {
        if(selectedPaths.length > 0)
            selectionBar.visible = true

    }

    function clearSelection()
    {
        selectedPaths = []
        selectionBar.selectionList.model.clear()
    }

    function copy(paths)
    {
        copyPaths = paths
        console.log("Paths to copy", copyPaths)
    }

    function paste()
    {
        console.log("paste to", currentPath, copyPaths)
    }
}

