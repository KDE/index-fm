import QtQuick
import QtQuick.Controls

import org.mauikit.controls as Maui

Maui.Page
{
    id: control
    headBar.visible: false
    footBar.visible: true
    footBar.background: null

    footBar.rightContent: Button
    {
        text: i18n("Extract")
        onClicked:
        {
            dialogLoader.sourceComponent= _extractDialogComponent
            dialog.open()
            _compressedFile.extract(browser.currentPath, dialogLoader.textEntry.text)
        }
    }

    Component.onCompleted:
    {
        _compressedFile.url = currentUrl
    }

    Maui.ListBrowser
    {
        id: _listView
        anchors.fill: parent
        model: Maui.BaseModel
        {
            list: _compressedFile.model
        }

        delegate: Maui.ItemDelegate
        {
            height: Maui.Style.rowHeight* 1.5
            width: ListView.view.width

            Maui.ListItemTemplate
            {
                anchors.fill: parent
                iconSource: model.icon
                iconSizeHint: Maui.Style.iconSizes.medium
                label1.text: model.label
                label2.text: model.date
            }
        }
    }
}
