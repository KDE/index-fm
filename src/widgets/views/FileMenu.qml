import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQml 2.14

import org.mauikit.controls 1.3 as Maui
import org.kde.kirigami 2.14 as Kirigami

import org.mauikit.filebrowsing 1.3 as FB

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


    MenuItem
    {
        enabled: !control.isExec
        text: i18n("Select")
        icon.name: "edit-select"
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

    MenuSeparator {}

    MenuItem
    {
        text: control.isFav ? i18n("Remove from Favorites") : i18n("Add to Favorites")
        icon.name: "love"
        onTriggered:
        {
            if(FB.Tagging.toggleFav(item.path))
                control.isFav = !control.isFav
        }
    }

    MenuItem
    {
        enabled: !control.isExec && control.isDir
        text: i18n("Add to Bookmarks")
        icon.name: "bookmark-new"
        onTriggered:
        {
            _browser.bookmarkFolder([control.item.path])
        }
    }

    MenuSeparator{}

    MenuItem
    {
        enabled: !control.isExec
        text: i18n("Copy")
        icon.name: "edit-copy"
        onTriggered:
        {
            _browser.copy(_browser.filterSelection(currentPath, control.item.path))
        }
    }

    MenuItem
    {
        enabled: !control.isExec
        text: i18n("Cut")
        icon.name: "edit-cut"
        onTriggered:
        {
            _browser.cut(_browser.filterSelection(currentPath, control.item.path))
        }
    }

    MenuItem
    {
        enabled: !control.isExec
        text: i18n("Rename")
        icon.name: "edit-rename"
        onTriggered:
        {
            _browser.renameItem()
        }
    }

    MenuItem
    {
        text: i18n("Remove")
        Kirigami.Theme.textColor: Kirigami.Theme.negativeTextColor
        icon.name: "edit-delete"
        onTriggered:
        {
            _browser.remove(_browser.filterSelection(currentPath, control.item.path))

        }
    }

    MenuSeparator {}

    MenuItem
    {
        enabled: !control.isExec
        text: i18n("Preview")
        icon.name: "view-preview"
        onTriggered:
        {
            openPreview(_browser.currentFMModel, _browser.currentIndex)
        }
    }

    MenuItem
    {
        enabled: !control.isExec && tagsDialog
        text: i18n("Tags")
        icon.name: "tag"
        onTriggered:
        {
            dialogLoader.sourceComponent = _tagsDialogComponent
            dialog.composerList.urls = _browser.filterSelection(currentPath, control.item.path)
            dialog.open()
        }
    }

    MenuItem
    {
        enabled: !control.isExec
        text: i18n("Share")
        icon.name: "document-share"
        onTriggered:
        {
            shareFiles(_browser.filterSelection(currentPath, control.item.path))
        }
    }

    MenuSeparator {}

    MenuItem
    {
        enabled: control.isDir
        text: i18n("Open in new tab")
        icon.name: "tab-new"
        onTriggered: root.openTab(control.item.path)
    }

    MenuItem
    {
        enabled: control.isDir && root.currentTab.count === 1
        text: i18n("Open in split view")
        icon.name: "view-split-left-right"
        onTriggered: root.currentTab.split(control.item.path, Qt.Horizontal)
    }

    MenuItem
    {
        enabled: control.isDir && Maui.Handy.isLinux && !Kirigami.Settings.isMobile
        text: i18n("Open terminal here")
        icon.name: "utilities-terminal"
        onTriggered:
        {
            inx.openTerminal(control.item.path)
        }
    }

    MenuSeparator {}

    MenuItem
    {
        enabled: FB.FM.checkFileType(FB.FMList.COMPRESSED, control.item.mime)
        text: i18n("Extract")
        icon.name: "archive-extract"
        onTriggered:
        {
            _compressedFile.url = control.item.path
            dialogLoader.sourceComponent= _extractDialogComponent
            dialog.open()
        }
    }

    MenuItem
    {
        text: i18n("Compress")
        icon.name: "archive-insert"
        onTriggered:
        {
            dialogLoader.sourceComponent= _compressDialogComponent
            dialog.urls = _browser.filterSelection(currentPath, control.item.path)
            dialog.open()
        }
    }

    MenuSeparator{ visible: colorBar.visible }

    MenuItem
    {
        height: visible ? Maui.Style.iconSizes.medium + Maui.Style.space.big : 0
        enabled: control.isDir

        ColorsBar
        {
            id: colorBar
            anchors.centerIn: parent

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
    }

    onClosed:
    {
        control.index = -1
    }

    function showFor(index)
    {
        control.item = _browser.currentFMList.get(index)
''
        console.log("CURRENT ITEM" , item.name)
        if(item.path.startsWith("tags://") || item.path.startsWith("applications://") )
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
