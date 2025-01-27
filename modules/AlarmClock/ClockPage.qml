// ClockPage.qml
import QtQuick 2.12
import QtQuick.Controls 2.12

Item {
    property var alarmManager

    width: parent.width
    height: parent.height

    Rectangle {
        anchors.fill: parent
        color: "lightgray" // 背景颜色
    }

    Column {
        anchors.centerIn: parent
        spacing: 20

        Text {
            id: timeText
            font.pixelSize: 80
            color: "black" // 字体颜色
            text: Qt.formatDateTime(new Date(), "hh:mm:ss")
        }

        Text {
            id: dateText
            font.pixelSize: 40
            color: "black" // 字体颜色
            text: Qt.formatDateTime(new Date(), "yyyy-MM-dd dddd")
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            timeText.text = Qt.formatDateTime(new Date(), "hh:mm:ss")
            dateText.text = Qt.formatDateTime(new Date(), "yyyy-MM-dd dddd")
        }
    }
}