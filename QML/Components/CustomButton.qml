import QtQuick 2.0
import QtQuick.Controls 2.12

Button {
    x: 387
    y: 30
    topInset: -3
    bottomInset: -3
    leftInset: -3
    rightInset: -3
    property alias contentItemText: content.text

    contentItem: Text{
        id: content
        text: ""
        font.bold: true
        color: appMainColor
    }

    background: Rectangle{
        border.color: appMainColor
        border.width: 2
        color: "#fff"
        radius: 4
    }
}
