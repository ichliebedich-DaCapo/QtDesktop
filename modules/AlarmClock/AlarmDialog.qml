import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Dialog {
    id: dialog
    title: "添加闹钟"
    standardButtons: Dialog.Ok | Dialog.Cancel
    width: 600
    height: 500

    // 自定义属性存储时间
    property int selectedHour: 8
    property int selectedMinute: 0
    property string time: ""
    property string label: ""
    property var repeatDays: []

    // 现代配色
    property color backgroundColor: "#2c3e50"
    property color cardColor: "#ecf0f1"
    property color primaryColor: "#3498db"

    // 自定义背景
    background: Rectangle {
        color: backgroundColor
        radius: 8
    }

    // 时间设置卡片
    contentItem: Rectangle {
        color: "transparent"
        implicitHeight: contentLayout.implicitHeight

        ColumnLayout {
            id: contentLayout
            width: parent.width
            spacing: 20

            // 标签输入
            TextField {
                id: labelField
                placeholderText: "闹钟标签（可选）"
                Layout.fillWidth: true
                Layout.preferredHeight: 60
                font.pixelSize: 20
                color: "#2c3e50"
                background: Rectangle {
                    color: cardColor
                    radius: 8
                }
                onTextChanged: dialog.label = text
            }

            // 时间选择器
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 180
                color: cardColor
                radius: 8

                GridLayout {
                    anchors.fill: parent
                    anchors.margins: 20
                    columns: 3
                    rows: 2
                    rowSpacing: 15
                    columnSpacing: 15

                    // 小时选择
                    TimeAdjuster {
                        Layout.columnSpan: 3
                        Layout.fillWidth: true
                        title: "小时"
                        minValue: 0
                        maxValue: 23
                        currentValue: dialog.selectedHour  // 绑定到自定义属性
                        onValueChanged: {
                            dialog.selectedHour = value    // 直接更新属性
                            dialog.updateTime()
                        }
                    }

                    // 分钟选择
                    TimeAdjuster {
                        Layout.columnSpan: 3
                        Layout.fillWidth: true
                        title: "分钟"
                        minValue: 0
                        maxValue: 55
                        step: 5
                        currentValue: dialog.selectedMinute
                        onValueChanged: {
                            dialog.selectedMinute = value
                            dialog.updateTime()
                        }
                    }
                }
            }

            // 日期选择
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 10

                Label {
                    text: "重复"
                    font.bold: true
                    color: cardColor
                }

                RowLayout {
                    spacing: 8
                    Repeater {
                        model: 7
                        DayToggle {
                            dayIndex: index
                            onToggled: dialog.updateRepeatDays(index, isChecked)
                        }
                    }
                }
            }
        }
    }

    // 更新最终时间字符串
    function updateTime() {
        dialog.time = Qt.formatTime(new Date(0, 0, 0,
            selectedHour,
            selectedMinute), "hh:mm")
        console.log("当前设置时间:", dialog.time)
    }

    // 更新重复日期
    function updateRepeatDays(index, checked) {
        if (checked && !dialog.repeatDays.includes(index)) {
            dialog.repeatDays.push(index)
        } else {
            const pos = dialog.repeatDays.indexOf(index)
            if (pos >= 0) dialog.repeatDays.splice(pos, 1)
        }
        console.log("当前重复日:", dialog.repeatDays)
    }
}