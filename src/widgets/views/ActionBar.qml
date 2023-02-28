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
                checked: currentBrowser.viewType === FB.FMList.LIST_VIEW
                checkable: true
                onTriggered:
                {
                    if(currentBrowser)
                    {
                        currentBrowser.viewType = FB.FMList.LIST_VIEW
                    }
                }
            }

            Action
            {
                text: i18n("Grid")
                icon.name: "view-list-icons"
                checked:  currentBrowser.viewType === FB.FMList.ICON_VIEW
                checkable: true

                onTriggered:
                {
                    if(currentBrowser)
                    {
                        currentBrowser.viewType = FB.FMList.ICON_VIEW
                    }
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

            MenuItem
            {
                text: i18n("Type")
                checked: currentBrowser.sortBy === FB.FMList.MIME
                checkable: true
                autoExclusive: true
                onTriggered:
                {
                    currentBrowser.sortBy = FB.FMList.MIME
                }
            }

            MenuItem
            {
                text: i18n("Date")
                checked: currentBrowser.sortBy === FB.FMList.DATE
                checkable: true
                autoExclusive: true

                onTriggered:
                {
                    currentBrowser.sortBy = FB.FMList.DATE
                }
            }

            MenuItem
            {
                text: i18n("Modified")
                checked: currentBrowser.sortBy === FB.FMList.MODIFIED
                checkable: true
                autoExclusive: true

                onTriggered:
                {
                    currentBrowser.sortBy = FB.FMList.MODIFIED
                }
            }

            MenuItem
            {
                text: i18n("Size")
                checked: currentBrowser.sortBy === FB.FMList.SIZE
                checkable: true
                autoExclusive: true

                onTriggered:
                {
                    currentBrowser.sortBy = FB.FMList.SIZE
                }
            }

            MenuItem
            {
                text: i18n("Name")
                checked:  currentBrowser.sortBy === FB.FMList.LABEL
                checkable: true
                autoExclusive: true

                onTriggered:
                {
                    currentBrowser.sortBy = FB.FMList.LABEL
                }
            }
        }
    ]
}
