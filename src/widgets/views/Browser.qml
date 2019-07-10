import QtQuick 2.9
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.0 as Kirigami
import org.kde.mauikit 1.0 as Maui
//import FMH 1.0


SplitView
{
    id: control
    orientation: Qt.Vertical
    property alias browser : browser
    property bool terminalVisible : true
    property alias terminal : terminalLoader.item

    Maui.FileBrowser
    {
        id: browser
        SplitView.fillWidth: true
        SplitView.fillHeight: true
        headBar.visible: true
        headBar.drawBorder: true
        headBar.plegable: false
        menu:[
//            MenuItem
//            {
//                visible: !isMobile
//                text: qsTr("Show terminal")
//                checkable: true
//                checked: terminalVisible
//                onTriggered:
//                {
//                    terminalVisible = !terminalVisible
//                    Maui.FM.setDirConf(browser.currentPath+"/.directory", "MAUIFM", "ShowTerminal", terminalVisible)
//                }
//            }
        ]

        headBar.rightContent: ToolButton
        {
            icon.name: "akonadiconsole"
            onClicked: control.terminalVisible = !control.terminalVisible
            checked : control.terminalVisible
            checkable: false
        }

        onNewBookmark:
        {
            for(var index in paths)
                placesSidebar.list.addPlace(paths[index])
        }

        onCurrentPathChanged:
        {
//            if(!isAndroid)
//                terminalVisible = Maui.FM.dirConf(currentPath+"/.directory")["showterminal"] === "true" ? true : false

                        if(terminalVisible && !isMobile)
                            terminal.session.sendText("cd '" + currentPath + "'\n")

            for(var i = 0; i < placesSidebar.count; i++)
                if(currentPath === placesSidebar.list.get(i).path)
                    placesSidebar.currentIndex = i
        }

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

//    Rectangle
//    {
//        id: handle
//        visible: true

//        Layout.fillWidth: true
//        height: 5
//        color: "transparent"

//        Kirigami.Separator
//        {
//            visible: terminalLoader.visible

//            anchors
//            {
//                bottom: parent.bottom
//                right: parent.right
//                left: parent.left
//            }
//        }

//        MouseArea
//        {
//            visible: terminalLoader.visible

//            anchors.fill: parent
//            drag.target: parent
//            drag.axis: Drag.YAxis
//            drag.smoothed: true
//            cursorShape: Qt.SizeVerCursor
//        }
//    }

//    handle: Rectangle
//    {
//        color: "yellow"
//    }

    Loader
    {
        id: terminalLoader
        visible: terminalVisible
        focus: true
        SplitView.fillWidth: true
        SplitView.fillHeight: true
        SplitView.minimumHeight: 100
        SplitView.maximumHeight: 500
        SplitView.preferredHeight : 200
        source: !isMobile ? "Terminal.qml" : undefined
    }

}
