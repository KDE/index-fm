
import QtQuick
import QtQuick.Controls
import QtQml

import org.mauikit.controls as Maui

import org.mauikit.filebrowsing as FB

import ".."

Maui.ContextualMenu
{
    id: control

    /**
      *
      */
    property var item : ({})

    /**
      *
      */
    property int index : -1

    /**
      *
      */
    property bool isDir : false

    /**
      *
      */
    property bool isExec : false

    /**
      *
      */

    property bool isFav: false

    title:  control.item ? control.item.label : ""
    Maui.Controls.subtitle: control.item.mime ? (control.item.mime === "inode/directory" ? (control.item.count ? control.item.count + i18n(" items") : "") : Maui.Handy.formatSize(control.item.size)) : ""
    icon.source: control.item ? control.item.thumbnail : ""
    icon.name: control.item ? control.item.icon : ""
    Maui.Controls.badgeText: _browser.filterSelection(currentPath, control.item.path).length > 1 ?  _browser.filterSelection(currentPath, control.item.path).length : ""

    Maui.MenuItemActionRow
    {

        Action
        {
            enabled: !control.isExec
            text: i18n("Copy")
            icon.name: "edit-copy"
            onTriggered:
            {
                _browser.copy(_browser.filterSelection(currentPath, control.item.path))
            }
        }

        Action
        {
            enabled: !control.isExec
            text: i18n("Cut")
            icon.name: "edit-cut"
            onTriggered:
            {
                _browser.cut(_browser.filterSelection(currentPath, control.item.path))
            }
        }

        Action
        {
            enabled: !control.isExec
            text: i18n("Rename")
            icon.name: "edit-rename"
            onTriggered:
            {
                _browser.renameItem()
            }
        }

        Action
        {
            text: i18n("Remove")
            Maui.Theme.textColor: Maui.Theme.negativeTextColor
            icon.name: "edit-delete"
            onTriggered:
            {
                _browser.remove(_browser.filterSelection(currentPath, control.item.path))

            }
        }
    }

    MenuSeparator{}

    MenuItem
    {
        enabled: !control.isExec
        text: i18n("Select")
        icon.name: "edit-select"
        action: Action
        {
            shortcut: "Ctrl+Shift+→"
        }
        onTriggered:
        {
            _browser.addToSelection(control.item)
            if(Maui.Handy.isTouch)
                _browser.selectionMode = true
        }
    }

    MenuItem
    {
        id: openWithMenuItem
        enabled: !control.isExec
        text: i18n("Open with")
        icon.name: "document-open"

        onTriggered:
        {
            openWith(_browser.filterSelection(currentPath, control.item.path))
        }
    }

    MenuItem
    {
        enabled: !control.isExec
        text: i18n("Preview and Info")
        icon.name: "view-preview"
        action: Action
        {
            shortcut: "Spacebar"
        }
        onTriggered:
        {
            openPreview(control.item.path)
        }
    }

    MenuSeparator {}

    MenuItem
    {
        enabled: !control.isExec

        visible: appSettings.lastUsedTag.length > 0
        height: visible ? implicitHeight : -control.spacing
        text: i18n("Add to '%1'", appSettings.lastUsedTag)
        icon.name: "tag"
        onTriggered:
        {
            FB.Tagging.tagUrl(control.item.path, appSettings.lastUsedTag)
        }
    }

    Action
    {
        enabled: !control.isExec
        text: i18n("Add Tag")
        icon.name: "tag"
        onTriggered: tagFiles(_browser.filterSelection(currentPath, control.item.path))
    }

     MenuSeparator {}

    Maui.MenuItemActionRow
    {
        Action
        {
            text: control.isFav ? i18n("UnFav") : i18n("Fav")
            checked: control.isFav
            checkable: true
            icon.name: "love"
            onTriggered:
            {
                if(FB.Tagging.toggleFav(item.path))
                {
                    control.isFav = !control.isFav
                }
            }
        }

        Action
        {
            enabled: !control.isExec
            text: i18n("Share")
            icon.name: "document-share"
            onTriggered:
            {
                shareFiles(_browser.filterSelection(currentPath, control.item.path))
            }
        }

        Action
        {
            enabled: !control.isExec && control.isDir
            text: i18n("Bookmark")
            icon.name: "bookmark-new"
            onTriggered:
            {
                _browser.bookmarkFolder([control.item.path])
            }
        }
    }

    MenuSeparator
    {
        visible: control.isDir
        height: visible ? implicitHeight : -control.spacing
    }

    MenuItem
    {
        enabled: control.isDir
        visible: enabled
        height: visible ? implicitHeight : -control.spacing
        text: i18n("Open in New Tab")
        icon.name: "tab-new"
        onTriggered: root.openTab(control.item.path)
    }

    MenuItem
    {
        enabled: control.isDir && Maui.Handy.isLinux
        visible: enabled
        height: visible ? implicitHeight : -control.spacing
        text: i18n("Open in New Window")
        icon.name: "window-new"
        onTriggered: inx.openNewWindow(control.item.path)
    }

    MenuItem
    {
        enabled: control.isDir && root.currentTab.count === 1
        visible: enabled
        height: visible ? implicitHeight : -control.spacing
        text: i18n("Open in Split View")
        icon.name: "view-split-left-right"
        onTriggered: root.currentTab.split(control.item.path, Qt.Horizontal)
    }

    MenuSeparator {}

    MenuItem
    {
        enabled: FB.FM.checkFileType(FB.FMList.COMPRESSED, control.item.mime)
        visible: enabled
        height: visible ? implicitHeight : -control.spacing
        text: i18n("Extract")
        icon.name: "archive-extract"
        onTriggered:
        {
            let props = ({ 'fileUrl': control.item.path,
                             'dirName' : control.item.label.replace(control.item.suffix, ""),
                             'destination': currentBrowser.currentPath})
            var dialog = _extractDialogComponent.createObject(root, props)
            dialog.open()
        }
    }

    MenuItem
    {
        text: i18n("Compress")
        icon.name: "archive-insert"
        onTriggered:
        {
           var dialog = _compressDialogComponent.createObject(root, ({'urls': _browser.filterSelection(currentPath, control.item.path)}))
            dialog.open()
        }
    }

    MenuSeparator
    {
        visible: control.isDir
        height: visible ? implicitHeight : -control.spacing
    }

    ColorsBar
    {
        id: colorBar
        padding: control.padding
        width: parent.width
        enabled: control.isDir
        visible: enabled
        height: visible ? implicitHeight : -control.spacing
        Binding on folderColor {
            value: control.item.icon
            restoreMode: Binding.RestoreBindingOrValue
        }

        onFolderColorPicked:
        {
            _browser.currentFMList.setDirIcon(control.index, color)
            control.close()
        }
    }

    onClosed:
    {
        control.index = -1
    }

    function showFor(index)
    {
        control.item = _browser.currentFMList.get(index)
        console.log("CURRENT ITEM" , item.name)
        if(item.path.startsWith("tags://") || item.path.startsWith("applications://"))
            return

        if(item)
        {
            console.log("GOT ITEM FILE", index, item.path)
            control.index = index
            control.isDir = item.isdir == true || item.isdir == "true"
            control.isExec = item.executable == true || item.executable == "true"
            control.isFav = FB.Tagging.isFav(item.path)
            control.show()
        }
    }
}
