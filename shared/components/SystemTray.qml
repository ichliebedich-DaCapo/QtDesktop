// components/SystemTray.qml

Item {
    id: tray
    height: 30

    Row {
        spacing: 15
        anchors.right: parent.right

        // 电池指示器
        Rectangle {
            width: 40; height: 20
            color: "transparent"
            border.color: "#666"

            Rectangle {
                width: (parent.width-4) * SysTray.batteryLevel / 100
                height: parent.height-4
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 2
                color: SysTray.batteryLevel < 20 ? "red" : "#6c5ce7"
            }

            Text {
                text: SysTray.batteryLevel + "%"
                anchors.centerIn: parent
                font.pixelSize: 10
            }
        }

        // 网络状态
        Text {
            text: SysTray.networkStatus
            color: "#2d3436"
            font { family: "Material Icons"; pixelSize: 18 }
        }
    }
}