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

        Switch
        {
            icon.name: "image-preview"
            checkable: true
            checked:  root.showThumbnails
            Kirigami.FormData.label: i18n("Show Thumbnails")
            Layout.fillWidth: true
            onToggled:  root.showThumbnails = ! root.showThumbnails
        }

        Switch
        {
            Kirigami.FormData.label: i18n("Show Hidden Files")
            Layout.fillWidth: true
            checkable: true
            checked:  root.showHiddenFiles
            onToggled:  root.showHiddenFiles = !root.showHiddenFiles
        }

        Switch
        {
            Kirigami.FormData.label: i18n("Single Click")
            Layout.fillWidth: true
            checkable: true
            checked:  root.singleClick
            onToggled:
            {
                root.singleClick = !root.singleClick
                Maui.FM.saveSettings("SINGLE_CLICK",  root.singleClick, "BROWSER")
            }
        }

        Switch
        {
            Kirigami.FormData.label: i18n("Save and Restore Session")
            Layout.fillWidth: true
            checkable: true
            checked:  root.restoreSession
            onToggled:
            {
                root.restoreSession = !root.restoreSession
                Maui.FM.saveSettings("RESTORE_SESSION",  root.restoreSession, "BROWSER")
            }
        }
    }

    Maui.SettingsSection
    {
        title: i18n("Interface")
        description: i18n("Configure the app UI.")

        Switch
        {
            Layout.fillWidth: true
            Kirigami.FormData.label: i18n("Stick SideBar")
            checkable: true
            checked: placesSidebar.stick
            onToggled:
            {
                placesSidebar.stick = ! placesSidebar.stick
                Maui.FM.saveSettings("STICK_SIDEBAR", placesSidebar.stick, "UI")
            }
        }

        Switch
        {
            Kirigami.FormData.label: i18n("Show Status Bar")
            Layout.fillWidth: true
            checkable: true
            checked:  root.showStatusBar
            onToggled:  root.showStatusBar = !root.showStatusBar
        }

        Switch
        {
            Kirigami.FormData.label: i18n("Translucent Sidebar")
            checkable: true
            checked:  root.translucency
            enabled: Maui.Handy.isLinux
            onToggled:
            {
                root.translucency = !root.translucency
                Maui.FM.saveSettings("TRANSLUCENCY",  root.translucency, "UI")
            }
        }

        Switch
        {
            Kirigami.FormData.label: i18n("Dark Mode")
            Layout.fillWidth: true
            checkable: true
            enabled: false
        }

        Maui.ToolActions
        {
            id: _gridIconSizesGroup
            Kirigami.FormData.label: i18n("Grid Icon Size")
            Layout.fillWidth: true
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
}
