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

        // 自定义按钮组件
        Rectangle {
            width: 80
            height: 80
            radius: 20
            border.color: "gray"
            border.width: 2
            color: "transparent"

            // 背景矩形（用于点击效果）
            Rectangle {
                id: background
                anchors.fill: parent
                radius: parent.radius
                color: "transparent"
                z: -1

                // 点击动画
                Behavior on color {
                    ColorAnimation {
                        duration: 100
                    }
                }
            }

            // 裁剪容器
            Item {
                anchors.fill: parent
                clip: true

                // 图标
                Image {
                    source: "qrc:/ui/icons/" + parent.parent.parent.parent.icon + ".png"  // 使用qrc路径
                    width: parent.width - 10
                    height: parent.height - 10
                    fillMode: Image.PreserveAspectFit
                    anchors.centerIn: parent

                    // 缩放动画
                    Behavior on scale {
                        NumberAnimation {
                            duration: 100
                        }
                    }
                }
            }

            // 鼠标区域
            MouseArea {
                id: mouseArea
                anchors.fill: parent
                onClicked: {
                    console.log("App icon clicked!")
                }
                onPressed: {
                    background.color = "lightgray"
                    icon.scale = 0.9 // 点击时图标缩小
                }
                onReleased: {
                    background.color = "transparent"
                    icon.scale = 1.0 // 松开时图标恢复
                }
            }
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