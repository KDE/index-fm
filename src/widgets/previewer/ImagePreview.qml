import org.mauikit.controls 1.3 as Maui

Maui.ImageViewer
{
    id: control
    source: currentUrl
    animated: iteminfo.mime === "image/gif"
}



