// AlarmItemDelegate.qml
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Item {
    property alias checked: switchControl.checked
    signal toggle(bool checked)  // 用于切换闹钟状态
    signal deleteRequested()     // 修改信号名称，避免使用关键字

    RowLayout {
        width: parent.width
        spacing: 20

        // 显示闹钟时间
        Text {
            text: model.time
            font.pixelSize: 40
            color: "white"
        }

        // 开关控件
        Switch {
            id: switchControl
            onCheckedChanged: toggle(checked)  // 触发 toggle 信号
        }

        // 删除按钮
        Button {
            text: "删除"
            onClicked: deleteRequested()  // 触发 deleteRequested 信号
        }
    }
}