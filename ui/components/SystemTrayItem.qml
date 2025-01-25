import QtQuick 2.12
import QtQuick.Controls 2.12

Item {
    property string icon
    property string value

    width: 80
    height: 32

    Row {
        spacing: 6
        anchors.centerIn: parent

        // 图标
        Image {
            width: 24
            height: 24
            source: icon
        }

        // 数值
        Text {
            text: value
            color: "white"
            font.pixelSize: 14
            verticalAlignment: Text.AlignVCenter
        }
    }
}