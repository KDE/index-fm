import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQml 2.14
import QtQuick.Layouts 1.3

import org.kde.kirigami 2.7 as Kirigami
import org.kde.mauikit 1.2 as Maui

Maui.SettingsDialog
{
    Maui.SettingsSection
    {
//        alt: true
        title: i18n("Navigation")
        description: i18n("Configure the app plugins and behavior.")

        Maui.SettingTemplate
        {
            label1.text: i18n("Thumbnails")
            label2.text: i18n("Show previews of images, videos and PDF files")

            Switch
            {
                Layout.fillHeight: true
                checkable: true
                checked:  settings.showThumbnails
                onToggled: settings.showThumbnails = ! settings.showThumbnails
            }
        }

        Maui.SettingTemplate
        {
            label1.text: i18n("Hidden Files")
            label2.text: i18n("List hidden files")

            Switch
            {
                Layout.fillHeight: true
                checkable: true
                checked:  settings.showHiddenFiles
                onToggled: settings.showHiddenFiles = !settings.showHiddenFiles
            }
        }

        Maui.SettingTemplate
        {
            label1.text:  i18n("Single Click")
            label2.text: i18n("Open files with a single or double click")

            Switch
            {
                Layout.fillHeight: true
                checkable: true
                checked:  settings.singleClick
                onToggled: settings.singleClick = !settings.singleClick
            }
        }

        Maui.SettingTemplate
        {
            label1.text:  i18n("Save Session")
            label2.text: i18n("Save and restore tabs")

            Switch
            {
                Layout.fillHeight: true
                checkable: true
                checked:  settings.restoreSession
                onToggled: settings.restoreSession = !settings.restoreSession
            }
        }

        Maui.SettingTemplate
        {
            label1.text:  i18n("Preview Files")
            label2.text: i18n("Opens a quick preview with information of the file instead of opening it with an external application.")

            Switch
            {
                Layout.fillHeight: true
                checkable: true
                checked:  settings.previewFiles
                onToggled: settings.previewFiles = !settings.previewFiles
            }
        }

        Maui.SettingTemplate
        {
            label1.text:  i18n("Split Views")
            label2.text: i18n("Support split views horizontally or vertically depending on the avaliable space.")

            Switch
            {
                Layout.fillHeight: true
                checkable: true
                checked:  settings.supportSplit
                onToggled: settings.supportSplit = !settings.supportSplit
            }
        }
    }

    Maui.SettingsSection
    {
//        alt: false
        title: i18n("Sorting")
        description: i18n("Sorting order and behavior.")

        Maui.SettingTemplate
        {
            label1.text: i18n("Global Sorting")
            label2.text: i18n("Use the sorting preferences globally for all the tabs and splits.")

            Switch
            {
                Layout.fillHeight: true
                checkable: true
                checked:  sortSettings.globalSorting
                onToggled: sortSettings.globalSorting = !sortSettings.globalSorting
            }
        }

        Maui.SettingTemplate
        {
            enabled: sortSettings.globalSorting
            label1.text: i18n("Folders first")
            label2.text: i18n("Show folders first.")

            Switch
            {
                Layout.fillHeight: true
                checkable: true
                checked:  sortSettings.foldersFirst
                onToggled: sortSettings.foldersFirst = !sortSettings.foldersFirst
            }
        }

        Maui.SettingTemplate
        {
            enabled: sortSettings.globalSorting
            label1.text: i18n("Group")
            label2.text: i18n("Groups by the sort category.")

            Switch
            {
                Layout.fillHeight: true
                checkable: true
                checked:  sortSettings.group
                onToggled: sortSettings.group = !sortSettings.group
            }
        }

        Maui.SettingTemplate
        {
            enabled: sortSettings.globalSorting
            label1.text: i18n("Sorting by")
            label2.text: i18n("Change the sorting key.")

            Maui.ToolActions
            {
                expanded: true
                autoExclusive: true
                display: ToolButton.TextOnly

                Binding on currentIndex
                {
                    value:  switch(sortSettings.sortBy)
                            {
                            case  Maui.FMList.LABEL: return 0;
                            case  Maui.FMList.MODIFIED: return 1;
                            case  Maui.FMList.SIZE: return 2;
                            case  Maui.FMList.TYPE: return 2;
                            default: return -1;
                            }
                    restoreMode: Binding.RestoreValue
                }

                Action
                {
                    text: i18n("Title")
                    onTriggered: sortSettings.sortBy =  Maui.FMList.LABEL
                }

                Action
                {
                    text: i18n("Date")
                    onTriggered: sortSettings.sortBy =  Maui.FMList.MODIFIED
                }

                Action
                {
                    text: i18n("Size")
                    onTriggered: sortSettings.sortBy =  Maui.FMList.SIZE
                }

                Action
                {
                    text: i18n("Type")
                    onTriggered: sortSettings.sortBy =  Maui.FMList.MIME
                }
            }
        }

        Maui.SettingTemplate
        {
            enabled: sortSettings.globalSorting
            label1.text: i18n("Sort order")
            label2.text: i18n("Change the sorting order.")

            Maui.ToolActions
            {
                expanded: true
                autoExclusive: true
                display: ToolButton.IconOnly

                Binding on currentIndex
                {
                    value:  switch(sortSettings.sortOrder)
                            {
                            case Qt.AscendingOrder: return 0;
                            case Qt.DescendingOrder: return 1;
                            default: return -1;
                            }
                    restoreMode: Binding.RestoreValue
                }

                Action
                {
                    text: i18n("Ascending")
                    icon.name: "view-sort-ascending"
                    onTriggered: sortSettings.sortOrder = Qt.AscendingOrder
                }

                Action
                {
                    text: i18n("Descending")
                    icon.name: "view-sort-descending"
                    onTriggered: sortSettings.sortOrder = Qt.DescendingOrder
                }
            }
        }
    }

    Maui.SettingsSection
    {
        title: i18n("Interface")
        description: i18n("Configure the app UI.")
        lastOne: true

        Maui.SettingTemplate
        {
            label1.text: i18n("Grid Items Size")
            label2.text: i18n("Size of the grid and list view thumbnails.")

            Maui.ToolActions
            {
                expanded: true
                autoExclusive: true
                display: ToolButton.TextOnly

                currentIndex: appSettings.gridSize

                Action
                {
                    text: i18n("S")
                    onTriggered: appSettings.gridSize = 0
                }

                Action
                {
                    text: i18n("M")
                    onTriggered: appSettings.gridSize = 1
                }

                Action
                {
                    text: i18n("X")
                    onTriggered: appSettings.gridSize = 2
                }

                Action
                {
                    text: i18n("XL")
                    onTriggered: appSettings.gridSize = 3
                }
            }
        }

        Maui.SettingTemplate
        {
            label1.text: i18n("List Items Size")
            label2.text: i18n("Size of the grid and list view thumbnails.")

            Maui.ToolActions
            {
                expanded: true
                autoExclusive: true
                display: ToolButton.TextOnly

                currentIndex: appSettings.listSize

                Action
                {
                    text: i18n("S")
                    onTriggered: appSettings.listSize = 0
                }

                Action
                {
                    text: i18n("M")
                    onTriggered: appSettings.listSize = 1
                }

                Action
                {
                    text: i18n("X")
                    onTriggered: appSettings.listSize = 2
                }

                Action
                {
                    text: i18n("XL")
                    onTriggered: appSettings.listSize = 3
                }
            }
        }

        Maui.SettingTemplate
        {
            label1.text:  i18n("Sidebar always visible")
            label2.text: i18n("Keep sidebar on constrained spaces")

            Switch
            {
                Layout.fillHeight: true
                checkable: true
                checked: appSettings.stickSidebar
                onToggled: appSettings.stickSidebar = !appSettings.stickSidebar
            }
        }

        Maui.SettingTemplate
        {
            label1.text: i18n("Dark Mode")
            enabled: false

            Switch
            {
                Layout.fillHeight: true
            }
        }
    }
}
