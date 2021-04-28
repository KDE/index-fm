import QtQuick 2.14
import QtQml 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3

import org.kde.kirigami 2.7 as Kirigami
import org.mauikit.controls 1.2 as Maui

import org.mauikit.filebrowsing 1.0 as FB

Maui.Page
{
    id: control

    property url currentUrl: ""

    property alias listView : _listView
    property alias model : _listView.model
    property alias currentIndex: _listView.currentIndex

    property bool isFav : false
    property bool isDir : false
    property bool showInfo: true

    property alias tagBar : _tagsBar

    title: _listView.currentItem.title

    headerBackground.color: "transparent"
    headBar.rightContent: ToolButton
    {
        icon.name: "documentinfo"
        checkable: true
        checked: control.showInfo
        onClicked: control.showInfo = !control.showInfo
    }

    ListView
    {
        id: _listView
        anchors.fill: parent
        orientation: ListView.Horizontal
        currentIndex: -1
        clip: true
        focus: true
        spacing: 0

        interactive: Kirigami.Settings.hasTransientTouchInput
        boundsBehavior: Flickable.StopAtBounds
        boundsMovement :Flickable.StopAtBounds

        highlightFollowsCurrentItem: true
        highlightMoveDuration: 0
        highlightResizeDuration : 0
        snapMode: ListView.SnapOneItem
        cacheBuffer: width
        keyNavigationEnabled : true
        keyNavigationWraps : true
        onMovementEnded: currentIndex = indexAt(contentX, contentY)

        delegate: Item
        {
            id: _delegate

            height: ListView.view.height
            width: ListView.view.width

            property bool isCurrentItem : ListView.isCurrentItem
            property url currentUrl: model.path
            property var iteminfo : model
            property alias infoModel : _infoModel
            readonly property string title: model.label

            Loader
            {
                id: previewLoader
                active: _delegate.isCurrentItem
                visible: !control.showInfo
                width: parent.width
                height: parent.height
                onActiveChanged: if(active) show(currentUrl)
            }

            Kirigami.ScrollablePage
            {
                id: _infoContent
                anchors.fill: parent
                visible: control.showInfo

//                Kirigami.Theme.backgroundColor: "transparent"
                padding:  0
                leftPadding: padding
                rightPadding: padding
                topPadding: padding
                bottomPadding: padding

                ColumnLayout
                {
                    width: parent.width
                    spacing: 0

                    Item
                    {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 100

                        Kirigami.Icon
                        {
                            height: Maui.Style.iconSizes.large
                            width: height
                            anchors.centerIn: parent
                            source: iteminfo.icon
                        }
                    }

                    Maui.Separator
                    {
                        edge: Qt.BottomEdge
                        Layout.fillWidth: true
                    }

                    Repeater
                    {
                        model: ListModel { id: _infoModel }
                        delegate: Maui.AlternateListItem
                        {
                            visible: model.value
                            Layout.preferredHeight: visible ? _delegateColumnInfo.label1.implicitHeight + _delegateColumnInfo.label2.implicitHeight + Maui.Style.space.large : 0
                            Layout.fillWidth: true
                            lastOne: index === _infoModel.count-1

                            Maui.ListItemTemplate
                            {
                                id: _delegateColumnInfo

                                iconSource: "documentinfo"
                                iconSizeHint: Maui.Style.iconSizes.medium

                                anchors.fill: parent
                                anchors.margins: Maui.Style.space.medium

                                label1.text: model.key
                                label1.font.weight: Font.Bold
                                label1.font.bold: true
                                label2.text: model.value
                                label2.elide: Qt.ElideMiddle
                                label2.wrapMode: Text.Wrap
                                label2.font.weight: Font.Light
                            }
                        }
                    }
                }
            }

            function show(path)
            {
                console.log("Init model for ", path, previewLoader.active, _delegate.isCurrentItem)
                initModel()

                control.isDir = model.isdir == "true"
                control.currentUrl = path
                control.isFav =  _tagsBar.list.contains("fav")

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

                console.log("previe mime", iteminfo.mime)
                previewLoader.source = source
                control.showInfo = source === "DefaultPreview.qml"
            }

            function initModel()
            {
                infoModel.clear()
                infoModel.append({key: "Type", value: iteminfo.mime})
                infoModel.append({key: "Date", value: Qt.formatDateTime(new Date(model.date), "d MMM yyyy")})
                infoModel.append({key: "Modified", value: Qt.formatDateTime(new Date(model.modified), "d MMM yyyy")})
                infoModel.append({key: "Last Read", value: Qt.formatDateTime(new Date(model.lastread), "d MMM yyyy")})
                infoModel.append({key: "Owner", value: iteminfo.owner})
                infoModel.append({key: "Group", value: iteminfo.group})
                infoModel.append({key: "Size", value: Maui.Handy.formatSize(iteminfo.size)})
                infoModel.append({key: "Symbolic Link", value: iteminfo.symlink})
                infoModel.append({key: "Path", value: iteminfo.path})
                infoModel.append({key: "Thumbnail", value: iteminfo.thumbnail})
                infoModel.append({key: "Icon Name", value: iteminfo.icon})
            }
        }
    }

    footerColumn: [
        FB.TagsBar
        {
            id: _tagsBar
            width: parent.width
            list.urls: [control.currentUrl]
            list.strict: false
            allowEditMode: true
            onTagRemovedClicked: list.removeFromUrls(index)
            onTagsEdited: list.updateToUrls(tags)
            Kirigami.Theme.textColor: control.Kirigami.Theme.textColor
            Kirigami.Theme.backgroundColor: control.Kirigami.Theme.backgroundColor

            onAddClicked:
            {
                tagsDialog.composerList.urls = [ previewer.currentUrl]
                tagsDialog.open()
            }
        },

        Maui.ToolBar
        {
            width: parent.width
            position: ToolBar.Bottom
            background: null
            leftContent: Maui.ToolActions
            {
                expanded: true
                autoExclusive: false
                checkable: false

                Action
                {
                    text: i18n("Previous")
                    icon.name: "go-previous"
                    onTriggered :  _listView.decrementCurrentIndex()
                }

                Action
                {
                    text: i18n("Next")
                    icon.name: "go-next"
                    onTriggered: _listView.incrementCurrentIndex()
                }
            }

           rightContent: [
                ToolButton
                {
                    icon.name: "document-open"
                    onClicked:
                    {
                        currentBrowser.openFile(control.currentUrl)
                    }
                },

                ToolButton
                {
                    icon.name: "love"
                    checkable: true
                    checked: control.isFav
                    onClicked:
                    {
                        if(control.isFav)
                            _tagsBar.list.removeFromUrls("fav")
                        else
                            _tagsBar.list.insertToUrls("fav")

                        control.isFav = !control.isFav
                    }
                },

                ToolButton
                {
                    visible: !isDir
                    icon.name: "document-share"
                    onClicked:
                    {
                        Maui.Platform.shareFiles([control.currentUrl])
                    }
                }
            ]
        }

       ]


    Connections
    {
        target: tagsDialog
        enabled: tagsDialog
        ignoreUnknownSignals: true

        function onTagsReady(tags)
        {
            tagsDialog.composerList.updateToUrls(tags)
            tagBar.list.refresh()
        }
    }
}
