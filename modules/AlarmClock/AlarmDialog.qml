import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Dialog {
    id: dialog
    title: "添加闹钟"
    standardButtons: Dialog.Ok | Dialog.Cancel
    width: 600
    height: 500

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
                        currentValue: 8
                        onValueChanged: hourSpinBox.value = value
                    }

                    // 分钟选择
                    TimeAdjuster {
                        Layout.columnSpan: 3
                        Layout.fillWidth: true
                        title: "分钟"
                        minValue: 0
                        maxValue: 55
                        step: 5
                        currentValue: 0
                        onValueChanged: minuteSpinBox.value = value
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
                            onToggled: updateRepeatDays(index, isChecked)
                        }
                    }
                }
            }
        }
    }

    // 隐藏原生SpinBox
    SpinBox { id: hourSpinBox; visible: false }
    SpinBox { id: minuteSpinBox; visible: false }

    // 定义时间属性
    property string time: ""
    property string label: ""
    property var repeatDays: []

    function updateTime() {
        const hours = hourSpinBox.value.toString().padStart(2, '0')
        const minutes = minuteSpinBox.value.toString().padStart(2, '0')
        dialog.time = `${hours}:${minutes}`
    }

    function updateRepeatDays(index, checked) {
        if (checked && !dialog.repeatDays.includes(index)) {
            dialog.repeatDays.push(index)
        } else {
            const pos = dialog.repeatDays.indexOf(index)
            if (pos >= 0) dialog.repeatDays.splice(pos, 1)
        }
    }

    Connections {
        target: dialog
        function onAccepted() {
            console.log("Time:", dialog.time)
            console.log("Label:", dialog.label)
            console.log("Repeat Days:", dialog.repeatDays)
            // 在这里可以添加保存闹钟的逻辑
        }
    }

    // 自定义组件
    component TimeAdjuster: ColumnLayout {
        property string title: ""
        property int minValue: 0
        property int maxValue: 59
        property int step: 1
        property int currentValue: 0
        signal valueChanged(int value)

        spacing: 5

        Label {
            text: title
            font.pixelSize: 16
            color: "#7f8c8d"
            Layout.alignment: Qt.AlignHCenter
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 15

            IconButton {
                iconText: "-"
                onClicked: adjustValue(-step)
            }

            Text {
                text: currentValue.toString().padStart(2, '0')
                font.pixelSize: 32
                color: "#2c3e50"
            }

            IconButton {
                iconText: "+"
                onClicked: adjustValue(step)
            }
        }

        function adjustValue(step) {
            currentValue += step
            currentValue = Math.max(minValue, Math.min(currentValue, maxValue))
            valueChanged(currentValue)
            updateTime()
        }
    }

    component DayToggle: Button {
        property int dayIndex: 0
        property bool isChecked: false
        signal toggled(bool checked)

        width: 40
        height: 40
        checkable: true
        text: ["一","二","三","四","五","六","日"][dayIndex]

        background: Rectangle {
            color: isChecked ? primaryColor : "#bdc3c7"
            radius: 5
        }

        contentItem: Text {
            text: parent.text
            color: "white"
            font.pixelSize: 16
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        onClicked: {
            isChecked = !isChecked
            toggled(isChecked)
        }
    }

    component IconButton: Button {
        property string iconText: ""

        width: 40
        height: 40
        flat: true

        background: Rectangle {
            color: parent.pressed ? "#dcdde1" : "transparent"
            radius: width/2
        }

        contentItem: Text {
            text: iconText
            font.pixelSize: 24
            color: "#2c3e50"
            anchors.centerIn: parent
        }
    }
}



