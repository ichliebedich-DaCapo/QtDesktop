// modules/AlarmClock/AlarmPage.qml
import QtQuick 2.12
import QtQuick.Controls 2.12

Item {
    property var alarmCtrl
    width: 1024
    height: 600

    Column {
        anchors.fill: parent
        spacing: 0

        // 添加标题占位空间（高度与TabBar一致）
        Item { height: 50 }

        ListView {
            width: parent.width
            height: parent.height - 130  // 留出顶部和底部空间
            model: alarmCtrl.alarms
            clip: true
            delegate: AlarmItemDelegate {
                time: modelData.time
                active: modelData.active
                repeatDays: modelData.repeatDays
                label: modelData.label
                width: ListView.view.width
                onDeleteClicked: alarmCtrl.removeAlarm(index)
                onToggleClicked: alarmCtrl.toggleAlarm(index)
            }
        }

        RoundButton {
            id: addButton
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