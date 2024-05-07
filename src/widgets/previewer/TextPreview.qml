import QtQuick
import QtQuick.Controls

import org.mauikit.texteditor as TE

TE.TextEditor
{
    id: control
    body.readOnly: true
    document.enableSyntaxHighlighting: true
    fileUrl: currentUrl

    Connections
    {
        target: control.document

        function onLoaded()
        {
            infoModel.insert(0, {key:"Length", value: control.body.length.toString()})
            infoModel.insert(0, {key:"Line Count", value: control.body.lineCount.toString()})
        }
    }
}
