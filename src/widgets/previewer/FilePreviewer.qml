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

    readonly property alias listView : _listView
    readonly property alias model : _model
    readonly property alias list: _list
    property alias currentIndex: _listView.currentIndex

    ListModel { id: infoModel }

    readonly property string title :  _listView.currentItem.title

    property bool isFav : false
    property bool isDir : false
    property bool showInfo: true

    readonly property bool ready : list.status.code === FB.PathStatus.READY

    ListView
    {
        id: _listView
        anchors.fill: parent
        orientation: ListView.Horizontal
        currentIndex: -1
        focus: true
        spacing: 0

        model: Maui.BaseModel
        {
            id: _model
            list: FB.FMList
            {
                id: _list

            }
        }
        interactive: Maui.Handy.hasTransientTouchInput
        boundsBehavior: Flickable.StopAtBounds
        boundsMovement: Flickable.StopAtBounds

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

            readonly property bool isCurrentItem : ListView.isCurrentItem

            property url currentUrl: model.path
            property var iteminfo : model

            readonly property string title: model.label

            Loader
            {
                id: previewLoader
                asynchronous: true
                active: _delegate.isCurrentItem
                visible: !control.showInfo
                anchors.fill: parent
                onActiveChanged: if(active) show(currentUrl)
            }

            Loader
            {
                anchors.fill: parent
                visible: control.showInfo
                active: _delegate.isCurrentItem
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

            function show(path)
            {
                console.log("ASKIGN TO PREVIEW FILE <<", path, iteminfo.mime)
                initModel()

                control.isDir = model.isdir == "true"
                control.currentUrl = path
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

                console.log("previe mime", iteminfo.mime)
                previewLoader.source = source
                control.showInfo = (source === "DefaultPreview.qml")
            }

            function initModel()
            {
                infoModel.clear()
                infoModel.append({key: "Name", value: iteminfo.label})
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

    function goPrevious()
    {
        _listView.decrementCurrentIndex()
    }

    function goNext()
    {
        _listView.incrementCurrentIndex()
    }

    function toggleInfo()
    {
        control.showInfo = !control.showInfo
    }

    property int _index

    function setData(model, index)
    {
        control.list.path = model.list.path
        control.list.hidden = model.list.hidden
        control.list.onlyDirs = model.list.onlyDirs
        control.list.foldersFirst = model.list.foldersFirst
        control.list.filters = model.list.filters
        control.list.filterType = model.list.filterType
        control.list.sortBy = model.list.sortBy
        control._index = index
        _timer.start()

    }

    Timer
    {
        id: _timer
        interval: 1500
        triggeredOnStart : false
        onTriggered:
        {
            control.currentIndex= control._index
        }
    }
}
