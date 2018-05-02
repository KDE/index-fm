import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import "../../../widgets_templates"

IndexPopup
{
    property string picUrl : ""

    padding: contentMargins
    maxWidth: parent.width / 2
    height: parent.height * 0.3
    parent: parent

    ColumnLayout
    {
        anchors.fill: parent
        height: parent.height
        width:parent.width

        Label
        {
            text: qsTr("Open with...")
            width: parent.width
            Layout.fillWidth: true
            horizontalAlignment: Qt.AlignHCenter
            elide: Qt.ElideRight
            font.pointSize: fontSizes.big
            padding: contentMargins
            font.bold: true
            font.weight: Font.Bold

        }

        ShareGrid
        {
            id: shareGrid
            Layout.fillHeight: true
            Layout.fillWidth: true
            width: parent.width
            onServiceClicked: triggerService(index)
        }
    }


    onOpened: populate()

    function show(url)
    {
        picUrl = url
        open()
    }

    function populate()
    {
        shareGrid.model.clear()
        var services = inx.openWith(picUrl)
        var devices = inx.getKDEConnectDevices()

        shareGrid.model.append({serviceIcon: "internet-mail", serviceLabel: "eMail", email: true})

        if(devices.length > 0)
            for(var i in devices)
            {
                devices[i].serviceIcon = "smartphone"
                shareGrid.model.append(devices[i])

            }

        if(services.length > 0)
            for(i in services)
                shareGrid.model.append(services[i])

    }

    function triggerService(index)
    {
        var obj = shareGrid.model.get(index)

        if(obj.serviceKey)
            inx.sendToDevice(obj.serviceLabel, obj.serviceKey, picUrl)
        else if(obj.email)
            inx.attachToEmail(picUrl)
        else
            inx.runApplication(obj.actionArgument, picUrl)

        shareDialog.close()
    }
}

