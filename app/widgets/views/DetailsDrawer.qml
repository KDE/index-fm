import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.0 as Kirigami
import "../../widgets_templates"
import "Previewer"

Drawer
{
    id: detailsDrawerRoot
    edge: Qt.RightEdge
    width: Kirigami.Units.gridUnit * 17
    height: browserContainer.height
    y: headerBar.height + mainHeader.height
    //    visible: opened ? pageStack.currentIndex = 1 && pageStack.wideMode : false
    clip: true
    property string currentUrl: ""
    property var iteminfo : ({})
    property bool isDir : false

    Component
    {
        id: imagePreview
        ImagePreview
        {
            id: imagePreviewer
        }
    }

    background:  Rectangle
    {
        color: altColor
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

            ToolBar
            {
                id: previewToolbar
                position: ToolBar.Footer
                height: implicitHeight
                width: parent.width

                background: Rectangle
                {
                    implicitHeight: iconSize * 2
                    color: altColor
                }

                RowLayout
                {
                    anchors.fill: parent
                    Item
                    {
                        visible: !isDir
                        Layout.alignment: Qt.AlignLeft
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        IndexButton
                        {
                            anchors.centerIn: parent
                            isMask: true
                            iconName: "document-share"
                            iconColor: altColorText
                            onClicked:
                            {
                                isAndroid ? android.shareDialog(currentUrl) :
                                            shareDialog.show(currentUrl)
                                close()
                            }
                        }
                    }

                    Item
                    {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        IndexButton
                        {
                            anchors.centerIn: parent
                            isMask: true
                            iconName: "love"
                            iconColor: altColorText
                        }
                    }

                    Item
                    {
                        visible: !isDir
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        IndexButton
                        {
                            anchors.centerIn: parent
                            isMask: true
                            iconName: "document-open"
                            iconColor: altColorText
                            onClicked:
                            {
                                if(previewLoader.item.player)
                                    previewLoader.item.player.stop()

                                browser.openFile(currentUrl)
                            }
                        }
                    }

                    Item
                    {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        IndexButton
                        {
                            anchors.centerIn: parent
                            isMask: true
                            iconName: "archive-remove"
                            iconColor: altColorText
                            onClicked:
                            {
                                close()
                                browser.remove([currentUrl])
                            }
                        }
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
        var mimetype = iteminfo.mimetype.slice(0, iteminfo.mimetype.indexOf("/"))
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
