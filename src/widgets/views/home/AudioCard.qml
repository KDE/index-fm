import QtQuick 2.14
import QtQuick.Controls 2.14

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
}
