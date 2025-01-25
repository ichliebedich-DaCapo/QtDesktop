// components/GalleryWidget.qml
import QtQuick 2.12
import QtQuick.Controls 2.12

Rectangle {
    width: 300
    height: 300
    color: "#3498db"
    radius: 10

    ListView {
        anchors.fill: parent
        model: ["Image1", "Image2", "Image3"]
        delegate: Text {
            text: modelData
            font.pixelSize: 18
            color: "white"
            padding: 10
        }
    }
}