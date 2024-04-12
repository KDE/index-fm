import QtQuick.Controls 2.14

import org.mauikit.controls 1.3 as Maui

Maui.SettingsDialog
{
    id: control
   
    Maui.Controls.title: i18n("Shortcuts")
  

    Maui.SectionGroup
    {
        title: i18n("Navigation")
        description: i18n("Browser navigation with keyboard.")

        Maui.SectionItem
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

        Maui.SectionItem
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

        Maui.SectionItem
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

        Maui.SectionItem
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

        Maui.SectionItem
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

        Maui.SectionItem
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

        Maui.SectionItem
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

        Maui.SectionItem
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

        Maui.SectionItem
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

        Maui.SectionItem
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
