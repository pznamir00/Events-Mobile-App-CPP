import QtQuick 2.12
import QtQuick 2.4
import QtQuick.Controls 2.4
import QtPositioning 5.14
import QtQuick.Layouts 1.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Window 2.12
import "./Components" as Components


ApplicationWindow {
    visible: true
    width: 500
    height: 800
    title: qsTr("app")
    property var appMainColor: "#34edb6"


    header: Rectangle {
        width: parent.width
        height: 80
        color: "#333"
        Image {
            id: logo
            width: 100
            height: 100
            y: -5
            x: 50
            source: "../Images/logo.png"
        }

        Components.CustomButton{
            id: headerButton
            background: Rectangle{
                border.color: appMainColor
                border.width: 2
                color: "#333"
                radius: 4
            }
            function setLabel()
            {
                if(UserClass.check_authenticate())
                    contentItemText = UserClass.get_logged_full_name();
                else
                    contentItemText = "Zaloguj się";
            }

            Component.onCompleted: setLabel();
            onClicked: swipeView.setCurrentIndex(1);
        }
    }

    SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: tabBar.currentIndex
        focus: true
        interactive: false
        signal update();

        MainMenu{}
        User{}
        AboutApp{}
    }


    footer: TabBar {
        id: tabBar
        currentIndex: swipeView.currentIndex

        TabButton {
            background: Rectangle{color: tabBar.currentIndex == 0 ? appMainColor : "#333"}
            font.pixelSize: 30
            text: qsTr("\u2302")
        }
        TabButton {
            background: Rectangle{color: tabBar.currentIndex == 1 ? appMainColor : "#333"}
            font.pixelSize: 30
            text: qsTr("\u25A1")
        }
        TabButton{
            background: Rectangle{color: tabBar.currentIndex == 2 ? appMainColor : "#333"}
            font.pixelSize: 21
            text: qsTr("\u24D8")
        }
    }
}
