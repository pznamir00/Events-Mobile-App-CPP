import QtQuick 2.12
import QtQuick.Controls 2.5
import "./Components" as Components



Page {

    Item
    {
        Components.CustomButton{
            id: account
            x: 0
            y: 10
            contentItem: Text{text: "  Twoje konto  "; color: "#a0a0a0"}
            background: Rectangle{color: "#fff"}
            onClicked: loader.source = "./Account/Account.qml"
        }

        Components.CustomButton{
            id: addEvent
            x: 150
            y: 10
            contentItem: Text{text: "  Dodaj wydarzenie  "; color: "#a0a0a0"}
            background: Rectangle{color: "#fff"}
            onClicked: loader.source = "./Account/AddEvent.qml"
        }

        Components.CustomButton{
            id: addCategory
            x: 300
            y: 10
            contentItem: Text{text: "  Dodaj kategorię  "; color: "#a0a0a0"}
            background: Rectangle{color: "#fff"}
            onClicked: loader.source = "./Account/AddCategory.qml"
        }

        Rectangle{
            y: 40
            width: 500
            height: 1
            color: "#a0a0a0"
        }
    }


    Loader
    {
        y: 60
        id: loader
    }


    Component.onCompleted: {
        if(UserClass.check_authenticate())
            loader.source = "./Account/Account.qml";
        else{
            loader.source = "Login.qml";
        }
    }
}
