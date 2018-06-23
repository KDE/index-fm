import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "../../widgets_templates"
import "../terminal"
import org.kde.kirigami 2.0 as Kirigami
import org.kde.maui 1.0 as Maui

Maui.Page
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
    property alias browserMenu: browserMenu

    property var previousPath: []
    property var nextPath: []
    property bool terminalVisible : inx.loadSettings("TERMINAL_VISIBLE", "BROWSER", false) === "true" ? true : false
    property var views : ({
                              icon : 0,
                              details : 1,
                              tree : 2
                          })

    property int currentView : views.icon

    leftPadding: detailsView ? 0 : contentMargins
    rightPadding: leftPadding
    topPadding: leftPadding
    bottomPadding: leftPadding

    Connections
    {
        target: inx
        onPathModified: browser.refresh()
        onItemReady: browser.append(item)
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
        { }
    }

    Connections
    {
        target: viewLoader.item
        onItemClicked: openItem(index)

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
    headBarVisible: false

    Maui.Holder
    {
        id: holder
        message: inx.fileExists(currentPath) ? qsTr("<h3>Folder is empty!</h3><p>You can add new files to it</p>"):
                                               qsTr("<h3>Folder doesn't exists!</h3><p>Create Folder?</p>")
        visible: viewLoader.item.count === 0

        onActionTriggered: console.log("nana")

    }

    ColumnLayout
    {
        spacing: 0
        anchors.fill: parent
        visible: !holder.visible

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
            source: !isMobile ? "../terminal/Terminal.qml" : ""
        }
    }

    function openItem(index)
    {
        console.log("exde",index)
        var item = viewLoader.item.model.get(index)


        if(selectionMode && !inx.isDir(item.path))
            addToSelection(item, true)
        else
        {
            var path = item.path
            if(inx.isDir(path))
                browser.openFolder(path)
            else if(inx.isCustom(path))
                browser.openFolder(path)
            else if(inx.isApp(path))
                browser.launchApp(path)
            else
            {
                if (isMobile)
                    detailsDrawer.show(path)
                else
                    browser.openFile(path)
            }
        }
    }

    function clear()
    {
        viewLoader.item.model.clear()
    }

    function launchApp(path)
    {
        inx.runApplication(path, "")
    }

    function openFile(path)
    {
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

    function openCustomPath(path)
    {
        console.log("openign custom location")

        var items = inx.getCustomPathContent(path)
        if(items.length > 0)
            for(var i in items)
                viewLoader.item.model.append(items[i])

        for(i=0; i < placesSidebar.count; i++)
            if(currentPath === placesSidebar.model.get(i).path)
                placesSidebar.currentIndex = i

        pathBar.append(currentPath)
    }

    function populate(path)
    {
        currentPath = path
        clear()

        if(path.indexOf("#") === 0)
        {
            browser.openCustomPath(path)
            return;
        }

        /* should it really return the paths or just use the signal? */
        var items = inx.getPathContent(path)

        for(var i=0; i < placesSidebar.count; i++)
            if(currentPath === placesSidebar.model.get(i).path)
                placesSidebar.currentIndex = i

        pathBar.append(currentPath)
        inx.watchPath(currentPath)
    }

    function append(item)
    {
        viewLoader.item.model.append(item)
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
            Maui.FM.copy(copyPaths, currentPath)
        else if(isCut)
            if(Maui.FM.cut(cutPaths, currentPath))
                clearSelection()

    }

    function remove(paths)
    {
        for(var i in paths)
            Maui.FM.remove(paths[i])
    }


    function switchView()
    {
        detailsView = !detailsView
        inx.saveSettings("BROWSER_VIEW", detailsView, "BROWSER")
        populate(currentPath)
    }

}
