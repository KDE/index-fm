import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.13
import org.mauikit.controls 1.3 as Maui
import org.maui.index 1.0 as Index


ColumnLayout
{
    id: control

    property alias url : _permissions.url

    Index.FileProperties
    {
        id: _permissions
    }

    Index.Permission
    {
        id: _ownerPermissions
        url: control.url
        user: Index.Permission.OWNER
    }


    Index.Permission
    {
        id: _groupPermissions
        url: control.url
        user: Index.Permission.GROUP
    }

    Index.Permission
    {
        id: _otherPermissions
        url: control.url
        user: Index.Permission.OTHER
    }

    Maui.SettingsSection
    {
        Layout.fillWidth: true
        title: i18n("Permissions")
        description: i18n("Set file permissions to access this file")

        Maui.SettingTemplate
        {
            label1.text: i18n("Owner")

            Maui.ToolActions
            {
                Layout.fillWidth: true
                autoExclusive: false

                Action
                {
                    text: i18n("Read")
                    checked: _ownerPermissions.read
                    onTriggered: _ownerPermissions.read = !_ownerPermissions.read
                }

                Action
                {
                    text: i18n("Write")
                    checked: _ownerPermissions.write

                }

                Action
                {
                    text: i18n("Execute")
                    checked: _ownerPermissions.execute
                }
            }
        }

        Maui.SettingTemplate
        {
            label1.text: i18n("Group")

            Maui.ToolActions
            {
                Layout.fillWidth: true
                autoExclusive: false
                //                checkable: true

                Action
                {
                    text: i18n("Read")
                    checked: _groupPermissions.read

                }

                Action
                {
                    text: i18n("Write")
                    checked: _groupPermissions.write


                }

                Action
                {
                    text: i18n("Execute")
                    checked: _groupPermissions.execute
                }
            }
        }

        Maui.SettingTemplate
        {
            label1.text: i18n("Everyone")

            Maui.ToolActions
            {
                Layout.fillWidth: true
                autoExclusive: false

                Action
                {
                    text: i18n("Read")
                    checked: _otherPermissions.read
                }

                Action
                {
                    text: i18n("Write")
                    checked: _otherPermissions.read
                }

                Action
                {
                    text: i18n("Execute")
                    checked: _otherPermissions.execute

                }
            }
        }

    }

    Maui.SettingsSection
    {
        Layout.fillWidth: true

        title: i18n("Ownership")
        description: i18n("Set file permissions to access this file")

        Maui.SettingTemplate
        {
            label1.text: i18n("Owner")
            label2.text: _permissions.owner

        }

        Maui.SettingTemplate
        {
            label1.text: i18n("Group")
            label2.text: _permissions.group

        }
        Maui.SettingTemplate
        {
            label1.text: i18n("Users")
            Maui.ComboBox
            {
                model: _permissions.users
            }
        }

        Maui.SettingTemplate
        {
            label1.text: i18n("Groups")
            Maui.ComboBox
            {
                model: _permissions.groups
            }
        }
    }
}
