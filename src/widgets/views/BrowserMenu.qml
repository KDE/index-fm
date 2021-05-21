import QtQuick 2.15
import QtQuick.Controls 2.15

import org.mauikit.controls 1.3 as Maui
import org.kde.kirigami 2.6 as Kirigami

Maui.ContextualMenu
{
    id: control


    /**
      *
      */
    function show(parent = control, x, y)
    {
          control.open(x, y, parent)
    }
}

