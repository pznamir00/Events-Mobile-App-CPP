import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Dialogs 1.2
import "./Components" as Components


Page
{
    y: -50
    z: 3

    function register()
    {
        if(UserClass.validate(
                    regist.fN,
                    regist.lN,
                    regist.em,
                    regist.usrn,
                    regist.pass1,
                    regist.pass2))
        {
            UserClass._register(
                        regist.fN,
                        regist.lN,
                        regist.em,
                        regist.usrn,
                        regist.pass1);
            UserClass.login(regist.usrn, regist.pass1);
            success.visible = true;
            headerButton.setLabel();
            loader.source = "./Account/Account.qml"
        }
        else {
            error.visible = true;
        }
    }

    header: Label {
        text: "Zarejestruj się                                                             "
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
        id: regist
        width: parent.width
        y: 210
        property var fN: ""
        property var lN: ""
        property var usrn: ""
        property var em: ""
        property var pass1: ""
        property var pass2: ""

        Rectangle{
            y: 60
            width: parent.width
            TextField{
                anchors.verticalCenterOffset: -116
                anchors.horizontalCenterOffset: -157
                anchors.centerIn: parent
                placeholderText: "Imię"
                Keys.onReleased: {regist.fN = text}
            }
        }

        Rectangle{
            y: 110
            width: parent.width
            TextField{
                anchors.verticalCenterOffset: -122
                anchors.horizontalCenterOffset: -157
                anchors.centerIn: parent
                placeholderText: "Nazwisko"
                Keys.onReleased: {regist.lN = text}
            }
        }

        Rectangle{
            y: 160
            width: parent.width
            TextField{
                anchors.verticalCenterOffset: -96
                anchors.horizontalCenterOffset: -157
                anchors.centerIn: parent
                placeholderText: "Email"
                Keys.onReleased: {regist.em = text}
            }
        }

        Rectangle{
            y: 210
            width: parent.width
            TextField{
                anchors.verticalCenterOffset: -201
                anchors.horizontalCenterOffset: 90
                anchors.centerIn: parent
                placeholderText: "Nazwa użytkownika"
                Keys.onReleased: {regist.usrn = text}
            }
        }

        Rectangle{
            y: 260
            width: parent.width
            TextField{
                anchors.verticalCenterOffset: -207
                anchors.horizontalCenterOffset: 90
                echoMode: "Password"
                anchors.centerIn: parent
                placeholderText: "Hasło"
                Keys.onReleased: {regist.pass1 = text}
            }
        }

        Rectangle{
            y: 310
            width: parent.width
            TextField{
                anchors.verticalCenterOffset: -213
                anchors.horizontalCenterOffset: 90
                echoMode: "Password"
                anchors.centerIn: parent
                placeholderText: "Powtórz hasło"
                Keys.onReleased: {regist.pass2 = text}
            }
        }

        Rectangle{
            y: 360
            width: parent.width
            Components.CustomButton{
                x: 300
                y: -200
                onClicked: register();
                contentItemText: "  Zarejestruj się  "
            }
        }

        MenuSeparator {
            x: 250
            y: -33
            width: 6
            height: 158
            z: 1
        }
    }

    Text {
        id: element
        color: appMainColor
        x: 400
        y: 70
        text: "Panel logowania"
        font.pixelSize: 12

        MouseArea{
            anchors.fill: parent
            onClicked: loader.source = "Login.qml";
        }
    }

    Text {
        id: element1
        x: 88
        y: 387
        text: qsTr("* wszystkie pola są wymagane")
        font.pixelSize: 10
    }
}
