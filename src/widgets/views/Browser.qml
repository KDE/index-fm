import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import "../../widgets_templates"
import "../../Index.js" as INX

import org.kde.kirigami 2.0 as Kirigami
import org.kde.mauikit 1.0 as Maui
import FMModel 1.0
import FMList 1.0
//import FMH 1.0


ColumnLayout
{
    id: control
    spacing: 0
    property alias browser : browser
    property bool terminalVisible : false
    property alias terminal : terminalLoader.item

    Maui.FileBrowser
    {
        id: browser
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.margins: 0

        menu:[
            Maui.MenuItem
            {
                text: qsTr("Show terminal")
                checkable: true
                checked: terminalVisible
                onTriggered:
                {
                    terminalVisible = !terminalVisible
                    Maui.FM.setDirConf(browser.currentPath+"/.directory", "MAUIFM", "ShowTerminal", terminalVisible)
                }
            }
        ]

        onCurrentPathChanged:
        {
            if(!isAndroid)
                terminalVisible = Maui.FM.dirConf(currentPath+"/.directory")["showterminal"] === "true" ? true : false
        }
        anchors.top: parent.top
        anchors.bottom: terminalVisible ? handle.top : parent.bottom

        onItemClicked: openItem(index)

        onItemDoubleClicked:
        {
            var item = list.get(index)

            if(Maui.FM.isDir(item.path))
                browser.openFolder(item.path)
            else
                browser.openFile(item.path)
        }
    }

    Rectangle
    {
        id: handle
        visible: terminalVisible

        Layout.fillWidth: true
        height: 5
        color: "transparent"

        Kirigami.Separator
        {
            anchors
            {
                bottom: parent.bottom
                right: parent.right
                left: parent.left
            }
        }

        MouseArea
        {
            anchors.fill: parent
            drag.target: parent
            drag.axis: Drag.YAxis
            drag.smoothed: true
            cursorShape: Qt.SizeVerCursor
        }
    }

    Loader
    {
        id: terminalLoader
        visible: terminalVisible
        focus: true
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.alignment: Qt.AlignBottom
        Layout.minimumHeight: 100
        Layout.maximumHeight: parent.height *0.5
        anchors.bottom: parent.bottom
        anchors.top: handle.bottom
        source: !isMobile ? "Terminal.qml" : undefined
    }
}
