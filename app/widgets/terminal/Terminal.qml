import QMLTermWidget 1.0
import QtQuick 2.2
import QtQuick.Controls 1.1

Item
{
    id: terminalContainer

    property size virtualResolution: Qt.size(kterminal.width, kterminal.height)
    property alias mainTerminal: kterminal
    property alias session: ksession

    property real fontWidth: 1.0
    property real screenScaling: 1.0
    property real scaleTexture: 1.0
    property alias title: ksession.title
    property alias kterminal: kterminal

    //Parameters for the burnIn effect.

    property size terminalSize: kterminal.terminalSize
    property size fontMetrics: kterminal.fontMetrics

    // Manage copy and paste


    //When settings are updated sources need to be redrawn.



    QMLTermWidget
    {
        id: kterminal
        focus: true
        anchors.fill: parent
        smooth: true
        enableBold: false
        fullCursorHeight: true
        onKeyPressedSignal: ksession.hasDarkBackground
        colorScheme: "DarkPastels"
        session: QMLTermSession
        {
            id: ksession
            initialWorkingDirectory: "$HOME"
            onFinished: Qt.quit()

        }


        MouseArea
        {
            anchors.fill: parent
            propagateComposedEvents: true
            onClicked:
            {
                console.log("temrinal cliked")
                kterminal.forceActiveFocus()
            }
        }
        QMLTermScrollbar
        {
            id: kterminalScrollbar
            terminal: kterminal
            anchors.margins: width * 0.5
            width: terminal.fontMetrics.width * 0.75
            Rectangle
            {
                anchors.fill: parent
                anchors.topMargin: 1
                anchors.bottomMargin: 1
                color: "white"
                radius: width * 0.25
                opacity: 0.7
            }
        }
        //        function handleFontChange(fontSource, pixelSize, lineSpacing, screenScaling, fontWidth){
        //            fontLoader.source = fontSource;

        //            kterminal.antialiasText = !appSettings.lowResolutionFont;
        //            font.pixelSize = pixelSize;
        //            font.family = fontLoader.name;

        //            terminalContainer.fontWidth = fontWidth;
        //            terminalContainer.screenScaling = screenScaling;
        //            scaleTexture = Math.max(1.0, Math.floor(screenScaling * appSettings.windowScaling));

        //            kterminal.lineSpacing = lineSpacing;
        //        }
        function startSession()
        {

            ksession.setShellProgram("/usr/bin/zsh");
            ksession.setArgs("");


            ksession.startShellProgram();
            forceActiveFocus();
        }

        Component.onCompleted:
        {
            startSession()
        }
    }
}
