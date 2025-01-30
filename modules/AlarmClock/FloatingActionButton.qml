// FloatingActionButton.qml
import QtQuick 2.12
import QtQuick.Controls 2.12

RoundButton {
    width: 64
    height: 64
    text: "+"
    font.pixelSize: 32

    background: Rectangle {
        radius: width/2
        color: "#e74c3c"

        Rectangle {
            anchors.fill: parent
            radius: width/2
            color: parent.color
            opacity: parent.pressed ? 0.2 : 0
        }
    }


    Behavior on scale {
        NumberAnimation { duration: 150 }
    }
}