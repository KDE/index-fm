import QtQuick 2.14

import org.mauikit.controls 1.3 as Maui

Maui.ColorsRow
{
    id: control

    colors: ["#f21b51", "#f9a32b", "#3eb881", "#b2b9bd", "#474747"]

    signal folderColorPicked(string color)

    property string folderColor : "folder"

    currentColor : switch(control.folderColor)
                   {
                   case "folder-red": "#f21b51"; break;
                   case "folder-orange": "#f9a32b"; break;
                   case "folder-green": "#3eb881"; break;
                   case "folder-grey": "#b2b9bd"; break;
                   case "folder-black": "#474747"; break;
                   default : return control.Maui.Theme.backgroundColor;
                   }

    onColorPicked: (color) =>
                   {
                       switch(color)
                       {
                           case "#f21b51" : folderColor = "folder-red"; break;
                           case "#f9a32b" : folderColor = "folder-orange"; break;
                           case "#3eb881" : folderColor = "folder-green"; break;
                           case "#b2b9bd" : folderColor = "folder-grey"; break;
                           case "#474747" : folderColor = "folder-black"; break;
                           default : folderColor = "folder";
                       }

                       control.folderColorPicked(folderColor)
                   }
}
