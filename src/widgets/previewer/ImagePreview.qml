import org.mauikit.imagetools 1.0 as IT

IT.ImageViewer
{
    id: control
    source: currentUrl
    animated: iteminfo.mime === "image/gif"
}



