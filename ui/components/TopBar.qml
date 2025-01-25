import QtQuick 2.12
import QtQuick.Controls 2.12

Rectangle {
    id: topBar
    width: parent.width
    height: 40
    color: "#40000000"  // 半透明黑色背景
    z: 100

    // 1. 左侧：时间
    Text {
        id: clock
        anchors.left: parent.left
        anchors.leftMargin: 16
        anchors.verticalCenter: parent.verticalCenter

        font.pixelSize: 18
        font.bold: true
        text: Qt.formatDateTime(new Date(), "hh:mm:ss")

        // 更新时间
        Timer {
            interval: 1000  // 每秒更新一次
            running: true
            repeat: true
            onTriggered: clock.text = Qt.formatDateTime(new Date(), "hh:mm:ss")
        }
    }

    // 2. 右侧：系统状态和快捷设置
    Row {
        id: rightPanel
        anchors.right: parent.right
        anchors.rightMargin: 16
        anchors.verticalCenter: parent.verticalCenter
        spacing: 12

        // 系统状态
        Row {
            id: systemTray
            spacing: 12

            // CPU温度
            SystemTrayItem {
                icon: "qrc:/ui/icons/cpu.png"
                value: SysMonitor.cpuTemp + "°C"
            }

            // 网络状态
            SystemTrayItem {
                icon: "qrc:/ui/icons/network.png"
                value: SysMonitor.networkStatus
            }

            // 电池状态
            SystemTrayItem {
                icon: "qrc:/ui/icons/battery.png"
                value: SysMonitor.batteryLevel + "%"
            }
        }

        // 快捷设置
        Row {
            id: quickSettings
            spacing: 12

            // 设置按钮
            IconButton {
                icon: "qrc:/ui/icons/settings.png"
                onClicked: settingsMenu.open()
            }

            // 电源按钮
            IconButton {
                icon: "qrc:/ui/icons/power.png"
                onClicked: powerDialog.open()
            }
        }
    }
}