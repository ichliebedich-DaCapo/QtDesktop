// components/ClockWidget.qml
import QtQuick 2.12
import QtQuick.Controls 2.12

Rectangle {
    width: 200
    height: 200
    color: "#1abc9c"
    radius: 10

    Text {
        anchors.centerIn: parent
        text: new Date().toLocaleTimeString(Qt.locale(), "hh:mm:ss")
        font.pixelSize: 24
        color: "white"

        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: parent.text = new Date().toLocaleTimeString(Qt.locale(), "hh:mm:ss")
        }
    }
}