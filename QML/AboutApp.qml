import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls 1.3
import QtQuick.Window 2.2


Page {
    Text {
        id: element
        x: 62
        y: 141
        width: 517
        height: 198
        text: qsTr("")
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: 15

        Tab{
            id: tab
            //Map{visible: false}
        }
        Component.onCompleted: {
            text = getInformations;
        }
    }
}
