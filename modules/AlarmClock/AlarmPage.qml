// modules/AlarmClock/AlarmPage.qml
import QtQuick 2.12
import QtQuick.Controls 2.12

Item {
    property var alarmCtrl
    width: 1024
    height: 600

    Column {
        anchors.fill: parent
        spacing: 20

        ListView {
            width: parent.width
            height: parent.height - 80
            model: alarmCtrl.alarms
            delegate: AlarmItemDelegate {
                width: ListView.view.width
                onDeleteClicked: alarmCtrl.removeAlarm(index)
                onToggleClicked: alarmCtrl.toggleAlarm(index)
            }
        }

        RoundButton {
            text: "+"
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: alarmDialog.open()
        }
    }

    AlarmDialog {
        id: alarmDialog
        onAccepted: alarmCtrl.addAlarm(time, repeatDays, label)
    }
}