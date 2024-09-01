import QtQuick
import QtQuick.Controls

import org.mauikit.controls as Maui
import org.mauikit.archiver as Arc

Maui.Page
{
    id: control
    headBar.visible: false
    footBar.visible: true
    footBar.background: null

    // footBar.rightContent: Button
    // {
    //     text: i18n("Extract")
    //     onClicked:
    //     {
    //         dialogLoader.sourceComponent= _extractDialogComponent
    //         dialog.open()
    //         _compressedFile.extract(browser.currentPath, dialogLoader.textEntry.text)
    //     }
    // }

    Component.onCompleted:
    {
        _archiver.url = currentUrl
    }

    Arc.ArchivePage
    {
        id: _archiver
        anchors.fill: parent
        onItemClicked: (index, item) =>
                       {
                           if(item.isdir === "true")
                           {
                               openItem(item)
                           }
                       }
    }
}
