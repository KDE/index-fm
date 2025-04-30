// Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2018-2020 Nitrux Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick.Controls
import org.mauikit.controls as Maui
import org.mauikit.terminal as Term

Term.Terminal
{
    id: control
    Maui.Theme.colorSet: Maui.Theme.Window
    Maui.Theme.inherit: false

    kterminal.colorScheme: appSettings.terminalFollowsColorScheme ? "Adaptive" : appSettings.terminalColorScheme

    onUrlsDropped: (urls) =>
    {
        var str = ""
        for(var i in urls)
            str = str + String(urls[i]).replace("file://", "")+ " "

        control.session.sendText(str)
    }

    menu : Action
    {
        text: i18n("Sync")
        shortcut: "Ctrl+."
        onTriggered: syncTerminal(currentBrowser.currentPath)
    }

    onKeyPressed: (event) =>
    {
        if(event.key == Qt.Key_F4)
        {
            toggleTerminal()
        }
    }
}
