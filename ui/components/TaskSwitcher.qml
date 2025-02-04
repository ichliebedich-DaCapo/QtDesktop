// ui/components/TaskSwitcher.qml
import QtQuick 2.12
import QtQuick.Controls 2.12

Rectangle {
    id: root
    visible: false
    color: "#80000000" // 半透明黑色背景
    z: 9998  // 确保在悬浮按钮之下

    property ListModel appModel

    signal closeApp(string appPath)  // 关闭应用信号
    signal exitSwitcher()            // 退出任务切换器信号
    signal appClicked(string appPath) // 点击卡片信号
    signal clearAllApps()            // 新增：清除所有后台应用信号

    // 横向应用列表
    ListView {
        id: listView
        anchors {
            top: parent.top
            bottom: clearButton.top // 调整底部锚点，为按钮留出空间
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
                onClicked: {
                    root.appClicked(appPath) // 触发点击信号
                }
            }

            // 关闭动画
            SequentialAnimation {
                id: closeAnimation
                NumberAnimation {
                    target: card
                    property: "opacity"
                    to: 0
                    duration: 200
                }
                NumberAnimation {
                    target: card
                    property: "y"
                    to: card.y - card.height
                    duration: 200
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

    // 清除所有后台应用的按钮
    Rectangle {
        id: clearButton
        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
            bottomMargin: 20
        }
        width: 60
        height: 60
        radius: width / 2
        color: "#ff4444"
        border.color: "#cc0000"
        border.width: 2
        opacity: 0.9
        z: 1 // 确保按钮位于顶部

        Text {
            anchors.centerIn: parent
            text: "×"
            font.pixelSize: 36
            color: "white"
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                // console.log("清除按钮被点击！"); // 调试输出
                root.clearAllApps()
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