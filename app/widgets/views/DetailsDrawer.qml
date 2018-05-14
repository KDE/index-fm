import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.0 as Kirigami
import org.kde.maui 1.0 as Maui

import "Previewer"

Maui.Drawer
{
    id: detailsDrawerRoot
    edge: Qt.RightEdge
    height: parent.height - root.headBar.height -root.footBar.height
    y: root.headBar.height
    //    visible: opened ? pageStack.currentIndex = 1 && pageStack.wideMode : false
    property string currentUrl: ""
    property var iteminfo : ({})
    property bool isDir : false

    bg: browser

    Component
    {
        id: imagePreview
        ImagePreview
        {
            id: imagePreviewer
        }
    }

    Component
    {
        id: defaultPreview
        DefaultPreview
        {
            id: defaultPreviewer
        }
    }

    Component
    {
        id: audioPreview
        AudioPreview
        {
            id: audioPreviewer
        }
    }

    Component
    {
        id: videoPreview
        VideoPreview
        {
            id: videoPreviewer
        }
    }

    ColumnLayout
    {
        anchors.fill: parent
        spacing: 0

        Item
        {
            Layout.fillHeight: true
            Layout.fillWidth: true

            height: parent.height
            width: parent.width
            id: previewContent

            ScrollView
            {
                id: scrollView
                anchors.fill:parent
                contentWidth: previewLoader.width
                contentHeight: previewLoader.height

                clip: true

                Loader
                {
                    id: previewLoader

                    height : previewContent.height * 1.5
                    width: previewContent.width
                }
            }
        }

        Item
        {
            Layout.fillWidth: true
            width: parent.width
            height: previewToolbar.height

            Maui.ToolBar
            {
                id: previewToolbar
                position: ToolBar.Footer
                height: implicitHeight
                width: parent.width

                background: Rectangle
                {
                    implicitHeight: iconSize * 2
                    color: "transparent"
                }

                leftContent: Maui.ToolButton
                {
                    visible: !isDir

                    iconName: "document-share"
                    onClicked:
                    {
                        isAndroid ? Maui.Android.shareDialog(currentUrl) :
                                    shareDialog.show(currentUrl)
                        close()
                    }
                }

                middleContent:   [
                    Maui.ToolButton
                    {
                        iconName: "love"
                    },
                    Maui.ToolButton
                    {

                        iconName: "document-open"
                        onClicked:
                        {
                            if(previewLoader.item.player)
                            previewLoader.item.player.stop()

                            browser.openFile(currentUrl)
                        }
                    }
                ]

                rightContent:  Maui.ToolButton
                {
                    iconName: "archive-remove"
                    onClicked:
                    {
                        close()
                        browser.remove([currentUrl])
                    }
                }
            }
        }
    }

    onClosed:
    {
        if(previewLoader.item.player)
            previewLoader.item.player.stop()
    }

    function show(path)
    {
        currentUrl = path
        iteminfo = inx.getFileInfo(path)
        var mimetype = iteminfo.mime.slice(0, iteminfo.mime.indexOf("/"))
        isDir = false

        switch(mimetype)
        {
        case "audio" :
            previewLoader.sourceComponent = audioPreview
            break
        case "video" :
            previewLoader.sourceComponent = videoPreview
            break
        case "text" : console.log("is text")
            break
        case "image" :
            previewLoader.sourceComponent = imagePreview
            break
        case "inode" :
        default:
            isDir = true
            previewLoader.sourceComponent = defaultPreview
        }

        open()
    }
}
