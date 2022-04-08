import QtQuick 2.14
import QtQuick.Controls 2.14

import org.kde.kirigami 2.14 as Kirigami
import org.mauikit.controls 1.0 as Maui

Control
{
    id: control
    implicitWidth: _label.implicitWidth + rightPadding + leftPadding
    rightPadding: Maui.Style.space.medium
    leftPadding: rightPadding
    /**
      *
      */
    //    property alias hovered: _mouseArea.containsMouse

    /**
      *
      */
    property bool checked :  ListView.isCurrentItem
    property bool lastOne : false
    property bool firstOne : false

    ToolTip.delay: 1000
    ToolTip.timeout: 5000
    ToolTip.visible: _mouseArea.containsMouse || _mouseArea.containsPress
    ToolTip.text: model.path


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

    background: Kirigami.ShadowedRectangle
    {
        color: control.checked ? Kirigami.Theme.highlightColor : (control.hovered ? Kirigami.Theme.hoverColor : Qt.lighter(Kirigami.Theme.backgroundColor))

        corners
        {
            topLeftRadius: control.firstOne ? Maui.Style.radiusV : 0
            topRightRadius: control.lastOne ? Maui.Style.radiusV : 0
            bottomLeftRadius: control.firstOne ? Maui.Style.radiusV : 0
            bottomRightRadius: control.lastOne ? Maui.Style.radiusV : 0
        }
    }

    contentItem: MouseArea
    {
        id: _mouseArea
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


        Label
        {
            id: _label
            text: model.label
            anchors.fill: parent

            horizontalAlignment: Qt.AlignHCenter
            verticalAlignment:  Qt.AlignVCenter
            elide: Qt.ElideRight
            wrapMode: Text.NoWrap
            font.bold: control.checked
            color: control.checked ? Kirigami.Theme.highlightedTextColor : Kirigami.Theme.textColor
        }
    }



}
