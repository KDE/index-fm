import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQml 2.14
import QtQuick.Layouts 1.3

import org.kde.kirigami 2.7 as Kirigami
import org.mauikit.controls 1.2 as Maui
import org.mauikit.filebrowsing 1.0 as FB

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
            label2.text: i18n("Opens a quick preview with information of the file instead of opening it with an external application")

            Switch
            {
                Layout.fillHeight: true
                checkable: true
                checked:  settings.previewFiles
                onToggled: settings.previewFiles = !settings.previewFiles
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
            label2.text: i18n("Size of the grid view.")

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
                    text: i18n("L")
                    onTriggered: appSettings.gridSize = 2
                }

                Action
                {
                    text: i18n("X")
                    onTriggered: appSettings.gridSize = 3
                }

                Action
                {
                    text: i18n("XL")
                    onTriggered: appSettings.gridSize = 4
                }
            }
        }

        Maui.SettingTemplate
        {
            label1.text: i18n("List Items Size")
            label2.text: i18n("Size of the list view.")

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
                    text: i18n("L")
                    onTriggered: appSettings.listSize = 2
                }

                Action
                {
                    text: i18n("X")
                    onTriggered: appSettings.listSize = 3
                }

                Action
                {
                    text: i18n("XL")
                    onTriggered: appSettings.listSize = 4
                }
            }
        }

        Maui.SettingTemplate
        {
            label1.text: i18n("Overview")
            label2.text: i18n("Use overview mode as default on launch")

            Switch
            {
                Layout.fillHeight: true
                checked:  appSettings.overviewStart
                onToggled: appSettings.overviewStart = !appSettings.overviewStart
            }
        }
    }
}
