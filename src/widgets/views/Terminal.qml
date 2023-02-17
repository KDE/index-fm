// Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2018-2020 Nitrux Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later


import org.mauikit.controls 1.0 as Maui
import org.mauikit.terminal 1.0 as Term

Term.Terminal
{
    id: control
    kterminal.colorScheme: _customCS.path

    Term.CustomColorScheme
    {
        id: _customCS
        Maui.Theme.colorSet: Maui.Theme.Window
        Maui.Theme.inherit: false
        name: "Adaptive"
        description: i18n("Follows the system color scheme.")
        backgroundColor: Maui.Theme.backgroundColor
        foregroundColor: Maui.Theme.textColor
        color2: Maui.Theme.highlightColor
        color3: Maui.Theme.negativeBackgroundColor
        color4: Maui.Theme.positiveBackgroundColor
        color5: Maui.Theme.hoverColor
        color6: Maui.Theme.highlightColor
        color7: Maui.Theme.linkColor
        color8: Maui.Theme.neutralBackgroundColor
        color9: Maui.Theme.textColor
    }

    onUrlsDropped:
    {
        var str = ""
        for(var i in urls)
            str = str + urls[i].replace("file://", "")+ " "

        control.session.sendText(str)
    }

    onKeyPressed:
    {
        if(event.key == Qt.Key_F4)
        {
            toogleTerminal()
        }
    }
}
