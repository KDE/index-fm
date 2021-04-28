import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.14 as Kirigami
import org.mauikit.controls 1.2 as Maui
import QtMultimedia 5.8

Card
{
    id: control

    property alias player : _player

    MediaPlayer
    {
        id: _player
        autoLoad: true
    }

    label1.text: player.metaData.title
    label2.text: player.metaData.albumArtist || player.metaData.albumTitle

    template.leftLabels.data: Slider
    {
        id: _slider
        visible: _player.playbackState  === MediaPlayer.PlayingState
        Layout.fillWidth: true
        orientation: Qt.Horizontal
        from: 0
        to: 1000
        value: (1000 * _player.position) / _player.duration
        onMoved: _player.seek((_slider.value / 1000) * _player.duration)
    }

    template.content: ToolButton
    {
        flat: true
        icon.name: _player.playbackState === MediaPlayer.PlayingState ? "media-playback-pause" : "media-playback-start"
        onClicked: _player.playbackState === MediaPlayer.PlayingState ? _player.pause() : _player.play()
    }
}
