import QtQuick 2.9
import QtQuick.Controls 2.2

import org.mauikit.texteditor 1.0 as TE

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
