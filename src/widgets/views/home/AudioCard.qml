import QtQuick
import QtQuick.Controls 

import QtMultimedia 

Card
{
    id: control

    property alias player : _player

    MediaPlayer
    {
        id: _player
        // autoPlay: true
    }
}
