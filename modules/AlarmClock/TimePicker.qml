// TimePicker.qml
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

RowLayout {
    // 定义 time 属性，绑定到 timeEdit.time
    property alias time: timeEdit.time

    // 小时选择器
    SpinBox {
        id: hourBox
        from: 0
        to: 23
        value: 12
        onValueChanged: timeEdit.hour = value
    }

    Label {
        text: ":"
    }

    // 分钟选择器
    SpinBox {
        id: minuteBox
        from: 0
        to: 59
        value: 0
        onValueChanged: timeEdit.minute = value
    }

    // TimeEdit 组件，用于管理时间
    TimeEdit {
        id: timeEdit
        hour: hourBox.value
        minute: minuteBox.value
    }
}