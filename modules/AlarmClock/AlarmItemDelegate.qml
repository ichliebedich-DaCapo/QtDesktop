// AlarmItemDelegate.qml 优化版（仅使用内置组件）
import QtQuick 2.12
import QtQuick.Controls 2.12

Item {
    property alias time: timeText.text
    property bool active: true
    property var repeatDays: []
    property string label: ""

    signal deleteClicked()
    signal toggleClicked()

    height: 120

    // 卡片背景
    Rectangle {
        id: card
        anchors.fill: parent
        radius: 16
        color: "#ecf0f1"
    }

    Row {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 30
        layoutDirection: Qt.LeftToRight

        // 开关控制（使用原生Switch）
        Switch {
            id: toggle
            checked: active
            onToggled: toggleClicked()
            anchors.verticalCenter: parent.verticalCenter

            // 自定义Switch样式
            indicator: Rectangle {
                implicitWidth: 48
                implicitHeight: 28
                radius: 14
                color: toggle.checked ? "#3498db" : "#bdc3c7"

                Rectangle {
                    x: toggle.checked ? parent.width - width - 2 : 2
                    width: 24
                    height: 24
                    radius: 12
                    color: "white"
                    anchors.verticalCenter: parent.verticalCenter
                    Behavior on x { NumberAnimation { duration: 100 } }
                }
            }
        }

        // 时间信息列
        Column {
            spacing: 8
            anchors.verticalCenter: parent.verticalCenter
            width: 200

            Text {
                id: timeText
                text: ""
                font {
                    pixelSize: 48
                    family: "Roboto Condensed"
                    weight: Font.Light
                }
                color: "#2c3e50"
            }

            Text {
                visible: label.length > 0
                text: label
                font {
                    pixelSize: 24
                    family: "Noto Sans CJK SC"
                }
                color: "#7f8c8d"
            }
        }

        // 重复日期指示
        Row {
            spacing: 10
            anchors.verticalCenter: parent.verticalCenter
            visible: repeatDays.length > 0

            Repeater {
                model: 7

                Rectangle {
                    width: 30
                    height: 30
                    radius: 15
                    color: repeatDays.includes(index) ? "#e74c3c" : "#bdc3c7"

                    Text {
                        text: ["一", "二", "三", "四", "五", "六", "日"][index]
                        font {
                            pixelSize: 14
                            bold: repeatDays.includes(index)
                        }
                        color: "white"
                        anchors.centerIn: parent
                    }
                }
            }
        }

        // 删除按钮（纯QML实现）
        Rectangle {
            width: 40
            height: 40
            radius: 20
            color: mouseArea.pressed ? "#e74c3c" : "transparent"
            anchors.verticalCenter: parent.verticalCenter

            Text {
                text: "×"
                font.pixelSize: 32
                color: "#e74c3c"
                anchors.centerIn: parent
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                onClicked: deleteClicked()
            }
        }
    }

    // 悬停效果
    HoverHandler {
        onHoveredChanged: {
            card.scale = hovered ? 1.02 : 1.0
        }
    }

    Behavior on scale {
        NumberAnimation { duration: 150 }
    }
}