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
}
