import QtQuick 2.9
import QtQuick.Controls 2.3
import org.kde.mauikit 1.0 as Maui

Menu
{
    id: control
    x: parent.width / 2 - width / 2
    y: parent.height / 2 - height / 2
    modal: true
    focus: true
    parent: ApplicationWindow.overlay

    margins: 1
    padding: 2

    property var paths : []
    property bool isDir : false

    signal bookmarkClicked(var paths)
    signal removeClicked(var paths)
    signal shareClicked(var paths)
    signal copyClicked(var paths)
    signal cutClicked(var paths)
    signal renameClicked(var paths)
    signal tagsClicked(var paths)
    signal saveToClicked(var paths)

    MenuItem
    {
        text: qsTr("Bookmark")
        enabled: isDir
        onTriggered:
        {
            bookmarkClicked(paths)
            close()
        }
    }

    MenuItem
    {
        text: qsTr("Tags...")
        onTriggered:
        {
            tagsClicked(paths)
            close()
        }
    }


    MenuItem
    {
        text: qsTr("Share...")
        onTriggered:
        {
            shareClicked(paths)
            close()
        }
    }

    MenuItem
    {
        text: qsTr("Copy...")
        onTriggered:
        {
            copyClicked(paths)
            close()
        }
    }

    MenuItem
    {
        text: qsTr("Cut...")
        onTriggered:
        {
            cutClicked(paths)
            close()
        }
    }

    MenuItem
    {
        text: qsTr("Rename...")
        onTriggered:
        {
            renameClicked(paths)
            close()
        }
    }

    MenuItem
    {
        text: qsTr("Save to...")
        onTriggered:
        {
            saveToClicked(paths)
            close()
        }
    }

    MenuItem
    {
        text: qsTr("Remove...")
        onTriggered:
        {
            removeClicked(paths)
            close()
        }
    }

    MenuItem
    {
        text: qsTr("Info...")
        onTriggered:
        {
            browser.detailsDrawer.show(paths)
            close()
        }
    }

    MenuItem
    {
        text: qsTr("Select")
        onTriggered: browser.selectionBar.append(browser.model.get(browser.grid.currentIndex))
    }

    MenuSeparator {}

    MenuItem
    {
        width: parent.width
        height: iconSize

        ColorsBar
        {
            height: parent.height
            width: parent.width
            size:  iconSize
            onColorPicked:
            {
                for(var i in control.paths)
                    Maui.FM.setDirConf(control.paths[i]+"/.directory", "Desktop Entry", "Icon", color)

                browser.refresh()

            }
        }
    }

    function show(urls)
    {
        if(urls.length > 0 )
        {
            paths = urls
            isDir = inx.isDir(paths[0])
            if(isMobile) open()
            else popup()
        }

    }

}
