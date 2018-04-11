import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.0 as Kirigami
import "../../widgets_templates"

Item
{
    height: 32

    Rectangle
    {
        anchors.fill: parent
        z:-1
        color: Kirigami.Theme.viewBackgroundColor
        radius: 4
        opacity: 1
        border.color: Qt.tint(Kirigami.Theme.textColor, Qt.rgba(Kirigami.Theme.backgroundColor.r, Kirigami.Theme.backgroundColor.g, Kirigami.Theme.backgroundColor.b, 0.7))
    }

    RowLayout
    {
        anchors.fill: parent
        spacing: 0

        Item
        {
            Layout.fillHeight: true
            Layout.leftMargin: 10
            Layout.rightMargin: 10

            width: 22
            IndexButton
            {
                anchors.centerIn: parent
                iconName: "go-home"
                iconSize: 22
                onClicked: browser.openFolder(inx.homePath())
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
            Layout.leftMargin: 10
            Layout.rightMargin: 10

            width: 22
            IndexButton
            {
                anchors.centerIn: parent
                iconName: "filename-space-amarok"
                iconSize: 22
            }
        }

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


}
