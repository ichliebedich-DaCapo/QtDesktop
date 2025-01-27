// AlarmListPage.qml
import QtQuick 2.12
import QtQuick.Controls 2.12

Item {
    property var alarmManager

    Column {
        anchors.fill: parent
        spacing: 10

        ListView {
            width: parent.width
            height: parent.height - addButton.height
            model: alarmManager.alarms
            delegate: AlarmItemDelegate {
                width: ListView.view.width
                onToggle: alarmManager.toggleAlarm(modelData.id, checked)
                onDeleteRequested: alarmManager.removeAlarm(modelData.id)
            }
        }

        Button {
            id: addButton
            text: "添加闹钟"
            width: 200
            height: 60
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: alarmDialog.open()
        }
    }

    AlarmDialog {
        id: alarmDialog
        onAccepted: alarmManager.addAlarm(selectedTime, label)
    }
}