import QtQuick 2.0
import QtPositioning 5.12
import QtLocation 5.12

MapQuickItem{
    id: marker
    anchorPoint.x: icon.width/2
    anchorPoint.y: icon.height

    signal clicked(int event);
    property variant itemId;
    property variant label;

    function setLabel()
    {
        var title = EventClass.get_title_by_id(itemId);
        label.text = title;
    }

    sourceItem: Image{
        id: icon
        source: "../../Images/marker.png"
        sourceSize.width: 20
        sourceSize.height: 28

        Rectangle{
            width: parent.width
            y: -17
            Text{
                id: label
                text: ""
                anchors.centerIn: parent
            }
        }

        MouseArea{
            anchors.fill: parent
            onClicked: {
                marker.clicked(itemId);
            }
        }
    }

    Component.onCompleted: setLabel();
}
