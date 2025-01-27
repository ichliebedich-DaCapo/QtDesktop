// AlarmDialog.qml
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Dialog {
    id: dialog
    title: "添加闹钟"
    modal: true
    standardButtons: Dialog.Ok | Dialog.Cancel

    property alias selectedTime: timePicker.time
    property alias label: labelField.text

    ColumnLayout {
        anchors.fill: parent

        Label {
            text: "时间:"
        }

        // 时间选择器
        TimePicker {
            id: timePicker
            Layout.fillWidth: true
        }

        Label {
            text: "标签:"
        }

        // 标签输入框
        TextField {
            id: labelField
            placeholderText: "闹钟标签"
            Layout.fillWidth: true
        }
    }

    onAccepted: {
        console.log("闹钟添加:", selectedTime, label);
    }
}