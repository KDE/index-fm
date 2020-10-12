import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3
import org.kde.mauikit 1.0 as Maui
import org.kde.kirigami 2.7 as Kirigami
import org.maui.index 1.0 as Index

Maui.Page
{
    id: control

    FontLoader
    {
        id: _font
        source: currentUrl
    }

    readonly property string abc : "a b c d e f g h i j k l m n o p q r s t u v w x y z"
    readonly property string nums : "1 2 3 4 5 6 7 8 9 0"
    readonly property string symbols : "~ ! @ # $ % ^ & * ( ) _ + { } < > , . ? / ; ' [ ] \ \ | `"

    readonly property string paragraph : "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur faucibus, arcu quis interdum congue, ligula nisl facilisis felis, id faucibus urna lacus at ipsum. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Suspendisse nec enim augue. Nullam in convallis odio, quis commodo lectus. Nulla id facilisis nulla. Mauris cursus pulvinar mi in facilisis. Phasellus id venenatis nibh. Etiam eget dignissim nulla."

    footBar.visible: true
    footBar.rightContent: Button
    {
        text: i18n("Install")
        onClicked:
        {
            Maui.FM.copy([currentUrl], Maui.FM.homePath()+"/.fonts")
        }
    }

    Kirigami.ScrollablePage
    {
        anchors.fill: parent

        ColumnLayout
        {
            width: parent.width
            spacing: Maui.Style.space.medium

            Label
            {
                font.family: _font.name
                Layout.fillWidth: true
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                text: abc.toUpperCase()
                color: Kirigami.Theme.textColor
                font.pointSize: 30
            }

            Label
            {
                font.family: _font.name
                Layout.fillWidth: true
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                text: abc
                color: Kirigami.Theme.textColor
                font.pointSize: 20
            }

            Label
            {
                font.family: _font.name
                Layout.fillWidth: true
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                text: nums
                color: Kirigami.Theme.textColor
                font.pointSize: 30
            }

            Label
            {
                font.family: _font.name
                Layout.fillWidth: true
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                text: paragraph
                color: Kirigami.Theme.textColor
                font.pointSize: Maui.Style.fontSizes.huge
            }

            Label
            {
                font.family: _font.name
                Layout.fillWidth: true
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                text: symbols
                color: Kirigami.Theme.textColor
                font.pointSize: 15
            }
        }

    }

}
