import QtQuick 2.12
import QtQuick.Controls 2.12

Item {
    property var alarmCtrl

    Column {
        anchors.centerIn: parent
        spacing: 20

        Text {
            id: timeText
            font.pixelSize: 64
            color: "white"
            text: Qt.formatDateTime(new Date(), "hh:mm:ss")
        }

        Text {
            id: dateText
            font.pixelSize: 32
            color: "white"
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