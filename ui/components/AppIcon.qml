// components/AppIcon.qml
import QtQuick 2.12
import QtQuick.Controls 2.12

Item {
    property string icon  // 图标名称或路径
    property string label // 应用名称
    signal clicked()      // 点击事件

    width: 120
    height: 120  // 增加高度以容纳文本

    Column {
        anchors.centerIn: parent
        spacing: 5

        // 图标
        Button {
            width: 64
            height: 64
            icon.name: parent.parent.icon  // 绑定到icon属性
            onClicked: parent.parent.clicked()
        }

        // 应用名称
        Text {
            text: parent.parent.label  // 绑定到label属性
            color: "white"
            font.pixelSize: 14
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}