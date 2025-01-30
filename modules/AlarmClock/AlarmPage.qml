// AlarmPage.qml 优化版
import QtQuick 2.12
import QtQuick.Controls 2.12

Item {
    property var alarmCtrl
    width: 1024
    height: 600

    // 背景渐变
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#2c3e50" }
            GradientStop { position: 1.0; color: "#3498db" }
        }
    }

    Column {
        anchors.fill: parent
        spacing: 15

        // 标题栏
        Text {
            text: "我的闹钟"
            font.pixelSize: 36
            color: "#ecf0f1"
            leftPadding: 40
            topPadding: 20
        }

        // 闹钟列表
        ListView {
            id: listView
            width: parent.width
            height: parent.height - 140
            spacing: 15
            clip: true
            model: alarmCtrl.alarms

            delegate: AlarmItemDelegate {
                width: listView.width - 40
                anchors.horizontalCenter: parent.horizontalCenter
                time: alarmCtrl.formatTime(modelData.time)
                active: modelData.active
                repeatDays: modelData.repeatDays
                label: modelData.label
                onDeleteClicked: alarmCtrl.removeAlarm(index)
                onToggleClicked: alarmCtrl.toggleAlarm(index)
            }

            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AlwaysOn
                width: 8
                contentItem: Rectangle {
                    color: "#80ecf0f1"
                    radius: 4
                }
            }
        }

        // 添加按钮
        FloatingActionButton {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            onClicked: alarmDialog.open()
        }
    }

    AlarmDialog {
        id: alarmDialog
        onAccepted: alarmCtrl.addAlarm(time, repeatDays, label)
    }
}