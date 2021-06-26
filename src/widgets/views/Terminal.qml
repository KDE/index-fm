// Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2018-2020 Nitrux Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later


import org.mauikit.controls 1.0 as Maui

Maui.Terminal
{
    id: control
    kterminal.colorScheme: "DarkPastels"

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
