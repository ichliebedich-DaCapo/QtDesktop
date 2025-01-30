// ClockPage.qml 优化版
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.12

Item {
    property var alarmCtrl
    width: 1024
    height: 600

    // 现代渐变背景
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#2c3e50" }
            GradientStop { position: 1.0; color: "#3498db" }
        }
    }

    Column {
        anchors.centerIn: parent
        spacing: 40

        // 时间显示卡片
        Rectangle {
            id: timeCard
            width: 700
            height: 200
            radius: 20
            color: "#ecf0f1"


            Text {
                id: timeText
                anchors.centerIn: parent
                text: Qt.formatDateTime(new Date(), "hh:mm")
                font {
                    pixelSize: 120
                    family: "Roboto Condensed"
                    weight: Font.Light
                }
                color: "#2c3e50"

                Timer {
                    interval: 1000
                    running: true
                    repeat: true
                    onTriggered: {
                        timeText.opacity = 0
                        timeText.text = Qt.formatDateTime(new Date(), "hh:mm")
                        timeText.opacity = 1
                    }
                }

                Behavior on opacity {
                    NumberAnimation { duration: 300 }
                }
            }
        }

        // 日期信息
        Column {
            spacing: 15
            anchors.horizontalCenter: parent.horizontalCenter

            Text {
                text: Qt.formatDateTime(new Date(), "yyyy年MM月dd日")
                font {
                    pixelSize: 32
                    family: "Noto Sans CJK SC"
                    weight: Font.Medium
                }
                color: "#ecf0f1"
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Rectangle {
                width: 300
                height: 2
                color: "#ecf0f1"
                opacity: 0.5
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Row {
                spacing: 20
                anchors.horizontalCenter: parent.horizontalCenter

                Text {
                    text: Qt.formatDateTime(new Date(), "dddd")
                    font {
                        pixelSize: 28
                        family: "Noto Sans CJK SC"
                        weight: Font.Normal
                    }
                    color: "#ecf0f1"
                }

                Text {
                    text: "|"
                    font.pixelSize: 28
                    color: "#ecf0f1"
                    opacity: 0.5
                }

                Text {
                    text: "晴 25°C" // 可连接实际天气接口
                    font {
                        pixelSize: 28
                        family: "Noto Sans CJK SC"
                        weight: Font.Normal
                    }
                    color: "#ecf0f1"
                }
            }
        }
    }
}