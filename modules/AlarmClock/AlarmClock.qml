// AlarmClock.qml 优化版
import QtQuick 2.12
import QtQuick.Controls 2.12
import AlarmClock 1.0

Item {
    id: root
    width: 1024
    height: 600
    property var params: {}
    property var mainWindow: null

    // 现代配色方案
    readonly property color primaryColor: "#3498db"
    readonly property color backgroundColor: "#2c3e50"
    readonly property color cardColor: "#ecf0f1"

    Rectangle {
        anchors.fill: parent
        color: backgroundColor
    }

    TabBar {
        id: tabBar
        width: parent.width
        height: 70
        position: TabBar.Header
        currentIndex: swipeView.currentIndex
        background: Rectangle {
            color: primaryColor
        }

        Repeater {
            model: ["时钟", "闹钟"]

            TabButton {
                text: modelData
                width: tabBar.width / 2
                height: tabBar.height


                contentItem: Text {
                    text: modelData
                    color: parent.checked ? cardColor : Qt.darker(cardColor, 1.2)
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 22  // 增加字体大小
                }

                background: Rectangle {
                    color: parent.checked ? Qt.darker(primaryColor, 1.2) : "transparent"
                    Rectangle {
                        width: parent.width
                        height: 4
                        color: cardColor
                        visible: parent.parent.checked
                        anchors.bottom: parent.bottom
                    }
                }

                HoverHandler {
                    onHoveredChanged: {
                        parent.opacity = hovered ? 0.8 : 1.0
                    }
                }
            }
        }
    }

    SwipeView {
        id: swipeView
        anchors {
            top: tabBar.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
        currentIndex: tabBar.currentIndex
        interactive: true

        ClockPage { alarmCtrl: alarmClockCtrl }
        AlarmPage { alarmCtrl: alarmClockCtrl }
    }

    AlarmClockCtrl { id: alarmClockCtrl }
}