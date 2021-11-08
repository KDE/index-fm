import QtQuick 2.14
import QtQuick.Controls 2.14

import org.kde.kirigami 2.14 as Kirigami
import org.mauikit.controls 1.0 as Maui

Rectangle
{
    id: control
    implicitWidth: _label.implicitWidth + Maui.Style.space.big

    /**
      *
      */
    property alias hovered: _mouseArea.containsMouse

    /**
      *
      */
    property bool checked :  ListView.isCurrentItem

    ToolTip.delay: 1000
    ToolTip.timeout: 5000
    ToolTip.visible: _mouseArea.containsMouse || _mouseArea.containsPress
    ToolTip.text: model.path

    color: control.checked || hovered ? Kirigami.Theme.highlightColor : Kirigami.Theme.backgroundColor

    /**
      *
      */
    signal rightClicked()

    /**
      *
      */
    signal clicked()

    /**
      *
      */
    signal doubleClicked()

    /**
      *
      */
    signal pressAndHold()


    Label
    {
        id: _label
        text: model.label
        anchors.fill: parent
        rightPadding: Maui.Style.space.medium
        leftPadding: rightPadding
        horizontalAlignment: Qt.AlignHCenter
        verticalAlignment:  Qt.AlignVCenter
        elide: Qt.ElideRight
        wrapMode: Text.NoWrap
        color: control.checked ? Kirigami.Theme.highlightedTextColor : Kirigami.Theme.textColor
    }

    MouseArea
    {
        id: _mouseArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons:  Qt.RightButton | Qt.LeftButton
        onClicked:
        {
            if(!Kirigami.Settings.isMobile && mouse.button === Qt.RightButton)
                control.rightClicked()
            else
                control.clicked()
        }

        onDoubleClicked: control.doubleClicked()
        onPressAndHold : control.pressAndHold()
    }

}
