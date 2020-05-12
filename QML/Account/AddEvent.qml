import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls 2.0
import QtLocation 5.12
import QtPositioning 5.12
import QtQuick.Dialogs 1.2
import "../Components" as Components


Page {
    width: 500
    height: 800

    function addEvent()
    {
        form.tit = title.text;
        form.desc = description.text;
        form.e_dat = date.text;
        form.cat_id = categoryBox.currentIndex + 1;
        if(EventClass.validate(form.tit, form.desc,  form.e_dat)){
            EventClass.filter_by_category();
            EventClass.commit_new(form.tit, form.desc, form.e_dat, form.cat_id,
                     form.coord_x, form.coord_y);
            success.visible = true;
            swipeView.setCurrentIndex(0);
            swipeView.update();
        }
        else error.visible = true;
    }



    header: Label {
        text: qsTr("Dodaj wydarzenie")
        font.pixelSize: Qt.application.font.pixelSize * 2
        padding: 10
    }

    Rectangle{
        id: form
        anchors.fill: parent
        anchors.margins: 10
        property variant tit: ""
        property variant desc: ""
        property variant e_dat: ""
        property variant cat_id: 0
        property variant coord_x: 0.00
        property variant coord_y: 0.00
        anchors.rightMargin: 10
        anchors.bottomMargin: 10
        anchors.leftMargin: 10
        anchors.topMargin: 10



        TextField{
            id: title
            width: parent.width
            placeholderText: "Dodaj tytuł"
        }

        Rectangle{
            x: 0
            y: 46
            width: 480
            height: 69
            border.color: "#b0b0b0"
            border.width: 1
            TextArea {
                id: description
                anchors.fill: parent
                placeholderText: qsTr("Dodaj opis")
            }
        }

        TextField{
            id: date
            x: 0
            y: 121
            width: parent.width
            placeholderText: "Dadaj czas wydarzenia (format DD.MM.RRRR gg:mm)"
        }

        Components.CategoriesComboBox{
            id: categoryBox
            x: 330
            y: 170
        }

        Rectangle{
            x: 0
            anchors.fill: parent/2
            anchors.margins: 20
            width: parent.width
            height: 300
            y: 217

            Label{
                x: 0
                text: "Dodaj lokalizację"
                font.pixelSize: 12
                y: -32
            }

            Components.Map {
                id: map

                MapQuickItem{
                    id: marker
                    anchorPoint.x: icon.width/2
                    anchorPoint.y: icon.height
                    sourceItem: Image{
                        id: icon
                        source: "../../Images/marker.png"
                        sourceSize.width: 20
                        sourceSize.height: 28
                    }
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        marker.coordinate = map.toCoordinate(Qt.point(mouse.x, mouse.y));
                        form.coord_x = "0" + marker.coordinate.latitude;
                        form.coord_y = "0" + marker.coordinate.longitude;
                    }
                }
            }
        }

        MessageDialog{
            id: error
            title: "Błąd"
            text: "Twoje dane są niepoprawne"
            icon: StandardIcon.Critical
        }

        MessageDialog{
            id: success
            title: ""
            text: "Zapisano"
            icon: StandardIcon.NoIcon
        }

        Components.CustomButton{
            x: 380
            y: 526
            onClicked: addEvent();
            contentItemText: "  Zapisz  "
        }
    }

    Component.onCompleted: categoryBox.load();
}
