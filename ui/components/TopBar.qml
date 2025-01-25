import QtQuick 2.12
import QtQuick.Controls 2.12

Rectangle {
    id: topBar
    width: parent.width
    height: 48
    color: "#80000000"  // 半透明黑色背景
    z: 100  // 确保顶部栏在最上层

    // 1. 左侧：系统状态
    Row {
        id: systemTray
        anchors.left: parent.left
        anchors.leftMargin: 16
        anchors.verticalCenter: parent.verticalCenter
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

    // 2. 中间：时间
    ClockWidget {
        anchors.centerIn: parent
    }

    // 3. 右侧：快捷设置
    Row {
        id: quickSettings
        anchors.right: parent.right
        anchors.rightMargin: 16
        anchors.verticalCenter: parent.verticalCenter
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