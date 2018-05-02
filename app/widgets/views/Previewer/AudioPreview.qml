import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtMultimedia 5.8
import "../../../widgets_templates"

Item
{
    property alias player: player

    MediaPlayer
    {
        id: player
        source: "file://"+currentUrl

        autoLoad: true
        autoPlay: false
    }

    ColumnLayout
    {
        anchors.fill: parent

        Item
        {

            Layout.fillWidth: true
            height: parent.width * 0.3
            Layout.margins: contentMargins

            IndexButton
            {
                anchors.centerIn: parent
                flat: true
                size: iconSizes.huge
                iconName: iteminfo.iconName
                onClicked: player.playbackState === MediaPlayer.PlayingState ? player.pause() : player.play()
            }
        }

        Item
        {
            Layout.fillWidth: true
            height: rowHeight
            width: parent.width* 0.8

            Layout.margins: contentMargins

            Label
            {
                text: iteminfo.name
                width: parent.width
                height: parent.height
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                elide: Qt.ElideRight
                wrapMode: Text.Wrap
                font.pointSize: fontSizes.big
                font.weight: Font.Bold
                font.bold: true
                color: altColorText

            }
        }

        Item
        {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: contentMargins

            Column
            {
                spacing: space.small

                Label
                {
                    text: qsTr("Title: ")+ player.metaData.title
                    horizontalAlignment: Qt.AlignHCenter
                    verticalAlignment: Qt.AlignVCenter
                    elide: Qt.ElideRight
                    wrapMode: Text.Wrap
                    font.pointSize: fontSizes.default
                    color: altColorText

                }
                Label
                {
                    text: qsTr("Artist: ")+ player.metaData.albumArtist
                    horizontalAlignment: Qt.AlignHCenter
                    verticalAlignment: Qt.AlignVCenter
                    elide: Qt.ElideRight
                    wrapMode: Text.Wrap
                    font.pointSize: fontSizes.default
                    color: altColorText

                }
                Label
                {
                    text: qsTr("Album: ")+ player.metaData.albumTitle
                    horizontalAlignment: Qt.AlignHCenter
                    verticalAlignment: Qt.AlignVCenter
                    elide: Qt.ElideRight
                    wrapMode: Text.Wrap
                    font.pointSize: fontSizes.default
                    color: altColorText

                }
                Label
                {
                    text: qsTr("Author: ")+ player.metaData.author
                    horizontalAlignment: Qt.AlignHCenter
                    verticalAlignment: Qt.AlignVCenter
                    elide: Qt.ElideRight
                    wrapMode: Text.Wrap
                    font.pointSize: fontSizes.default
                    color: altColorText

                }
                Label
                {
                    text: qsTr("Codec: ")+ player.metaData.audioCodec
                    horizontalAlignment: Qt.AlignHCenter
                    verticalAlignment: Qt.AlignVCenter
                    elide: Qt.ElideRight
                    wrapMode: Text.Wrap
                    font.pointSize: fontSizes.default
                    color: altColorText

                }
                Label
                {
                    text: qsTr("Copyright: ")+ player.metaData.copyright
                    horizontalAlignment: Qt.AlignHCenter
                    verticalAlignment: Qt.AlignVCenter
                    elide: Qt.ElideRight
                    wrapMode: Text.Wrap
                    font.pointSize: fontSizes.default
                    color: altColorText

                }

                Label
                {
                    text: qsTr("Duration: ")+ player.metaData.duration
                    horizontalAlignment: Qt.AlignHCenter
                    verticalAlignment: Qt.AlignVCenter
                    elide: Qt.ElideRight
                    wrapMode: Text.Wrap
                    font.pointSize: fontSizes.default
                    color: altColorText

                }

                Label
                {
                    text: qsTr("Number: ")+ player.metaData.trackNumber
                    horizontalAlignment: Qt.AlignHCenter
                    verticalAlignment: Qt.AlignVCenter
                    elide: Qt.ElideRight
                    wrapMode: Text.Wrap
                    font.pointSize: fontSizes.default
                    color: altColorText

                }

                Label
                {
                    text: qsTr("Year: ")+ player.metaData.year
                    horizontalAlignment: Qt.AlignHCenter
                    verticalAlignment: Qt.AlignVCenter
                    elide: Qt.ElideRight
                    wrapMode: Text.Wrap
                    font.pointSize: fontSizes.default
                    color: altColorText

                }

                Label
                {
                    text: qsTr("Mood: ")+ player.metaData.mood
                    horizontalAlignment: Qt.AlignHCenter
                    verticalAlignment: Qt.AlignVCenter
                    elide: Qt.ElideRight
                    wrapMode: Text.Wrap
                    font.pointSize: fontSizes.default
                    color: altColorText

                }

                Label
                {
                    text: qsTr("Rating: ")+ player.metaData.userRating
                    horizontalAlignment: Qt.AlignHCenter
                    verticalAlignment: Qt.AlignVCenter
                    elide: Qt.ElideRight
                    wrapMode: Text.Wrap
                    font.pointSize: fontSizes.default
                    color: altColorText

                }
            }
        }
    }
}
