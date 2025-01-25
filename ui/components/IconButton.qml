import QtQuick 2.12
import QtQuick.Controls 2.12

Item {
    property string icon
    signal clicked()

    width: 32
    height: 32

    Image {
        anchors.centerIn: parent
        width: 24
        height: 24
        source: icon
    }

    MouseArea {
        anchors.fill: parent
        onClicked: parent.clicked()
    }
}