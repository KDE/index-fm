import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import "../../widgets_templates"
import "../../Index.js" as INX

import org.kde.kirigami 2.0 as Kirigami
import org.kde.mauikit 1.0 as Maui
import FMModel 1.0
import FMList 1.0
import FMH 1.0

Maui.Page
{
    id: control

    property string currentPath: inx.homePath()
    property var copyPaths : []
    property var cutPaths : []

    property bool isCopy : false
    property bool isCut : false

    property bool selectionMode : false
    property bool group: false
    property bool detailsView: false
    property bool terminalVisible : false

    property bool pathExists : inx.fileExists(currentPath)
    property alias terminal : terminalLoader.item
    property alias selectionBar : selectionBar

    property alias model : folderModel
    property alias list : modelList
    property alias grid : viewLoader.item

    property alias detailsDrawer: detailsDrawer
    property alias browserMenu: browserMenu

    property var pathType : ({
                                 directory : 0,
                                 tags : 1,
                                 applications : 2,
                                 none: 3
                             })

    property int currentPathType : views.none
    property int thumbnailsSize : iconSizes.large

    margins: 0

    BrowserMenu
    {
        id: browserMenu
    }

    Previewer
    {
        id: detailsDrawer
    }

    //    ListModel
    //    {
    //        id: folderModel
    //    }

    FMModel
    {
        id: folderModel
        list: modelList
    }

    FMList
    {
        id: modelList
        path: currentPath
        onSortByChanged: if(group) groupBy()
    }

    Component
    {
        id: listViewBrowser

        Maui.ListBrowser
        {
            showPreviewThumbnails: modelList.preview
            showEmblem: currentPathType !== pathType.applications
            rightEmblem: isMobile ? "document-share" : ""
            leftEmblem: "emblem-added"
            model: folderModel
            section.delegate: Maui.LabelDelegate
            {
                id: delegate
                label: section
                labelTxt.font.pointSize: fontSizes.big

                isSection: true
                boldLabel: true
                height: toolBarHeightAlt
            }
        }
    }

    Component
    {
        id: gridViewBrowser

        Maui.GridBrowser
        {
            itemSize : thumbnailsSize
            showEmblem: currentPathType !== pathType.applications
            showPreviewThumbnails: modelList.preview
            rightEmblem: isMobile ? "document-share" : ""
            leftEmblem: "emblem-added"
            model: folderModel
        }
    }

    Connections
    {
        target: viewLoader.item
        onItemClicked: openItem(index)

        onItemDoubleClicked:
        {
            var item = modelList.get(index)

            if(inx.isDir(item.path))
                browser.openFolder(item.path)
            else
                browser.openFile(item.path)
        }

        onItemRightClicked: itemMenu.show([modelList.get(index).path])

        onLeftEmblemClicked:  browser.addToSelection(modelList.get(index), true)

        onRightEmblemClicked: isAndroid ? Maui.Android.shareDialog([modelList.get(index).path]) :
                                          shareDialog.show([modelList.get(index).path])
        onAreaClicked:
        {
            if(!isMobile && mouse.button === Qt.RightButton)
                browserMenu.show()
            else
                return
        }

        onAreaRightClicked: browserMenu.show()
    }

    focus: true

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

    Keys.onSpacePressed: detailsDrawer.show(modelList.get(viewLoader.item.currentIndex).path)

    floatingBar: true
    footBarOverlap: true
    headBarExit: false
    headBarVisible: currentPathType !== pathType.applications
    altToolBars: isMobile

    headBar.rightContent: [

        Maui.ToolButton
        {
            iconName: "visibility"
            onClicked: modelList.hidden = !modelList.hidden
            tooltipText: qsTr("Hidden files...")
            iconColor: modelList.hidden ? highlightColor : textColor
        },

        Maui.ToolButton
        {
            iconName: "view-preview"
            onClicked: modelList.preview = !modelList.preview
            tooltipText: qsTr("Previews...")
            iconColor: modelList.preview ? highlightColor : textColor
        },

        Maui.ToolButton
        {
            iconName: "bookmark-new"
            onClicked: INX.bookmarkFolder()
            tooltipText: qsTr("Bookmark...")
        },
        Maui.ToolButton
        {
            iconName: "edit-select"
            tooltipText: qsTr("Selection...")
            onClicked: selectionMode = !selectionMode
            iconColor: selectionMode ? highlightColor: textColor
        },
        Maui.ToolButton
        {
            iconName: "overflow-menu"
            onClicked: browserMenu.show()
            tooltipText: qsTr("Menu...")
        }
    ]

    headBar.leftContent: [

        Maui.ToolButton
        {
            id: viewBtn
            //            iconColor: floatingBar ? altColorText : textColor
            iconName:  browser.detailsView ? "view-list-icons" : "view-list-details"
            onClicked: browser.switchView()
        },

        Maui.ToolButton
        {
            iconName: "folder-add"
            onClicked: INX.createFolder()
            tooltipText: qsTr("New folder...")
        },

        Maui.ToolButton
        {
            iconName: "view-sort"
            tooltipText: qsTr("Sort by...")
            onClicked: sortMenu.popup()

            Maui.Menu
            {
                id: sortMenu

                Maui.MenuItem
                {
                    text: qsTr("Type")
                    onTriggered: modelList.sortBy = KEY.MIME
                }

                Maui.MenuItem
                {
                    text: qsTr("Date")
                    onTriggered: modelList.sortBy = KEY.DATE
                }

                Maui.MenuItem
                {
                    text: qsTr("Modified")
                    onTriggered: modelList.sortBy = KEY.MODIFIED
                }

                Maui.MenuItem
                {
                    text: qsTr("Size")
                    onTriggered: modelList.sortBy = KEY.SIZE
                }

                Maui.MenuItem
                {
                    text: qsTr("Name")
                    onTriggered: modelList.sortBy = KEY.LABEL
                }

                MenuSeparator {}

                Maui.MenuItem
                {
                    id: groupAction
                    text: qsTr("Group")
                    checkable: true
                    onTriggered:
                    {
                        group = checked
                        group ? groupBy() : undefined
                    }
                }
            }
        }

    ]

    //    footBar.leftContent: Maui.ToolButton
    //    {
    //        id: viewBtn
    //        iconColor: floatingBar ? altColorText : textColor

    //        iconName:  browser.detailsView ? "view-list-icons" : "view-list-details"
    //        onClicked: browser.switchView()
    //    }

    footBar.colorScheme.backgroundColor: accentColor
    footBar.colorScheme.textColor: altColorText
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

    //    footBar.rightContent:  [
    //        //        Maui.ToolButton
    //        //        {
    //        //            iconName: "documentinfo"
    //        //            iconColor: browser.detailsDrawer.visible ? highlightColor : textColor
    //        //            onClicked: browser.detailsDrawer.visible ? browser.detailsDrawer.close() :
    //        //                                                       browser.detailsDrawer.show(browser.currentPath)
    //        //        },
    //        Maui.ToolButton
    //        {
    //            iconName: "overflow-menu"
    //            iconColor: floatingBar ? altColorText : textColor
    //            onClicked:  browser.browserMenu.show()
    //        }
    //    ]


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
                    onIconClicked: itemMenu.show(selectedPaths)
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
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignBottom
            Layout.minimumHeight: 100
            Layout.maximumHeight: parent.height *0.5
            anchors.bottom: parent.bottom
            anchors.top: handle.bottom
            source: !isMobile ? "Terminal.qml" : undefined
        }
    }

    function openItem(index)
    {
        var item = modelList.get(index)

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

    function launchApp(path)
    {
        inx.runApplication(path, "")
    }

    function openFile(path)
    {
        inx.openUrl(path)
    }

    function openFolder(path)
    {
        populate(path)

        if(!isMobile)
            terminal.session.sendText("cd " + currentPath + "\n")
    }

    function openAppsPath(path)
    {
        setPath(path, pathType.applications)

        var items = inx.getCustomPathContent(path)
        if(items.length > 0)
            for(var i in items)
                folderModel.append(items[i])

        for(i=0; i < placesSidebar.count; i++)
            if(currentPath === placesSidebar.model.get(i).path)
                placesSidebar.currentIndex = i
    }

    function setPath(path, type)
    {
        currentPathType = type
        currentPath = path
        pathBar.append(currentPath)
    }

    function populate(path)
    {
        if(path.indexOf("#apps") === 0)
        {
            browser.openAppsPath(path)
            return;
        }

        setPath(path, pathType.directory)

        /* Get directory configs */
        var iconsize = inx.dirConf(path+"/.directory")["iconsize"] ||  iconSizes.large
        thumbnailsSize = parseInt(iconsize)

        detailsView = inx.dirConf(path+"/.directory")["detailview"] === "true" ? true : false

        if(!detailsView)
            grid.adaptGrid()

        if(!isAndroid)
            terminalVisible = inx.dirConf(path+"/.directory")["showterminal"] === "true" ? true : false

        for(var i=0; i < placesSidebar.count; i++)
            if(currentPath === placesSidebar.model.get(i).path)
                placesSidebar.currentIndex = i
    }

    //    function append(item)
    //    {
    //        folderModel.append(item)
    //    }

    function goBack()
    {
        populate(modelList.previousPath)
    }

    function goNext()
    {
        openFolder(modelList.posteriorPath)
    }

    function goUp()
    {
        openFolder(modelList.parentPath)
    }

    function refresh()
    {
        var pos = browser.grid.contentY
        populate(currentPath)

        browser.grid.contentY = pos
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
    }

    function cut(paths)
    {
        cutPaths = paths
        isCut = true
        isCopy = false
    }

    function paste()
    {
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


    function switchView(state)
    {
        detailsView = state ? state : !detailsView
        inx.setDirConf(currentPath+"/.directory", "MAUIFM", "DetailView", detailsView)
    }

    function bookmarkFolder(paths)
    {
        if(paths.length > 0)
        {
            for(var i in paths)
            {
                if(inx.isDefaultPath(paths[i])) continue
                inx.bookmark(paths[i])
            }
            placesSidebar.populate()
        }
    }

    function populateTags(myTag)
    {
        inx.getTagContent(myTag)
        setPath(myTag, pathType.tags)
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
    }

    onThumbnailsSizeChanged:
    {
        inx.setDirConf(currentPath+"/.directory", "MAUIFM", "IconSize", thumbnailsSize)
        grid.adaptGrid()
    }

    function groupBy()
    {
        var prop = ""
        var criteria = ViewSection.FullString

        switch(modelList.sortBy)
        {
        case KEY.LABEL: prop = "label"
            criteria = ViewSection.FirstCharacter
            break;
        case KEY.MIME: prop = "mime"
            break;
        case KEY.SIZE: prop = "size"
            break;
        case KEY.DATE: prop = "date"
            break;
        case KEY.MODIFIED: prop = "modified"
            break;
        }

        detailsView = true

        if(!prop)
        {
            grid.section.property = ""
            return
        }
        grid.section.property = prop
        grid.section.criteria = criteria

    }
}
