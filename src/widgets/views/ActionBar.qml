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
            icon.name: currentTab.orientation === Qt.Horizontal ? "view-split-left-right" : "view-split-top-bottom"
            checked: currentTab.count === 2
            checkable: true
            onClicked: toogleSplitView()
        },

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

        ToolButton
        {
            icon.name: "list-add"
            //                    text: i18n("New")
            onClicked: currentBrowser.newItem()
        }
    ]
}
