import QtQuick 2.15
import org.mauikit.documents 1.0 as Poppler

Poppler.PDFViewer
{
    id: control

    path : currentUrl
}
