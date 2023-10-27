import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3

import org.mauikit.controls 1.3 as Maui
import org.mauikit.filebrowsing 1.3 as FB

Maui.SettingsDialog
{
    id: control

    Maui.SectionGroup
    {
        title: i18n("Behaviour")
//        description: i18n("Configure the app plugins and behavior.")      

        Maui.SectionItem
        {
            label1.text:  i18n("Save Session")
            label2.text: i18n("Save and restore tabs.")

            Switch
            {
                checkable: true
                checked:  settings.restoreSession
                onToggled: settings.restoreSession = !settings.restoreSession
            }
        }

        Maui.SectionItem
        {
            label1.text:  i18n("Dynamic Preferences")
            label2.text: i18n("Save custom preferences per directory, otherwise use the default preferences for all the directories.")

            Switch
            {
                checkable: true
                checked:  settings.dirConf
                onToggled: settings.dirConf = !settings.dirConf
            }
        }

        Maui.SectionItem
        {
            enabled: Maui.Handy.isLinux
            label1.text:  i18n("Sync Terminal")
            label2.text: i18n("Sync the terminal to the browser current working directory.")

            Switch
            {
                checkable: true
                checked:  settings.syncTerminal
                onToggled: settings.restoreSession = !settings.syncTerminal
            }
        }
    }

    Maui.SectionGroup
    {
        title: i18n("Browsing & Navigation")

        Maui.SectionItem
        {
            label1.text: i18n("Thumbnails")
            label2.text: i18n("Show previews of images, videos and PDF files.")

            Switch
            {
                checkable: true
                checked:  settings.showThumbnails
                onToggled: settings.showThumbnails = ! settings.showThumbnails
            }
        }

        Maui.SectionItem
        {
            label1.text:  i18n("View Type")
            label2.text: i18n("Default view type.")

            Maui.ToolActions
            {
                autoExclusive: true
                expanded: true
                display: ToolButton.IconOnly

                Action
                {
                    text: i18n("List")
                    icon.name: "view-list-details"
                    checked: appSettings.viewType === FB.FMList.LIST_VIEW
                    checkable: true
                    onTriggered:
                    {
                        appSettings.viewType = FB.FMList.LIST_VIEW
                    }
                }

                Action
                {
                    text: i18n("Grid")
                    icon.name: "view-list-icons"
                    checked:  appSettings.viewType === FB.FMList.ICON_VIEW
                    checkable: true

                    onTriggered:
                    {
                        appSettings.viewType = FB.FMList.ICON_VIEW
                    }
                }
            }
        }

        Maui.SectionItem
        {
            label1.text:  i18n("Sort")
            label2.text: i18n("Default sorting value.")

            Maui.ToolButtonMenu
            {
                icon.name: "view-sort"

                onToggled: open()
                checkable: true

                Action
                {
                    text: i18n("Type")
                    checked: sortSettings.sortBy === FB.FMList.MIME
                    checkable: true

                    onTriggered:
                    {
                        sortSettings.sortBy = FB.FMList.MIME
                    }
                }

                Action
                {
                    text: i18n("Date")
                    checked: sortSettings.sortBy === FB.FMList.DATE
                    checkable: true
                    onTriggered:
                    {
                        sortSettings.sortBy = FB.FMList.DATE
                    }
                }

                Action
                {
                    text: i18n("Modified")
                    checked: sortSettings.sortBy === FB.FMList.MODIFIED
                    checkable: true
                    onTriggered:
                    {
                        sortSettings.sortBy = FB.FMList.MODIFIED
                    }
                }

                Action
                {
                    text: i18n("Size")
                    checked: sortSettings.sortBy === FB.FMList.SIZE
                    checkable: true
                    onTriggered:
                    {
                        sortSettings.sortBy = FB.FMList.SIZE
                    }
                }

                Action
                {
                    text: i18n("Name")
                    checked:  sortSettings.sortBy === FB.FMList.LABEL
                    checkable: true
                    onTriggered:
                    {
                        sortSettings.sortBy = FB.FMList.LABEL
                    }
                }

                MenuSeparator{}

                MenuItem
                {
                    text: i18n("Show Folders First")
                    checked:   sortSettings.foldersFirst
                    checkable: true

                    onTriggered:
                    {
                    sortSettings.foldersFirst =  !sortSettings.foldersFirst

                    }
                }

                MenuItem
                {
                    id: groupAction
                    text: i18n("Group")
                    checkable: true
                    checked: sortSettings.group
                    onTriggered:
                    {
                        sortSettings.group = !sortSettings.group
                    }
                }
            }
        }


    }

    Maui.SectionGroup
    {
        title: i18n("Interface")
//        description: i18n("Configure the app UI.")

        Maui.SectionItem
        {
            label1.text: i18n("Grid Items Size")
            label2.text: i18n("Size of the grid view.")

            Maui.ToolActions
            {
                expanded: true
                autoExclusive: true
                display: ToolButton.TextOnly

                //                currentIndex: appSettings.gridSize

                //                Action
                //                {
                //                    text: i18n("S")
                //                    onTriggered: appSettings.gridSize = 0
                //                }

                Action
                {
                    text: i18n("M")
                    checked: appSettings.gridSize === 1
                    onTriggered: appSettings.gridSize = 1
                }

                Action
                {
                    text: i18n("L")
                    checked: appSettings.gridSize === 2
                    onTriggered: appSettings.gridSize = 2
                }

                Action
                {
                    text: i18n("X")
                    checked: appSettings.gridSize === 3
                    onTriggered: appSettings.gridSize = 3
                }

                Action
                {
                    text: i18n("XL")
                    checked: appSettings.gridSize === 4
                    onTriggered: appSettings.gridSize = 4
                }
            }
        }

        Maui.SectionItem
        {
            label1.text: i18n("List Items Size")
            label2.text: i18n("Size of the list view.")

            Maui.ToolActions
            {
                expanded: true
                autoExclusive: true
                display: ToolButton.TextOnly

                Action
                {
                    text: i18n("S")
                    onTriggered: appSettings.listSize = 0
                    checked: appSettings.listSize === 0
                }

                Action
                {
                    text: i18n("M")
                    onTriggered: appSettings.listSize = 1
                    checked: appSettings.listSize === 1
                }

                Action
                {
                    text: i18n("L")
                    onTriggered: appSettings.listSize = 2
                    checked: appSettings.listSize === 2
                }

                Action
                {
                    text: i18n("X")
                    onTriggered: appSettings.listSize = 3
                    checked: appSettings.listSize === 3
                }
            }
        }

        Maui.SectionItem
        {
            label1.text: i18n("Overview")
            label2.text: i18n("Use overview mode as default on launch.")

            Switch
            {
                checked:  appSettings.overviewStart
                onToggled: appSettings.overviewStart = !appSettings.overviewStart
            }
        }

        Maui.SectionItem
        {
            visible: Maui.Handy.isAndroid
            label1.text: i18n("Dark Mode")
            label2.text: i18n("Switch between light and dark colorscheme.")

            Switch
            {
                checked: appSettings.darkMode
                onToggled:
                {
                    appSettings.darkMode = !appSettings.darkMode
                    setAndroidStatusBarColor()
                }
            }
        }
    }

    Maui.SectionItem
    {
        label1.text: i18n("Quick places")
        label2.text: i18n("Access to standard locations.")

        ToolButton
        {
            checkable: true
            icon.name: "go-next"
            onToggled: control.addPage(_sidebarPlacesComponent)
        }
    }

    Component
    {
        id: _sidebarPlacesComponent

        Maui.SettingsPage
        {
            title: i18n("Places")

            Maui.SectionGroup
            {
                title: i18n("Places")
//                description: i18n("Toggle sidebar sections.")

                Maui.SectionItem
                {
                    label1.text: i18n("Quick places")
                    label2.text: i18n("Access to standard locations.")

                    Switch
                    {
                        checkable: true
                        checked: appSettings.quickSidebarSection
                        onToggled: appSettings.quickSidebarSection = !appSettings.quickSidebarSection
                    }
                }

                Maui.SectionItem
                {
                    label1.text: i18n("Bookmarks")
                    label2.text: i18n("Access to standard locations.")

                    Switch
                    {
                        checkable: true
                        checked: appSettings.sidebarSections.indexOf(FB.FMList.BOOKMARKS_PATH) >= 0
                        onToggled:
                        {
                            toggleSection(FB.FMList.BOOKMARKS_PATH)
                        }
                    }
                }

                Maui.SectionItem
                {
                    label1.text: i18n("Remote")
                    label2.text: i18n("Access to network locations.")

                    Switch
                    {
                        checkable: true
                        checked: appSettings.sidebarSections.indexOf(FB.FMList.REMOTE_PATH)>= 0
                        onToggled:
                        {
                            toggleSection(FB.FMList.REMOTE_PATH)
                        }
                    }

                }

                Maui.SectionItem
                {
                    label1.text: i18n("Removable")
                    label2.text: i18n("Access to USB sticks and SD Cards.")

                    Switch
                    {
                        checkable: true
                        checked: appSettings.sidebarSections.indexOf(FB.FMList.REMOVABLE_PATH)>= 0
                        onToggled:
                        {
                            toggleSection(FB.FMList.REMOVABLE_PATH)
                        }
                    }
                }

                Maui.SectionItem
                {
                    label1.text: i18n("Devices")
                    label2.text: i18n("Access drives.")

                    Switch
                    {
                        checkable: true
                        checked: appSettings.sidebarSections.indexOf(FB.FMList.DRIVES_PATH)>= 0
                        onToggled:
                        {
                            toggleSection(FB.FMList.DRIVES_PATH)
                        }
                    }
                }
            }
        }
    }
}
