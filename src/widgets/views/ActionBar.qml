import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import org.mauikit.controls 1.3 as Maui

import org.mauikit.filebrowsing 1.3 as FB

Maui.ToolBar
{
    id: control
    position: ToolBar.Footer
    leftContent:  [

        Maui.ToolActions
        {
            autoExclusive: false
            checkable: false
            display: ToolButton.IconOnly

            Action
            {
                icon.name: "go-previous"
                onTriggered : currentBrowser.goBack()
            }

            Action
            {
                icon.name: "go-next"
                onTriggered : currentBrowser.goForward()

            }
        },

        Maui.ToolActions
        {
            autoExclusive: true
            expanded: root.isWide
            cyclic: true
            display: ToolButton.IconOnly

            Action
            {
                text: i18n("List")
                icon.name: "view-list-details"
                checked: currentBrowser.settings.viewType === FB.FMList.LIST_VIEW
                checkable: true
                onTriggered:
                {
                    if(currentBrowser)
                    {
                        currentBrowser.settings.viewType = FB.FMList.LIST_VIEW
                    }

                    settings.viewType = FB.FMList.LIST_VIEW
                }
            }

            Action
            {
                text: i18n("Grid")
                icon.name: "view-list-icons"
                checked:  currentBrowser.settings.viewType === FB.FMList.ICON_VIEW
                checkable: true

                onTriggered:
                {
                    if(currentBrowser)
                    {
                        currentBrowser.settings.viewType = FB.FMList.ICON_VIEW
                    }

                    settings.viewType = FB.FMList.ICON_VIEW
                }
            }
        }

    ]

    rightContent: [


        ToolButton
        {
            visible: !Maui.Handy.isAndroid
            enabled: currentTab && currentTab.currentItem ? currentTab.currentItem.supportsTerminal : false
            icon.name: "dialog-scripts"
            checked : currentTab && currentBrowser ? currentTab.currentItem.terminalVisible : false
            checkable: true

            onClicked: currentTab.currentItem.toogleTerminal()
        },


        ToolButton
        {
            icon.name: "edit-find"
            checked: currentBrowser.headBar.visible
            checkable: true
            onClicked: currentBrowser.toggleSearchBar()
        },

        Maui.ToolButtonMenu
        {
            icon.name: "view-sort"

                Action
                {
                    text: i18n("Type")
                    checked: currentBrowser.settings.sortBy === FB.FMList.MIME
                    checkable: true

                    onTriggered:
                    {
                        currentBrowser.settings.sortBy = FB.FMList.MIME
                        sortSettings.sortBy = FB.FMList.MIME
                    }
                }

                Action
                {
                    text: i18n("Date")
                    checked: currentBrowser.settings.sortBy === FB.FMList.DATE
                    checkable: true
                    onTriggered:
                    {
                        currentBrowser.settings.sortBy = FB.FMList.DATE
                        sortSettings.sortBy = FB.FMList.DATE
                    }
                }

                Action
                {
                    text: i18n("Modified")
                    checked: currentBrowser.settings.sortBy === FB.FMList.MODIFIED
                    checkable: true
                    onTriggered:
                    {
                        currentBrowser.settings.sortBy = FB.FMList.MODIFIED
                        sortSettings.sortBy = FB.FMList.MODIFIED
                    }
                }

                Action
                {
                    text: i18n("Size")
                    checked: currentBrowser.settings.sortBy === FB.FMList.SIZE
                    checkable: true
                    onTriggered:
                    {
                        currentBrowser.settings.sortBy = FB.FMList.SIZE
                        sortSettings.sortBy = FB.FMList.SIZE
                    }
                }

                Action
                {
                    text: i18n("Name")
                    checked:  currentBrowser.settings.sortBy === FB.FMList.LABEL
                    checkable: true
                    onTriggered:
                    {
                        currentBrowser.settings.sortBy = FB.FMList.LABEL
                        sortSettings.sortBy = FB.FMList.LABEL
                    }
                }

                MenuSeparator{}

                MenuItem
                {
                    text: i18n("Show Folders First")
                    checked: currentBrowser.settings.foldersFirst
                    checkable: true

                    onTriggered:
                    {
                        currentBrowser.settings.foldersFirst = !currentBrowser.settings.foldersFirst
                        sortSettings.foldersFirst =  !sortSettings.foldersFirst
                    }
                }

                MenuItem
                {
                    id: groupAction
                    text: i18n("Group")
                    checkable: true
                    checked: currentBrowser.settings.group
                    onTriggered:
                    {
                        currentBrowser.settings.group = !currentBrowser.settings.group
                        sortSettings.group = !sortSettings.group
                    }
                }

        }
    ]
}
