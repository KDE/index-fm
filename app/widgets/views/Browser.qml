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
    property bool previews: inx.loadSettings("SHOW_PREVIEWS", "BROWSER", false) === "false" ? false: true

    property bool pathExists : inx.fileExists(currentPath)
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
    property int thumbnailsSize : iconSizes.large
    margins: 0

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
        Maui.ListBrowser
        {}
    }

    Component
    {
        id: gridViewBrowser

        Maui.GridBrowser
        {
            itemSize : thumbnailsSize
        }
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

        onItemRightClicked: itemMenu.show(viewLoader.item.model.get(index).path)

        onEmblemClicked:  browser.addToSelection(item, true)

        onAreaClicked:
        {
            if(!isMobile && mouse.button === Qt.RightButton)
                browserMenu.show()
            else
                clearSelection()
        }

        onAreaRightClicked: browserMenu.show()
    }

    focus: true
    headBarVisible: false

    Maui.Holder
    {
        id: holder
        visible: viewLoader.item.count === 0 || !inx.fileExists(currentPath)

        emoji: pathExists ? "qrc:/assets/MoonSki.png" : "qrc:/assets/ElectricPlug.png"
        isMask: false
        title : pathExists ?  "Folder is empty!" : "Folder doesn't exists!"
        body: pathExists ? "You can add new files to it" : "Create Folder?"
        emojiSize: iconSizes.huge


    }

    Keys.onSpacePressed: detailsDrawer.show(viewLoader.item.model.get(viewLoader.item.currentIndex).path)

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
            Layout.margins: detailsView ? unit : contentMargins * 2

            ColumnLayout
            {
                anchors.fill: parent

                Loader
                {
                    id: viewLoader
                    sourceComponent: detailsView ? listViewBrowser : gridViewBrowser

                    Layout.margins: detailsView ? unit : contentMargins * 2

                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }

                Maui.SelectionBar
                {
                    id: selectionBar
                    y: -20
                    visible: selectionList.count > 0
                    Layout.fillWidth: true
                    Layout.leftMargin: contentMargins*2
                    Layout.rightMargin: contentMargins*2
                    Layout.bottomMargin: contentMargins*2

                    onIconClicked: itemMenu.showMultiple()
                    onExitClicked: clearSelection()
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

    function bookmarkFolder(path)
    {
        if(inx.isDefaultPath(path)) return

        inx.bookmark(path)
        placesSidebar.populate()
    }

    function populateTags(myTag)
    {
        console.log("GETTIN TAGS CONTENT")
        currentPath = myTag
        clear()
        var data = inx.getTagContent(myTag)
        pathBar.append(currentPath)
    }

    function zoomIn()
    {
        switch(thumbnailsSize)
        {
        case iconSizes.tiny: thumbnailsSize = iconSizes.small
            break
        case iconSizes.small: thumbnailsSize = iconSizes.medium
            break
        case iconSizes.medium: thumbnailsSize = iconSizes.big
            break
        case iconSizes.big: thumbnailsSize = iconSizes.large
            break
        case iconSizes.large: thumbnailsSize = iconSizes.huge
            break
        case iconSizes.huge: thumbnailsSize = iconSizes.enormous
            break
        case iconSizes.enormous: thumbnailsSize = iconSizes.enormous
            break

        }
    }

    function zoomOut()
    {
        switch(thumbnailsSize)
        {
        case iconSizes.tiny: thumbnailsSize = iconSizes.tiny
            break
        case iconSizes.small: thumbnailsSize = iconSizes.tiny
            break
        case iconSizes.medium: thumbnailsSize = iconSizes.small
            break
        case iconSizes.big: thumbnailsSize = iconSizes.medium
            break
        case iconSizes.large: thumbnailsSize = iconSizes.big
            break
        case iconSizes.huge: thumbnailsSize = iconSizes.large
            break
        case iconSizes.enormous: thumbnailsSize = iconSizes.huge
            break
        }
    }

}
