import QtQuick 2.9
import QtQuick.Controls 2.3
import org.kde.mauikit 1.0 as Maui

Maui.Menu
{
    id: control

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

    implicitWidth: 200 * unit

    Maui.MenuItem
    {
        text: qsTr("Bookmark")
        enabled: isDir
        onTriggered:
        {
            bookmarkClicked(paths)
            close()
        }
    }

    Maui.MenuItem
    {
        text: qsTr("Tags...")
        onTriggered:
        {
            tagsClicked(paths)
            close()
        }
    }

    Maui.MenuItem
    {
        text: qsTr("Share...")
        onTriggered:
        {
            shareClicked(paths)
            close()
        }
    }

    Maui.MenuItem
    {
        text: qsTr("Copy...")
        onTriggered:
        {
            copyClicked(paths)
            close()
        }
    }

    Maui.MenuItem
    {
        text: qsTr("Cut...")
        onTriggered:
        {
            cutClicked(paths)
            close()
        }
    }

    Maui.MenuItem
    {
        text: qsTr("Rename...")
        onTriggered:
        {
            renameClicked(paths)
            close()
        }
    }

    Maui.MenuItem
    {
        text: qsTr("Save to...")
        onTriggered:
        {
            saveToClicked(paths)
            close()
        }
    }

    Maui.MenuItem
    {
        text: qsTr("Remove...")
        onTriggered:
        {
            removeClicked(paths)
            close()
        }
    }

    Maui.MenuItem
    {
        text: qsTr("Info...")
        onTriggered:
        {
            browser.detailsDrawer.show(paths)
            close()
        }
    }

    Maui.MenuItem
    {
        text: qsTr("Select")
        onTriggered: browser.selectionBar.append(browser.model.get(browser.grid.currentIndex))
    }


    Maui.MenuItem
    {
        width: parent.width
        height: iconSize + space.medium
        padding: space.medium

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
