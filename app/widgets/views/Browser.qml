import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "../../widgets_templates"
import "../terminal"
import org.kde.kirigami 2.0 as Kirigami

IndexPage
{
    property string currentPath: inx.homePath()
    property var selectedPaths : []
    property var copyPaths : []
    property var cutPaths : []

    property bool isCopy : false
    property bool isCut : false

    property bool selectionMode : false

    property bool detailsView: inx.loadSettings("BROWSER_VIEW", "BROWSER", false) === "false" ? false: true

    property alias terminal : terminalLoader.item
    property alias selectionBar : selectionBar

    property alias grid : viewLoader.item
    property alias detailsDrawer: detailsDrawer

    property var previousPath: []
    property var nextPath: []
    property bool terminalVisible : inx.loadSettings("TERMINAL_VISIBLE", "BROWSER", false) === "true" ? true : false
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

    BrowserMenu
    {
        id: browserMenu
    }

    DetailsDrawer
    {
        id: detailsDrawer
    }

    Component
    {
        id: listViewBrowser
        IndexList
        {}

    }

    Component
    {
        id: gridViewBrowser

        IndexGrid
        {}
    }

    Connections
    {
        target: viewLoader.item
        onItemClicked:
        {
            var item = viewLoader.item.model.get(index)
            if(selectionMode)
                addToSelection(item, true)
            else
            {
                if(inx.isDir(item.path))
                    browser.openFolder(item.path)
                else
                    detailsDrawer.show(item.path)
            }
        }

        onItemDoubleClicked:
        {
            var item = viewLoader.item.model.get(index)

            if(inx.isDir(item.path))
                browser.openFolder(item.path)
            else
                browser.openFile(item.path)
        }
    }

    focus: true
    headerbarTitle: viewLoader.item.count + qsTr(" files")
    headerbarExit: false
    headerBarLeft: IndexButton
    {
        iconName: "view-refresh"
        isMask: true

        onClicked: browser.refresh()
    }

    headerBarRight: IndexButton
    {
        iconName: "overflow-menu"
        isMask: true

        onClicked:  browserMenu.show()
    }


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
            Layout.margins: detailsView ? 0 : contentMargins

            ColumnLayout
            {
                anchors.fill: parent

                Loader
                {
                    id: viewLoader
                    sourceComponent: detailsView ? listViewBrowser : gridViewBrowser

                    Layout.topMargin: detailsView ? 0 : contentMargins * 2

                    Layout.fillWidth: true
                    Layout.fillHeight: true
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

        Loader
        {
            id: terminalLoader
            visible: terminalVisible
            focus: true
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignBottom
            Layout.minimumHeight: 100
            Layout.maximumHeight: parent.height *0.5
            anchors.bottom: parent.bottom
            anchors.top: handle.bottom
            source: !isMobile ? "../terminal/Terminal.qml" : undefined
        }
    }

    function clear()
    {
        viewLoader.item.model.clear()
    }

    function openFile(path)
    {
        console.log("open file", path)
        inx.openFile(path)
    }

    function openFolder(path)
    {
        previousPath.push(currentPath)
        populate(path)

        if(!isMobile)
            terminal.session.sendText("cd " + currentPath + "\n")
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
                viewLoader.item.model.append(items[i])

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
        clean()
        browser.selectionMode = false
    }

    function clean()
    {
        selectedPaths = []
        copyPaths = []
        cutPaths = []
        browserMenu.pasteFiles = 0
        selectionBar.selectionList.model.clear()
    }

    function copy(paths)
    {
        copyPaths = paths
        isCut = false
        isCopy = true
        console.log("Paths to copy", copyPaths)
    }

    function cut(paths)
    {
        cutPaths = paths
        isCut = true
        isCopy = false
    }

    function paste()
    {
        console.log("paste to", currentPath, copyPaths)
        if(isCopy)
            inx.copy(copyPaths, currentPath)
        else if(isCut)
            if(inx.cut(cutPaths, currentPath))
                clearSelection()

    }

    function remove(paths)
    {
        for(var i in paths)
            inx.remove(paths[i])
    }


    function switchView()
    {
        detailsView = !detailsView
        inx.saveSettings("BROWSER_VIEW", detailsView, "BROWSER")
        populate(currentPath)
    }

}
