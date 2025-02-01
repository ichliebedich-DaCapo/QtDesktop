// modules/AlarmClock/AlarmPage.qml
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
        spacing: 0

        // 标题栏 (固定高度)
        Rectangle {
            id: header
            width: parent.width
            height: 80
            color: "transparent"

            Text {
                text: "我的闹钟"
                font.pixelSize: 36
                color: "#ecf0f1"
                anchors {
                    left: parent.left
                    leftMargin: 40
                    verticalCenter: parent.verticalCenter
                }
            }

            // 底部装饰线
            Rectangle {
                width: parent.width
                height: 2
                color: "#ecf0f1"
                opacity: 0.3
                anchors.bottom: parent.bottom
            }
        }

        // 列表容器 (动态高度)
        Rectangle {
            width: parent.width
            height: parent.height - header.height
            color: "transparent"

            ListView {
                id: listView
                anchors {
                    fill: parent
                    topMargin: 15
                    bottomMargin: 15
                }
                spacing: 15
                clip: true
                model: alarmCtrl.alarms

                delegate: AlarmItemDelegate {
                    width: listView.width - 40
                    anchors.horizontalCenter: parent.horizontalCenter
                    time: modelData.timeStr  // 关键修改点
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

                // 空状态提示
                Label {
                    visible: listView.count === 0
                    text: "点击 + 号添加第一个闹钟"
                    anchors.centerIn: parent
                    font {
                        pixelSize: 24
                        family: "Noto Sans CJK SC"
                    }
                    color: "#95a5a6"
                }
            }
        }
    }

    // 添加按钮
    FloatingActionButton {
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: 20
        }
        onClicked: alarmDialog.open()

    }

    AlarmDialog {
        id: alarmDialog
        onAccepted: alarmCtrl.addAlarm(alarmDialog.time, alarmDialog.repeatDays, alarmDialog.label)
    }
}