// modules/Calculator/CalcButton.qml
import QtQuick 2.12
import QtQuick.Controls 2.12

Button {
    property alias radius: background.radius
    property alias backgroundColor: background.color

    contentItem: Text {
        text: parent.text
        font.pixelSize: 24
        color: "white"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    background: Rectangle {
        id: background
        radius: height / 2
        color: parent.down ? "#34495e" : "#2c3e50"
        border.color: "#1abc9c"
        border.width: 2
    }
}