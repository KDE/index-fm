import QtQuick 2.0
import org.kde.mauikit 1.0 as Maui

Maui.Terminal
{
    kterminal.colorScheme: "DarkPastels"
    onKeyPressed:
    {
        if ((event.key == Qt.Key_V) && (event.modifiers & Qt.ControlModifier) && (event.modifiers & Qt.ShiftModifier))
        {
            kterminal.pasteClipboard()
        }

        if ((event.key == Qt.Key_C) && (event.modifiers & Qt.ControlModifier) && (event.modifiers & Qt.ShiftModifier))
        {
            kterminal.copyClipboard()
        }

        if ((event.key == Qt.Key_F) && (event.modifiers & Qt.ControlModifier) && (event.modifiers & Qt.ShiftModifier))
        {
            footBar.visible = !footBar.visible
        }
    }
}
