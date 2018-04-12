import QtQuick 2.9
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3

Menu
{
    x: parent.width / 2 - width / 2
    y: parent.height / 2 - height / 2
    modal: true
    focus: true
    parent: ApplicationWindow.overlay

    margins: 1
    padding: 2


    property string path : ""
    property bool isDir : false

    signal bookmarkClicked(string path)
    signal removeClicked(string path)
    signal shareClicked(string path)
    signal copyClicked(string path)
    signal cutClicked(string path)
    signal tagsClicked(string path)

    Column
    {
        MenuItem
        {
            text: qsTr("Bookmark")
            enabled: isDir
            onTriggered:
            {
                bookmarkClicked(path)
                close()
            }
        }
        MenuItem
        {
            text: qsTr("Tags...")
            onTriggered:
            {
                tagsClicked(path)
                close()
            }
        }


        MenuItem
        {
            text: qsTr("Share...")
            enabled: !isDir
            onTriggered:
            {
                shareClicked(path)
                close()
            }
        }
        MenuItem
        {
            text: qsTr("Copy...")
            onTriggered:
            {
                copyClicked(path)
                close()
            }
        }

        MenuItem
        {
            text: qsTr("Cut...")
            onTriggered:
            {
                cutClicked(path)
                close()
            }
        }

        MenuItem
        {
            text: qsTr("Remove...")
            onTriggered:
            {
                removeClicked(path)
                close()
            }
        }
    }


    function show(url)
    {
        path = url
        isDir = inx.isDir(path)
        popup()
    }
}