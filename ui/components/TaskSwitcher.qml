// ui/components/TaskSwitcher.qml
import QtQuick 2.12
import QtQuick.Controls 2.12

Rectangle {
    id: root
    visible: false
    color: "#80000000"
    z: 9998  // 确保在悬浮按钮之下

    property ListModel appModel

    signal closeApp(string appPath)
    signal exitSwitcher()

    // 横向应用列表
    ListView {
        id: listView
        anchors {
            top: parent.top
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
        }
        width: Math.min(parent.width, contentWidth)
        spacing: 20
        orientation: ListView.Horizontal
        model: appModel

        delegate: Rectangle {
            id: card
            width: 280
            height: 400
            color: "white"
            radius: 10

            property real startY: 0
            property bool isClosing: false

            Column {
                anchors.centerIn: parent
                spacing: 10
                Text { text: appName; font.bold: true }
                Text { text: "上滑关闭" }
            }

            // 关闭手势检测
            MouseArea {
                anchors.fill: parent
                onPressed: card.startY = mouseY
                onPositionChanged: {
                    if (mouseY < card.startY - 30) {
                        card.opacity = 0.5
                    }
                }
                onReleased: {
                    if (mouseY < card.startY - 50) {
                        card.isClosing = true
                        closeAnimation.start()
                    } else {
                        card.opacity = 1
                    }
                }
            }

            // 关闭动画
            SequentialAnimation {
                id: closeAnimation
                NumberAnimation {
                    target: card
                    property: "opacity"
                    to: 0
                    duration: 100
                }
                NumberAnimation {
                    target: card
                    property: "y"
                    to: card.y - card.height
                    duration: 100
                }
                ScriptAction {
                    script: {
                        if (index >= 0 && index < appModel.count) { // 检查索引是否有效
                            root.closeApp(appPath) // 触发关闭信号
                            appModel.remove(index) // 从模型中移除该项
                        }
                    }
                }
            }
        }
    }

    // 退出任务切换器手势区域
    MouseArea {
        anchors.bottom: parent.bottom
        height: 100
        width: parent.width
        property real _localStartY: 0 // 改为局部变量

        onPressed: _localStartY = mouseY
        onPositionChanged: {
            if (mouseY < _localStartY - 50) {
                root.exitSwitcher()
            }
        }
    }

    Behavior on opacity {
        NumberAnimation { duration: 200 }
    }
}