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
                onToggled:
                {
                    settings.showThumbnails = ! settings.showThumbnails
                }
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
                onToggled:
                {
                     settings.showHiddenFiles = !settings.showHiddenFiles
                }
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
                onToggled:
                {
                    settings.singleClick = !settings.singleClick
                }
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
                onToggled:
                {
                    settings.restoreSession = !settings.restoreSession
                }
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
                onToggled:
                {
                    settings.previewFiles = !settings.previewFiles
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
            label1.text: i18n("Grid Size")
            label2.text: i18n("Thumbnails size in the grid view")

            Maui.ToolActions
            {
                id: _gridIconSizesGroup
                expanded: true
                autoExclusive: true
                display: ToolButton.TextOnly

                Binding on currentIndex
                {
                    value:  switch(iconSize)
                            {
                            case 32: return 0;
                            case 48: return 1;
                            case 64: return 2;
                            case 96: return 3;
                            default: return -1;
                            }
                    restoreMode: Binding.RestoreValue
                }

                Action
                {
                    text: i18n("S")
                    onTriggered: setIconSize(32)
                }

                Action
                {
                    text: i18n("M")
                    onTriggered: setIconSize(48)
                }

                Action
                {
                    text: i18n("X")
                    onTriggered: setIconSize(64)
                }

                Action
                {
                    text: i18n("XL")
                    onTriggered: setIconSize(96)
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
                checked: placesSidebar.stick
                onToggled:
                {
                    placesSidebar.stick = !placesSidebar.stick
                    Maui.FM.saveSettings("STICK_SIDEBAR", placesSidebar.stick, "UI")
                }
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
