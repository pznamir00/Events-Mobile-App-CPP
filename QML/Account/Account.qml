import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Dialogs 1.2
import "../Components" as Components



Page {
    width: 500
    height: 800
    id: account

    function logout()
    {
        UserClass.logout();
        headerButton.setLabel();
        loader.source = "../Login.qml";
        swipeView.setCurrentIndex(0);
        swipeView.update();
    }

    function getEvents()
    {
        var events = UserClass.get_events_of_logged();
        setEvents(events);
    }

    function setEvents(events)
    {
        events.forEach(function(event){
            Qt.createQmlObject('import QtQuick 2.12; import QtQuick.Controls 2.5; Text{text: "'+event[0]+'"}', eventId);
            Qt.createQmlObject('import QtQuick 2.12; import QtQuick.Controls 2.5; Text{text: "'+event[1]+'"}', eventTitle);
            Qt.createQmlObject('import QtQuick 2.12; import QtQuick.Controls 2.5; Text{text: "'+event[2]+'"}', eventAddTime);
            Qt.createQmlObject('import QtQuick 2.12; import QtQuick.Controls 2.5; Text{text: "'+event[3]+'"}', eventTime);
        });
    }

    Components.CustomButton {
        x: 27
        y: 448
        onClicked: logout();
        contentItemText: "  Wyloguj się  "
    }

    Rectangle {
        id: rectangle
        x: 21
        y: 56
        width: 456
        height: 352
        color: "#ffffff"

        Label{
            text: "Twoje wydarzenia"
            y: -5
        }

        Column {
            id: eventId
            x: 23
            y: 18
            width: 88
            height: 316
            spacing: 3
            Text{text: "ID"}
        }

        Column {
            id: eventTitle
            x: 131
            y: 18
            width: 88
            height: 316
            spacing: 3
            Text{text: "Tytuł"}
        }

        Column {
            id: eventTime
            x: 239
            y: 18
            width: 88
            height: 316
            spacing: 3
            Text{text: "Czas"}
        }

        Column {
            id: eventAddTime
            x: 344
            y: 18
            width: 88
            height: 316
            spacing: 3
            Text{text: "Dodanie"}
        }
    }

    Rectangle{
        x: 0
        y: 422
        width: 500
        height: 1
        color: appMainColor
    }




    header: Label {
        text: ""
        font.pixelSize: Qt.application.font.pixelSize * 2
        padding: 10
        Component.onCompleted: text = UserClass.get_logged_full_name();
    }

    Component.onCompleted: {
        getEvents();
    }
}
