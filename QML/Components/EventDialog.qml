import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls 2.0




Dialog{
    title: "Informacje"
    width: 400
    height: 500
    standardButtons: Dialog.Ok|Dialog.Cancel
    anchors.centerIn: parent
    property alias _id: _id.text
    property alias _title_: _title.text
    property alias description: _description.text
    property alias addTime: _addTime.text
    property alias eventTime: _eventTime.text
    property alias category: _category.text
    property alias author: _author.text
    property alias deleteButton: _deleteButton.visible




    MenuSeparator{
        width: parent.width
    }

    Rectangle{
        width: parent.width
        y: 23
        Text{
            id: _title
            text: ""
            font.pixelSize: 20
            anchors.centerIn: parent
        }
    }

    Rectangle{
        width: parent.width
        height: 100
        y: 70
        Text{
            id: _description
            text: ""
        }
    }

    MenuSeparator{
        y: 180
        width: parent.width
    }

    Rectangle{
        y: 300
        x: 250
        Text{
            color: "#444"
            id: _addTime
            text: ""
        }
    }

    Rectangle{
        y: 190
        x: 280
        Label{
            x: -25
            y: -3
            text: "\uD83D\uDCC5"
        }

        Text{
            id: _eventTime
            text: ""
        }
    }

    Text{
        y: 190
        x: 13
        Label{
            x: -13
            y: -8
            text: "\u232F"
            font.pixelSize: 18
        }

        id: _category
        text: ""
    }

    Text{
        y: 215
        x: 8
        id: _author
        text: ""
    }

    Rectangle{
        y: 300
        Label{
            text: "ID: "
        }
        Text{
            color: "#444"
            id: _id
            text: ""
            x: 20
        }
    }

    CustomButton{
        id: _deleteButton
        y: 320
        x: 250
        visible: false
        contentItem: Text{
            id: content
            text: "  Usuń  "
            font.bold: true
            color: "red"
        }
        background: Rectangle{
            border.color: "red"
            border.width: 2
            color: "#fff"
            radius: 4
        }
        onClicked: deleteEvent(parseInt(_id.text));
    }
}
