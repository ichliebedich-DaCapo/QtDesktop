import QtQuick 2.12
import QtQuick.Controls 2.12

Item {
    property var alarmCtrl

    Column {
        anchors.fill: parent
        spacing: 10

        ListView {
            width: parent.width
            height: parent.height - addButton.height
            model: alarmCtrl.alarms
            delegate: AlarmItemDelegate {
                onToggle: (checked) => alarmCtrl.toggleAlarm(index, checked)
                onRemove: () => alarmCtrl.removeAlarm(index)
            }

            add: Transition {
                NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 300 }
            }

            remove: Transition {
                ParallelAnimation {
                    NumberAnimation { property: "opacity"; to: 0; duration: 300 }
                    NumberAnimation { property: "scale"; to: 0.8; duration: 300 }
                }
            }
        }

        Button {
            id: addButton
            text: qsTr("添加闹钟")
            width: parent.width
            onClicked: alarmDialog.open()
        }
    }

    AlarmDialog {
        id: alarmDialog
        onAccepted: alarmCtrl.addAlarm(
            alarmDialog.selectedHours,
            alarmDialog.selectedMinutes,
            alarmDialog.selectedDays,
            alarmDialog.labelText
        )
    }
}