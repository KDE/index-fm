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
        color: Kirigami.Theme.buttonBackgroundColor
        radius: 4
        opacity: 1
        border.color: Qt.tint(Kirigami.Theme.textColor, Qt.rgba(Kirigami.Theme.backgroundColor.r, Kirigami.Theme.backgroundColor.g, Kirigami.Theme.backgroundColor.b, 0.7))
    }

    RowLayout
    {
        anchors.fill: parent

        Item
        {
            Layout.fillHeight: true
            Layout.leftMargin: 15
            width: 22
            IndexButton
            {
                anchors.centerIn: parent
                iconName: "user-home"
                iconSize: 16
                onClicked: browser.openFolder(inx.homePath())
            }
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
