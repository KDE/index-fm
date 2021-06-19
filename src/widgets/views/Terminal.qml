// Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2018-2020 Nitrux Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later


import QtQuick 2.0
import org.mauikit.controls 1.0 as Maui

Maui.Terminal
{
    id: control
    kterminal.colorScheme: "DarkPastels"

    onTitleChanged:
    {
//        var path = "file://"+control.title.slice(control.title.indexOf(":")+1).trim();
//        console.log("yea", path)
//        root.currentBrowser.currentPath = path;

//        if(FB.FM.fileExists(path))
//        {
//            root.currentBrowser.currentPath = path;
//        }
    }

    onUrlsDropped:
    {
        var str = ""
        for(var i in urls)
            str = str + urls[i].replace("file://", "")+ " "

        control.session.sendText(str)
    }
}
