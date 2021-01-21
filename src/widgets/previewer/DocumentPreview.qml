import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import org.kde.mauikit 1.0 as Maui
import org.kde.kirigami 2.7 as Kirigami
//import QtQuick.Pdf 5.15

Maui.Page
{
    id: control
    headBar.visible: false

    property int currentPage;
    property int pageCount;
    property var pagesModel;
//    title: documentItem.title

//    footBar.visible: true
//    footBar.middleContent: [
//        ToolButton
//        {
//            icon.name: "go-previous"
//            enabled: documentItem.currentPage > 0
//            onClicked:
//            {
//                if(documentItem.currentPage - 1  > -1)
//                    documentItem.currentPage --
//            }
//        },

//        ToolButton
//        {
//            icon.name: "go-next"
////            enabled: documentItem.pageCount > 1	&& 	documentItem.currentPage + 1 < documentItem.pageCount
//            onClicked:
//            {

////                if(documentItem.currentPage +1  < documentItem.pageCount)
////                    documentItem.currentPage ++
//                _viewer.source = _viewer.source+"#1"
//            }
//        }
//    ]

    Maui.ImageViewer
    {
        id: _viewer
        anchors.fill: parent
        source: currentUrl
    }

//    PdfDocument
//    {
//        id: documentItem
////        height: 100
////        width: 100
//        source : currentUrl
//        //         onWindowTitleForDocumentChanged: {
//        //             fileBrowserRoot.title = windowTitleForDocument
//        //         }

//    }


}
