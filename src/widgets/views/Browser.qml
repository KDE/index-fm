import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
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
    //    property alias terminal : terminalLoader.item

    Maui.FileBrowser
    {
        id: browser
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.margins: 0
        headBar.visible: true
        headBar.drawBorder: true
        headBar.plegable: false
        menu:[
            Maui.MenuItem
            {
                visible: !isMobile
                text: qsTr("Show terminal")
                checkable: true
                checked: terminalVisible
                onTriggered:
                {
                    terminalVisible = !terminalVisible
                    Maui.FM.setDirConf(browser.currentPath+"/.directory", "MAUIFM", "ShowTerminal", terminalVisible)
                }
            }/*,

//            Maui.MenuItem
//            {
//                checkable: true
//                checked: placesSidebar.isCollapsed
//                text: qsTr("Compact mode")
//                onTriggered: placesSidebar.isCollapsed = !placesSidebar.isCollapsed
//            }*/
        ]

        onNewBookmark: placesSidebar.list.refresh()
        onCurrentPathChanged:
        {
            if(!isAndroid)
                terminalVisible = Maui.FM.dirConf(currentPath+"/.directory")["showterminal"] === "true" ? true : false

            //            if(terminalVisible && !isMobile)
            //                terminal.session.sendText("cd " + currentPath + "\n")

            for(var i = 0; i < placesSidebar.count; i++)
                if(currentPath === placesSidebar.list.get(i).path)
                    placesSidebar.currentIndex = i

            searchField
        }

        anchors.top: parent.top
        anchors.bottom: terminalVisible ? handle.top : parent.bottom

        onItemClicked: openItem(index)

        onItemDoubleClicked:
        {
            var item = list.get(index)
            console.log(item.mime)
            if(Maui.FM.isDir(item.path) || item.mime === "inode/directory")
                browser.openFolder(item.path)
            else
                browser.openFile(item.path)
        }
    }

    Rectangle
    {
        id: handle
        visible: true

        Layout.fillWidth: true
        height: 5
        color: "transparent"

        Kirigami.Separator
        {
            visible: terminalLoader.visible

            anchors
            {
                bottom: parent.bottom
                right: parent.right
                left: parent.left
            }
        }

        MouseArea
        {
            visible: terminalLoader.visible

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
        visible: false
        focus: true
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.alignment: Qt.AlignBottom
        Layout.minimumHeight: 100
        Layout.maximumHeight: control.height * 0.3
        anchors.bottom: parent.bottom
        anchors.top: handle.bottom
        //        source: !isMobile ? "Terminal.qml" : undefined
    }

}
