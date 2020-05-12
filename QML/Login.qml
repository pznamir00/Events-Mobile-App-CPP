import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Dialogs 1.2
import "./Components" as Components


Page
{
    y: -50
    z: 3

    function signIn()
    {
        if(UserClass.login(login.username, login.password)){
            success.visible = true;
            headerButton.setLabel();
            loader.source = "./Account/Account.qml";
        }
        else{
            error.visible = true;
        }
    }

    header: Label {
        text: "Zaloguj się                                                             "
        font.pixelSize: Qt.application.font.pixelSize * 2
        padding: 10
    }

    MessageDialog{
        id: error
        title: "Błąd"
        text: "Twoje dane są niepoprawne"
        icon: StandardIcon.Critical
    }

    BusyIndicator {
        id: success
        x: 347
        y: 195
        layer.textureMirroring: ShaderEffectSource.MirrorVertically
        layer.smooth: false
        visible: false;
    }

    Rectangle{
        id: login
        border.width: 1
        border.color: "#b0b0b0"
        radius: 5
        width: 300
        height: 300
        x: 100
        y: 145
        property var username: ""
        property var password: ""

        Rectangle{
            y: 100
            x: 60
            width: parent.width
            TextField{
                anchors.verticalCenterOffset: 5
                anchors.horizontalCenterOffset: -59
                horizontalAlignment: Text.AlignLeft
                anchors.centerIn: parent
                placeholderText: "Nazwa użytkownika"
                Keys.onReleased: {login.username = text}
            }
        }

        Rectangle{
            y: 150
            x: 60
            width: parent.width
            TextField{
                anchors.verticalCenterOffset: 0
                anchors.horizontalCenterOffset: -59
                echoMode: "Password"
                anchors.centerIn: parent
                placeholderText: "Hasło"
                Keys.onReleased: {login.password = text}
            }
        }

        Components.CustomButton{
            x: 110
            y: 200
            onClicked: signIn();
            contentItemText: "  Zaloguj się  "
        }
    }

    Text {
        id: element
        x: 307
        y: 400
        width: 64
        color: appMainColor
        text: qsTr("Utwórz konto")
        font.underline: true
        layer.textureMirroring: ShaderEffectSource.MirrorVertically
        layer.smooth: false
        font.pixelSize: 12

        MouseArea{
            anchors.fill: parent
            onClicked: loader.source = "Register.qml";
        }
    }
}
