// modules/AlarmClock/ClockPage.qml
import QtQuick 2.12
import QtQuick.Controls 2.12

Item {
    property var alarmCtrl
    width: 1024
    height: 600

    Column {
        anchors.centerIn: parent
        spacing: 30

        Text {
            id: timeText
            text: Qt.formatDateTime(new Date(), "hh:mm")
            font.pixelSize: 80
            anchors.horizontalCenter: parent.horizontalCenter

            Timer {
                interval: 1000
                running: true
                repeat: true
                onTriggered: timeText.text = Qt.formatDateTime(new Date(), "hh:mm")
            }
        }

        Text {
            id: dateText
            text: Qt.formatDateTime(new Date(), "yyyy年MM月dd日 ddd")
            font.pixelSize: 40
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}