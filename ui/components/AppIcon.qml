// components/AppIcon.qml
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.12

Item {
    property string icon: "test"  // 图标名称或路径,默认随便指定一个
    property string label // 应用名称
    signal clicked()      // 点击事件

    width: 120
    height: 120  // 增加高度以容纳文本

    Column {
        anchors.centerIn: parent
        spacing: 5

        // 圆角图标
        Rectangle {
            id: iconContainer
            width: 80
            height: 80
            radius: 20
            color: "transparent"
            border.color: "gray"
            border.width: 2

            // 使用 OpacityMask 裁剪图标
            OpacityMask {
                anchors.fill: parent
                source: Image {
                    source:"qrc:/ui/icons/" + icon + ".png"
                    width: iconContainer.width - 10
                    height: iconContainer.height - 10
                    fillMode: Image.PreserveAspectFit
                }
                maskSource: Rectangle {
                    width: iconContainer.width
                    height: iconContainer.height
                    radius: iconContainer.radius
                }
            }

            // 鼠标区域
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    console.log(parent.parent.parent.label)
                    parent.parent.parent.clicked()  // 触发点击信号
                }
            }
        }

        // 应用名称
        Text {
            text: label  // 绑定到label属性
            color: "white"
            font.pixelSize: 14
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}