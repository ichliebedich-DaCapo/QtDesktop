import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Dialog {
    id: dialog
    title: "添加闹钟"
    standardButtons: Dialog.Ok | Dialog.Cancel
    width: 600
    height: 500

    // 自定义属性存储时间
    property int selectedHour: 8
    property int selectedMinute: 0
    property string time: ""
    property string label: ""
    property var repeatDays: []

    // 现代配色
    property color backgroundColor: "#2c3e50"
    property color cardColor: "#ecf0f1"
    property color primaryColor: "#3498db"

    // 自定义背景
    background: Rectangle {
        color: backgroundColor
        radius: 8
    }

    // 时间设置卡片
    contentItem: Rectangle {
        color: "transparent"
        implicitHeight: contentLayout.implicitHeight

        ColumnLayout {
            id: contentLayout
            width: parent.width
            spacing: 20

            // 标签输入
            TextField {
                id: labelField
                placeholderText: "闹钟标签（可选）"
                Layout.fillWidth: true
                Layout.preferredHeight: 60
                font.pixelSize: 20
                color: "#2c3e50"
                background: Rectangle {
                    color: cardColor
                    radius: 8
                }
                onTextChanged: dialog.label = text
            }

            // 时间选择器
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 200  // 增加高度适应滑动选择器
                color: cardColor
                radius: 8

                RowLayout {
                    anchors.fill: parent
                    spacing: 20
                    anchors.margins: 15

                    // 小时滑动选择
                    ColumnLayout {
                        spacing: 5
                        Layout.alignment: Qt.AlignHCenter

                        Label {
                            text: "小时"
                            color: "#2c3e50"
                            font.bold: true
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Tumbler {
                            id: hourTumbler
                            model: 24
                            visibleItemCount: 5
                            Layout.preferredWidth: 150
                            Layout.preferredHeight: 160

                            delegate: Text {
                                text: modelData
                                color: "#2c3e50"
                                font.pixelSize: 28
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                opacity: 0.4 + Math.max(0, 1 - Math.abs(Tumbler.displacement))
                                scale: 0.8 + Math.max(0, 1 - Math.abs(Tumbler.displacement)) * 0.4
                            }

                            onCurrentIndexChanged: {
                                dialog.selectedHour = currentIndex
                                dialog.updateTime()
                            }

                            // 添加滑动指示线
                            Rectangle {
                                parent: hourTumbler
                                anchors.horizontalCenter: parent.horizontalCenter
                                y: parent.height * 0.4
                                width: parent.width - 20
                                height: 2
                                color: primaryColor
                            }

                            Rectangle {
                                parent: hourTumbler
                                anchors.horizontalCenter: parent.horizontalCenter
                                y: parent.height * 0.6
                                width: parent.width - 20
                                height: 2
                                color: primaryColor
                            }
                        }
                    }

                    // 分钟滑动选择
                    ColumnLayout {
                        spacing: 5
                        Layout.alignment: Qt.AlignHCenter

                        Label {
                            text: "分钟"
                            color: "#2c3e50"
                            font.bold: true
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Tumbler {
                            id: minuteTumbler
                            model: 60
                            visibleItemCount: 5
                            Layout.preferredWidth: 150
                            Layout.preferredHeight: 160

                            delegate: Text {
                                text: modelData
                                color: "#2c3e50"
                                font.pixelSize: 28
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                opacity: 0.4 + Math.max(0, 1 - Math.abs(Tumbler.displacement))
                                scale: 0.8 + Math.max(0, 1 - Math.abs(Tumbler.displacement)) * 0.4
                            }

                            onCurrentIndexChanged: {
                                dialog.selectedMinute = currentIndex
                                dialog.updateTime()
                            }

                            // 添加滑动指示线
                            Rectangle {
                                parent: minuteTumbler
                                anchors.horizontalCenter: parent.horizontalCenter
                                y: parent.height * 0.4
                                width: parent.width - 20
                                height: 2
                                color: primaryColor
                            }

                            Rectangle {
                                parent: minuteTumbler
                                anchors.horizontalCenter: parent.horizontalCenter
                                y: parent.height * 0.6
                                width: parent.width - 20
                                height: 2
                                color: primaryColor
                            }
                        }
                    }
                }
            }

            // 日期选择
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 10

                Label {
                    text: "重复"
                    font.bold: true
                    color: cardColor
                }

                RowLayout {
                    spacing: 8
                    Repeater {
                        model: 7
                        DayToggle {
                            dayIndex: index
                            onToggled: dialog.updateRepeatDays(index, isChecked)
                        }
                    }
                }
            }
        }
    }

    // 更新最终时间字符串
    function updateTime() {
        // dialog.time = Qt.formatTime(new Date(0, 0, 0,
        //     selectedHour,
        //     selectedMinute), "hh:mm")

        const hours = selectedHour.toString().padStart(2, '0')
        const minutes = selectedMinute.toString().padStart(2, '0')
        dialog.time = `${hours}:${minutes}`
    }

    // 更新重复日期
    function updateRepeatDays(index, checked) {
        if (checked && !dialog.repeatDays.includes(index)) {
            dialog.repeatDays.push(index)
        } else {
            const pos = dialog.repeatDays.indexOf(index)
            if (pos >= 0) dialog.repeatDays.splice(pos, 1)
        }
        // console.log("当前重复日:", dialog.repeatDays)
    }
}