import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import org.mauikit.controls as Maui

import org.mauikit.filebrowsing as FB

Item
{
    id: control

    implicitHeight: 1000
    property url currentUrl: ""

    ListModel { id: infoModel }

    readonly property string title : iteminfo.title
    property var iteminfo : ({})

    property bool isFav : false
    property bool isDir : false

    property bool showInfo: true

    onCurrentUrlChanged:
    {
        console.log("PREVIEWER URL CHANGED", control.currentUrl)
        show()
    }

    Loader
    {
        id: previewLoader
        asynchronous: true
        visible: !control.showInfo
        anchors.fill: parent
        // onActiveChanged: if(active) show()
    }

    Loader
    {
        anchors.fill: parent
        visible: control.showInfo
        asynchronous: true

        sourceComponent: Maui.ScrollColumn
        {
            spacing: Maui.Style.space.huge

            Item
            {
                Layout.fillWidth: true
                Layout.preferredHeight: 150

                Maui.IconItem
                {
                    height: parent.height * 0.9
                    width: height
                    anchors.centerIn: parent
                    iconSource: iteminfo.icon
                    imageSource: iteminfo.thumbnail
                    iconSizeHint: Maui.Style.iconSizes.large
                }
            }

            Maui.SectionGroup
            {
                Layout.fillWidth: true

                title: i18n("Details")
                description: i18n("File information")
                Repeater
                {
                    model: infoModel
                    delegate:  Maui.SectionItem
                    {
                        visible:  model.value ? true : false
                        Layout.fillWidth: true
                        label1.text: model.key
                        label2.text: model.value
                        label2.wrapMode: Text.Wrap
                    }
                }
            }

            FileProperties
            {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignCenter
                url: control.currentUrl
                spacing: parent.spacing
            }
        }
    }

    function show()
    {
        // if(!previewLoader.active)
        //     return
        console.log("ASKIGN TO PREVIEW FILE <<", control.currentUrl, iteminfo.mime)

        // if(control.showInfo)

        control.iteminfo = FB.FM.getFileInfo(control.currentUrl)
        control.isDir = iteminfo.isdir == "true"
        control.isFav = FB.Tagging.isFav(control.currentUrl)

        var source = "DefaultPreview.qml"
        if(FB.FM.checkFileType(FB.FMList.AUDIO, iteminfo.mime))
        {
            source = "AudioPreview.qml"
        }else if(FB.FM.checkFileType(FB.FMList.VIDEO, iteminfo.mime))
        {
            source = "VideoPreview.qml"
        }else if(FB.FM.checkFileType(FB.FMList.TEXT, iteminfo.mime))
        {
            source = "TextPreview.qml"
        }else if(FB.FM.checkFileType(FB.FMList.IMAGE, iteminfo.mime))
        {
            source = "ImagePreview.qml"
        }else if(FB.FM.checkFileType(FB.FMList.DOCUMENT, iteminfo.mime))
        {
            source = "DocumentPreview.qml"
        }else if(FB.FM.checkFileType(FB.FMList.COMPRESSED, iteminfo.mime))
        {
            source = "CompressedPreview.qml"
        }else if(FB.FM.checkFileType(FB.FMList.FONT, iteminfo.mime))
        {
            source = "FontPreviewer.qml"
        }else
        {
            source = "DefaultPreview.qml"
        }

        if(previewLoader.source == source)
        {
            console.log("SAME PREVIEWER SOURCE DO NOT REUPDATE", source, previewLoader.source)
            return
        }
        console.log("previe mime", iteminfo.mime, previewLoader.source)
        previewLoader.source = source
        control.showInfo = (source === "DefaultPreview.qml")
        initModel()
    }

    function initModel()
    {
        infoModel.clear()
        infoModel.append({key: "Name", value: iteminfo.label})
        infoModel.append({key: "Type", value: iteminfo.mime})
        infoModel.append({key: "Date", value: Qt.formatDateTime(new Date(iteminfo.date), "d MMM yyyy")})
        infoModel.append({key: "Modified", value: Qt.formatDateTime(new Date(iteminfo.modified), "d MMM yyyy")})
        infoModel.append({key: "Last Read", value: Qt.formatDateTime(new Date(iteminfo.lastread), "d MMM yyyy")})
        infoModel.append({key: "Owner", value: iteminfo.owner})
        infoModel.append({key: "Group", value: iteminfo.group})
        infoModel.append({key: "Size", value: Maui.Handy.formatSize(iteminfo.size)})
        infoModel.append({key: "Symbolic Link", value: iteminfo.symlink})
        infoModel.append({key: "Path", value: iteminfo.path})
        infoModel.append({key: "Thumbnail", value: iteminfo.thumbnail})
        infoModel.append({key: "Icon Name", value: iteminfo.icon})
    }

    function toggleInfo()
    {
        control.showInfo = !control.showInfo
    }

    function setData(url)
    {
        control.currentUrl = url
    }
}
