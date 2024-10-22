import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import QtMultimedia

import org.mauikit.controls as Maui

Item
{
    id: control

    property alias player: player

    MediaPlayer
    {
        id: player
        source: currentUrl
        autoPlay: appSettings.autoPlayPreviews
        property string title : player.metaData.value(MediaMetaData.Title)

        audioOutput: AudioOutput {}

        // onTitleChanged:
        // {
        //     infoModel.append({key:"Title", value: player.metaData.value(MediaMetaData.Title)})
        //     infoModel.append({key:"Artist", value: player.metaData.value(MediaMetaData.AlbumArtist)})
        //     infoModel.append({key:"Album", value: player.metaData.value(MediaMetaData.AlbumTitle)})
        //     infoModel.append({key:"Author", value: player.metaData.value(MediaMetaData.Author)})
        //     infoModel.append({key:"Codec", value: player.metaData.value(MediaMetaData.AudioCodec)})
        //     infoModel.append({key:"Copyright", value: player.metaData.value(MediaMetaData.Copyright)})
        //     infoModel.append({key:"Duration", value: player.metaData.value(MediaMetaData.Duration)})
        //     infoModel.append({key:"Track", value: player.metaData.value(MediaMetaData.TrackNumber)})
        //     infoModel.append({key:"Year", value: player.metaData.value(MediaMetaData.Date)})
        //     infoModel.append({key:"Genre", value: player.metaData.value(MediaMetaData.Genre)})
        // }
    }

    ColumnLayout
    {
        anchors.centerIn: parent
        width: Math.min(parent.width, 200)
        spacing: Maui.Style.space.medium

        Item
        {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Layout.preferredHeight: 200
            Layout.preferredWidth: 200

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
            label1.text:  player.metaData.value(MediaMetaData.Title)
            label1.font.weight: Font.DemiBold
            label1.font.pointSize: Maui.Style.fontSizes.big

            label2.text: player.metaData.value(MediaMetaData.AlbumArtist) || player.metaData.value(MediaMetaData.AlbumTitle)
        }

        RowLayout
        {
            Layout.fillWidth: true

            ToolButton
            {
                icon.name: player.playbackState === MediaPlayer.PlayingState ? "media-playback-pause" : "media-playback-start"
                onClicked:
                {
                    if(player.playbackState === MediaPlayer.PlayingState)
                        player.pause()
                    else
                        player.play()
                }
            }

            Slider
            {
                id: _slider
                Layout.fillWidth: true
                orientation: Qt.Horizontal
                enabled: player.seekable
                from: 0
                to: 1000
                value: (1000 * player.position) / player.duration
                onMoved: player.position = ((_slider.value / 1000) * player.duration)
            }
        }
    }
}


