// AlarmItemDelegate.qml
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Item {
    property alias checked: switchControl.checked
    signal toggle(bool checked)
    signal deleteRequested()

    RowLayout {
        width: parent.width
        spacing: 20

        // 显示闹钟时间
        Text {
            text: modelData.time // 确保 modelData.time 存在
            font.pixelSize: 40
            color: "white"
        }

        // 显示闹钟名称
        Text {
            text: modelData.label || "未命名" // 如果 modelData.label 未定义，显示默认值
            font.pixelSize: 40
            color: "white"
        }

        // 开关控件
        Switch {
            id: switchControl
            onCheckedChanged: toggle(checked)
        }

        // 删除按钮
        Button {
            text: "删除"
            onClicked: deleteRequested()
        }
    }
}