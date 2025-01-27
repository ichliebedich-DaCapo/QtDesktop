// TimeEdit.qml
import QtQuick 2.12

Item {
    property int hour: 0
    property int minute: 0
    property var time: Qt.formatTime(new Date(0, 0, 0, hour, minute), "hh:mm")
}