import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3

import org.kde.kirigami 2.7 as Kirigami
import org.mauikit.controls 1.3 as Maui


Maui.SettingsDialog
{
    id: control
    title: i18n("Shortcuts")
    persistent: false
    page.showTitle: false
    headBar.visible: false

    Maui.SettingsSection
    {
        title: i18n("Navigation")
        description: i18n("Browser navigation.")

        Maui.SettingTemplate
        {
            label1.text: i18n("New Tab")

            Maui.ToolActions
            {
                checkable: false
                autoExclusive: false
                Action
                {
                    text: "Ctrl"
                }

                Action
                {
                    text: "T"
                }
            }
        }

        Maui.SettingTemplate
        {
            label1.text: i18n("Close Tab")

            Maui.ToolActions
            {
                checkable: false
                autoExclusive: false
                Action
                {
                    text: "Ctrl"
                }

                Action
                {
                    text: "W"
                }
            }
        }

        Maui.SettingTemplate
        {
            label1.text: i18n("Path Edit")

            Maui.ToolActions
            {
                checkable: false
                autoExclusive: false
                Action
                {
                    text: "Ctrl"
                }

                Action
                {
                    text: "K"
                }
            }
        }

        Maui.SettingTemplate
        {
            label1.text: i18n("Terminal")

            Maui.ToolActions
            {
                checkable: false
                autoExclusive: false
                Action
                {
                    text: "F4"
                }
            }
        }

        Maui.SettingTemplate
        {
            label1.text: i18n("Split")

            Maui.ToolActions
            {
                checkable: false
                autoExclusive: false
                Action
                {
                    text: "F3"
                }
            }
        }

        Maui.SettingTemplate
        {
            label1.text: i18n("New File")

            Maui.ToolActions
            {
                checkable: false
                autoExclusive: false
                Action
                {
                    text: "Ctrl"
                }

                Action
                {
                    text: "N"
                }
            }
        }

        Maui.SettingTemplate
        {
            label1.text: i18n("Preview")

            Maui.ToolActions
            {
                checkable: false
                autoExclusive: false
                Action
                {
                    text: "SpaceBar"
                }
            }
        }

        Maui.SettingTemplate
        {
            label1.text: i18n("Find Tab")

            Maui.ToolActions
            {
                checkable: false
                autoExclusive: false
                Action
                {
                    text: "Ctrl"
                }

                Action
                {
                    text: "H"
                }
            }
        }

        Maui.SettingTemplate
        {
            label1.text: i18n("Select All")

            Maui.ToolActions
            {
                checkable: false
                autoExclusive: false
                Action
                {
                    text: "Ctrl"
                }

                Action
                {
                    text: "A"
                }
            }
        }

        Maui.SettingTemplate
        {
            label1.text: i18n("Select")

            Maui.ToolActions
            {
                checkable: false
                autoExclusive: false
                Action
                {
                    text: "Ctrl"
                }

                Action
                {
                    text: "Shift"
                }

                Action
                {
                    text: "Arrows"
                }
            }
        }
    }
}
