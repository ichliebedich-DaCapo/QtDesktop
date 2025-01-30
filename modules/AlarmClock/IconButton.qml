import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Button {
    property string iconText: ""

    width: 40
    height: 40
    flat: true

    background: Rectangle {
        color: parent.pressed ? "#dcdde1" : "transparent"
        radius: width/2
    }

    contentItem: Text {
        text: iconText
        font.pixelSize: 24
        color: "#2c3e50"
        anchors.centerIn: parent
    }
}