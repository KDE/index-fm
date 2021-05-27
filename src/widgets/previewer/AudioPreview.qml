import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtMultimedia 5.8
import org.mauikit.controls 1.3 as Maui
import org.kde.kirigami 2.7 as Kirigami

Maui.Page
{
    id: control
    anchors.fill: parent
    headBar.visible: false

    property alias player: player

    MediaPlayer
    {
        id: player
        source: currentUrl
        autoLoad: true
        autoPlay: true
        property string title : player.metaData.title

        onTitleChanged:
        {
            infoModel.append({key:"Title", value: player.metaData.title})
            infoModel.append({key:"Artist", value: player.metaData.albumArtist})
            infoModel.append({key:"Album", value: player.metaData.albumTitle})
            infoModel.append({key:"Author", value: player.metaData.author})
            infoModel.append({key:"Codec", value: player.metaData.audioCodec})
            infoModel.append({key:"Copyright", value: player.metaData.copyright})
            infoModel.append({key:"Duration", value: player.metaData.duration})
            infoModel.append({key:"Track", value: player.metaData.trackNumber})
            infoModel.append({key:"Year", value: player.metaData.year})
            infoModel.append({key:"Rating", value: player.metaData.userRating})
            infoModel.append({key:"Lyrics", value: player.metaData.lyrics})
            infoModel.append({key:"Genre", value: player.metaData.genre})
            infoModel.append({key:"Artwork", value: player.metaData.coverArtUrlLarge})
        }
    }

    Item
    {
        anchors.fill: parent
        anchors.margins: Maui.Style.space.big

        ColumnLayout
        {
            anchors.centerIn: parent
            width: Math.min(parent.width, 200)
            height: Math.min(200, parent.height)
            spacing: Maui.Style.space.big

            Item
            {
                Layout.fillWidth: true
                Layout.fillHeight: true

                Maui.IconItem
                {
                    height: parent.height
                    width: parent.width
                    iconSizeHint: height
                    iconSource: iteminfo.icon
                    imageSource: iteminfo.thumbnail
                }
            }

            Maui.ListItemTemplate
            {
                Layout.fillWidth: true
                label1.text:  player.metaData.title
                label1.font.pointSize: Maui.Style.fontSizes.huge
                label2.font.pointSize: Maui.Style.fontSizes.big
                label1.horizontalAlignment:Qt.AlignHCenter
                label2.horizontalAlignment:Qt.AlignHCenter

                label2.text: player.metaData.albumArtist || player.metaData.albumTitle
            }
        }
    }

    footBar.visible: true
    footerBackground.color: "transparent"
    footBar.leftContent: ToolButton
    {
        icon.name: player.playbackState === MediaPlayer.PlayingState ? "media-playback-pause" : "media-playback-start"
        onClicked: player.playbackState === MediaPlayer.PlayingState ? player.pause() : player.play()
    }

    footBar.rightContent: Label
    {
        text: Maui.Handy.formatTime((player.duration - player.position)/1000)
    }

    footBar.middleContent : Slider
    {
        id: _slider
        Layout.fillWidth: true
        orientation: Qt.Horizontal
        from: 0
        to: 1000
        value: (1000 * player.position) / player.duration
        onMoved: player.seek((_slider.value / 1000) * player.duration)
    }
}


