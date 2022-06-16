import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3

import org.mauikit.controls 1.3 as Maui

import org.mauikit.filebrowsing 1.0 as FB

Maui.Page
{
    id: control
    headBar.visible: false

    FontLoader
    {
        id: _font
        source: currentUrl
    }

    readonly property string abc : "a b c d e f g h i j k l m n o p q r s t u v w x y z"
    readonly property string nums : "1 2 3 4 5 6 7 8 9 0"
    readonly property string symbols : "~ ! @ # $ % ^ & * ( ) _ + { } < > , . ? / ; ' [ ] \ \ | `"

    readonly property string paragraph : "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur faucibus, arcu quis interdum congue, ligula nisl facilisis felis, id faucibus urna lacus at ipsum. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Suspendisse nec enim augue. Nullam in convallis odio, quis commodo lectus. Nulla id facilisis nulla. Mauris cursus pulvinar mi in facilisis. Phasellus id venenatis nibh. Etiam eget dignissim nulla."

    background: null
    footBar.visible: true
    footBar.background:  null
    footBar.rightContent: Button
    {
        text: i18n("Install")
        onClicked:
        {
            FB.FM.copy([currentUrl], FB.FM.homePath()+"/.fonts")
        }
    }

    Maui.ScrollView
    {
        anchors.fill: parent
        padding:  Maui.Style.space.big
        rightPadding: padding
        leftPadding: padding
        topPadding: padding

        contentHeight: _layout.implicitHeight
        contentWidth: availableWidth

        Flickable
        {
            boundsBehavior: Flickable.StopAtBounds
            boundsMovement: Flickable.StopAtBounds

            ColumnLayout
            {
                id: _layout
                width: parent.width
                spacing: Maui.Style.space.medium

                Label
                {
                    font.family: _font.name
                    Layout.fillWidth: true
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    text: abc.toUpperCase()
                    color: Maui.Theme.textColor
                    font.pointSize: 30
                    font.bold: true
                    font.weight: Font.Bold
                }

                Label
                {
                    font.family: _font.name
                    Layout.fillWidth: true
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    text: abc
                    color: Maui.Theme.textColor
                    font.pointSize: 20
                }

                Label
                {
                    font.family: _font.name
                    Layout.fillWidth: true
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    text: nums
                    color: Maui.Theme.textColor
                    font.pointSize: 30
                    font.weight: Font.Light
                }

                Label
                {
                    font.family: _font.name
                    Layout.fillWidth: true
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    text: paragraph
                    color: Maui.Theme.textColor
                    font.pointSize: Maui.Style.fontSizes.huge
                }

                Label
                {
                    font.family: _font.name
                    Layout.fillWidth: true
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    text: symbols
                    color: Maui.Theme.textColor
                    font.pointSize: 15
                }
            }
        }
    }
}
