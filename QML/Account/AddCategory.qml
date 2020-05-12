import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Dialogs 1.2
import "../Components" as Components




Page {
    width: 500
    height: 800

    function addCategory()
    {
        form.value = val.text;
        if(CatClass.validate(form.value)){
            EventClass.filter_by_category();
            CatClass.commit_new(form.value);

            success.visible = true;
            swipeView.setCurrentIndex(0);
            swipeView.update();
        }
        else error.visible = true;
    }



    header: Label {
        text: "Dodaj kategorię"
        font.pixelSize: Qt.application.font.pixelSize * 2
        padding: 10
    }

    Rectangle{
        id: form
        x: 60
        anchors.fill: parent
        anchors.margins: 10
        property variant value

        Rectangle{
            width: parent.width
            height: 25
            y: 50
            TextField{
                id: val
                anchors.fill: parent
                placeholderText: "Dadaj nazwę kategorii"
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
            x: 393
            y: 95
            onClicked: addCategory()
            contentItemText: "  Zapisz  "
        }
    }
}
