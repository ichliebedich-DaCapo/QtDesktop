// modules/AlarmClock/AlarmDialog.qml
import QtQuick 2.12
import QtQuick.Controls 2.12

Dialog {
    id: dialog
    title: "添加闹钟"
    standardButtons: Dialog.Ok | Dialog.Cancel

    property string time: "08:00"
    property var repeatDays: []
    property string label: ""

    Column {
        spacing: 15

        TextField {
            id: labelField
            placeholderText: "标签"
            onTextChanged: dialog.label = text
        }

        // 时间选择器部分
        Row {
            spacing: 10
            SpinBox {
                id: hourSpinBox
                from: 0
                to: 23
                value: 8
                onValueChanged: updateTime()
            }

            SpinBox {
                id: minuteSpinBox
                from: 0
                to: 59
                stepSize: 1  // 明确步进值
                value: 0
                onValueChanged: updateTime()
            }
        }

        Flow {
            spacing: 10
            Repeater {
                model: 7
                CheckDelegate {
                    text: ["一","二","三","四","五","六","日"][index]
                    checked: false
                    onToggled: updateRepeatDays(index, checked)
                }
            }
        }
    }

    // modules/AlarmClock/AlarmDialog.qml
    function updateTime() {
        // 简化后的时间更新逻辑
        time = Qt.formatTime(new Date(0,0,0,
            hourSpinBox.value,
            minuteSpinBox.value), "hh:mm")
    }

    function updateRepeatDays(index, checked) {
        if(checked && !repeatDays.includes(index))
            repeatDays.push(index)
        else
            repeatDays.splice(repeatDays.indexOf(index), 1)
    }
}