import QtQuick 2.15
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3

import org.mauikit.controls 1.3 as Maui
import org.mauikit.terminal 1.0 as Term


Term.ColorSchemesPage
{
    currentColorScheme: appSettings.terminalColorScheme
    enabled: !appSettings.terminalFollowsColorScheme

    onCurrentColorSchemeChanged: appSettings.terminalColorScheme = currentColorScheme
}
