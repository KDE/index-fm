import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import org.kde.maui 1.0 as Maui

Maui.ToolBar
{
    position: ToolBar.Footer

    leftContent: Maui.ToolButton
    {
        id: viewBtn
        iconName:  browser.detailsView ? "view-list-icons" : "view-list-details"
        onClicked: browser.switchView()
    }

    middleContent: Row
    {

        spacing: space.medium
        Maui.ToolButton
        {
            iconName: "go-previous"
            onClicked: browser.goBack()
        }

        Maui.ToolButton
        {
            id: favIcon
            iconName: "go-up"
            onClicked: browser.goUp()

        }

        Maui.ToolButton
        {
            iconName: "go-next"
            onClicked: browser.goNext()
        }
    }

    rightContent:  [
        Maui.ToolButton
        {
            iconName: "documentinfo"
            iconColor: detailsDrawer.visible ? highlightColor : textColor
            onClicked: detailsDrawer.visible ? detailsDrawer.close() :
                                               detailsDrawer.show(currentPath)
        },
        Maui.ToolButton
        {
            iconName: "overflow-menu"
            onClicked:  browserMenu.show()
        }
    ]
}
