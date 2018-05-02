import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.0 as Kirigami
import "../../widgets_templates"

Item
{
    height: iconSizes.big

    Rectangle
    {
        anchors.fill: parent
        z:-1
        color: Kirigami.Theme.viewBackgroundColor
        radius: Math.floor(Kirigami.Units.devicePixelRatio) * 3
        opacity: 1
        border.color: Qt.tint(Kirigami.Theme.textColor, Qt.rgba(Kirigami.Theme.backgroundColor.r, Kirigami.Theme.backgroundColor.g, Kirigami.Theme.backgroundColor.b, 0.7))
        border.width: Math.floor(Kirigami.Units.devicePixelRatio)
    }


    RowLayout
    {
        id: pathEntry
        anchors.fill:  parent
        visible: false

        TextInput
        {
            id: entry
            height: parent.height
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.leftMargin: contentMargins
            Layout.alignment: Qt.AlignVCenter
            verticalAlignment: Qt.AlignVCenter

            onAccepted:
            {
                browser.openFolder(text)
                showEntryBar()
            }
        }

        Item
        {
            Layout.fillHeight: true
            Layout.leftMargin: space.small
            Layout.rightMargin: space.small
            width: iconSize

            IndexButton
            {
                anchors.centerIn: parent
                iconName: "go-next"
                isMask: true
                onClicked:
                {
                    browser.openFolder(entry.text)
                    showEntryBar()
                }
            }
        }
    }

    RowLayout
    {
        id: pathCrumbs
        anchors.fill: parent
        spacing: 0

        Item
        {
            Layout.fillHeight: true
            Layout.leftMargin: space.small
            Layout.rightMargin: space.small
            width: iconSize

            IndexButton
            {
                anchors.centerIn: parent
                iconName: "go-home"
                isMask: true
                onClicked:
                {
                    if(pageStack.currentIndex !== 0 && !pageStack.wideMode)
                        pageStack.currentIndex = 0

                    browser.openFolder(inx.homePath())
                }
            }
        }

        Kirigami.Separator
        {
            Layout.fillHeight: true
        }

        ListView
        {
            id: pathBarList
            Layout.fillHeight: true
            Layout.fillWidth: true

            orientation: ListView.Horizontal
            clip: true
            spacing: 0

            focus: true
            interactive: true

            model: ListModel{}

            delegate: PathBarDelegate
            {
                id: delegate
                height: iconSizes.big - (Kirigami.Units.devicePixelRatio * 2)
                width: iconSizes.big * 3

                Connections
                {
                    target: delegate
                    onClicked:
                    {
                        pathBarList.currentIndex = index
                        browser.openFolder(pathBarList.model.get(index).path)
                    }
                }
            }
        }

        Item
        {
            Layout.fillHeight: true
            Layout.leftMargin: space.small
            Layout.rightMargin: space.small
            width: iconSize
            IndexButton
            {
                anchors.centerIn: parent
                isMask: true

                iconName: "filename-space-amarok"
                onClicked: showEntryBar()
            }
        }

        //        MouseArea
        //        {
        //            anchors.fill: parent
        //            propagateComposedEvents: true
        //            onClicked: showEntryBar()
        //        }

    }

    function append(path)
    {
        pathBarList.model.clear()
        var places = path.split("/")
        var url = ""
        for(var i in places)
        {
            url = url + places[i] + "/"
            console.log(url)
            if(places[i].length > 1)
                pathBarList.model.append({label : places[i], path: url})
        }

        pathBarList.currentIndex = pathBarList.count-1
        pathBarList.positionViewAtEnd()
    }

    function position(index)
    {
        //        rollList.currentIndex = index
        //        rollList.positionViewAtIndex(index, ListView.Center)
    }

    function showEntryBar()
    {
        pathEntry.visible = !pathEntry.visible
        entry.text = browser.currentPath
        pathCrumbs.visible = !pathCrumbs.visible
    }


}
