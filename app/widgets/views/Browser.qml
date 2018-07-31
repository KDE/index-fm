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
    property var pathType : ({
                                 directory : 0,
                                 tags : 1,
                                 applications : 2,
                                 none: 3

                             })

    property int currentPathType : views.none
    property int thumbnailsSize : inx.loadSettings("THUMBNAILSIZE", "BROWSER", iconSizes.large)

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
            showEmblem: currentPathType !== pathType.applications
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
        visible: false/*|| !inx.fileExists(currentPath)*/
        z: -1
        emoji: pathExists ? "qrc:/assets/MoonSki.png" : "qrc:/assets/ElectricPlug.png"
        isMask: false
        title : pathExists ?  "Folder is empty!" : "Folder doesn't exists!"
        body: pathExists ? "You can add new files to it" : "Create Folder?"
        emojiSize: iconSizes.huge
    }

    Keys.onSpacePressed: detailsDrawer.show(viewLoader.item.model.get(viewLoader.item.currentIndex).path)

    floatingBar: true
    footBarOverlap: true

    footBar.leftContent: Maui.ToolButton
    {
        id: viewBtn
        iconColor: floatingBar ? altColorText : textColor

        iconName:  browser.detailsView ? "view-list-icons" : "view-list-details"
        onClicked: browser.switchView()
    }

    footBar.middleContent: Row
    {

        spacing: space.medium
        Maui.ToolButton
        {
            iconName: "go-previous"
            iconColor: floatingBar ? altColorText : textColor
            onClicked: browser.goBack()
        }

        Maui.ToolButton
        {
            iconName: "go-up"
            iconColor: floatingBar ? altColorText : textColor
            onClicked: browser.goUp()
        }

        Maui.ToolButton
        {
            iconName: "go-next"
            iconColor: floatingBar ? altColorText : textColor
            onClicked: browser.goNext()
        }
    }

    footBar.rightContent:  [
        //        Maui.ToolButton
        //        {
        //            iconName: "documentinfo"
        //            iconColor: browser.detailsDrawer.visible ? highlightColor : textColor
        //            onClicked: browser.detailsDrawer.visible ? browser.detailsDrawer.close() :
        //                                                       browser.detailsDrawer.show(browser.currentPath)
        //        },
        Maui.ToolButton
        {
            iconName: "overflow-menu"
            iconColor: floatingBar ? altColorText : textColor
            onClicked:  browser.browserMenu.show()
        }
    ]


    ColumnLayout
    {
        spacing: 0
        anchors.fill: parent
        visible: !holder.visible
        z: holder.z + 1

        Item
        {
            id: browserContainer
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: detailsView ? unit : contentMargins * 2
            z: holder.z + 1

            ColumnLayout
            {
                anchors.fill: parent

                Loader
                {
                    id: viewLoader
                    z: holder.z + 1
                    sourceComponent: detailsView ? listViewBrowser : gridViewBrowser

                    Layout.margins: detailsView ? unit : contentMargins * 2

                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }

                Maui.SelectionBar
                {
                    id: selectionBar
                    Layout.fillWidth: true
                    Layout.leftMargin: contentMargins*2
                    Layout.rightMargin: contentMargins*2
                    Layout.bottomMargin: contentMargins*2
                    z: holder.z +1
                    onIconClicked: itemMenu.showMultiple(selectedPaths)
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

    function openAppsPath(path)
    {
        setPath(path, pathType.applications)

        var items = inx.getCustomPathContent(path)
        if(items.length > 0)
            for(var i in items)
                viewLoader.item.model.append(items[i])

        for(i=0; i < placesSidebar.count; i++)
            if(currentPath === placesSidebar.model.get(i).path)
                placesSidebar.currentIndex = i
    }

    function populate(path)
    {
        clear()

        if(path.indexOf("#apps") === 0)
        {
            browser.openAppsPath(path)
            return;
        }

        setPath(path, pathType.directory)

        /* should it really return the paths or just use the signal? */
        var items = inx.getPathContent(path)

        for(var i=0; i < placesSidebar.count; i++)
            if(currentPath === placesSidebar.model.get(i).path)
                placesSidebar.currentIndex = i

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
        selectionBar.append(item)
    }

    function clearSelection()
    {
        clean()
        browser.selectionMode = false
    }

    function clean()
    {
        copyPaths = []
        cutPaths = []
        browserMenu.pasteFiles = 0
        selectionBar.clear()
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
        clear()
        inx.getTagContent(myTag)
        setPath(myTag, pathType.tags)
    }

    function setPath(path, type)
    {
        currentPathType = type
        currentPath = path
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
        default:
            thumbnailsSize = iconSizes.large

        }

        inx.saveSettings("THUMBNAILSIZE", thumbnailsSize, "BROWSER")
        grid.adaptGrid()
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
        default:
            thumbnailsSize = iconSizes.large

        }
        inx.saveSettings("THUMBNAILSIZE", thumbnailsSize, "BROWSER")
        grid.adaptGrid()

    }

}
