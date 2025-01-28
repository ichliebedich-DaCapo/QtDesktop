// modules/AlarmClock/AlarmItemDelegate.qml
import QtQuick 2.12
import QtQuick.Controls 2.12

Item {
    property alias time: timeText.text
    property bool active: true
    property var repeatDays: []
    property string label: ""

    signal deleteClicked()
    signal toggleClicked()

    height: 80

    Row {
        spacing: 20
        anchors.fill: parent
        anchors.margins: 10

        Switch {
            checked: active
            onToggled: toggleClicked()
        }

        Text {
            id: timeText
            text: time  // 关键绑定
            font.pixelSize: 40
            verticalAlignment: Text.AlignVCenter
            height: parent.height
            // 添加颜色区分状态
            color: modelData.active ? "black" : "gray"
        }

        Text {
            text: label || repeatDays.join(" ") || "仅一次"
            font.pixelSize: 24
            verticalAlignment: Text.AlignVCenter
            height: parent.height
        }

        Item { width: parent.width - timeText.width - parent.spacing*3 - 120; height: 1 }

        Button {
            text: "×"
            onClicked: deleteClicked()
        }

        // modules/AlarmClock/AlarmItemDelegate.qml
        // Rectangle {
        //     anchors.fill: parent
        //     color: active ? "#e3f2fd" : "#f5f5f5"
        //     radius: 5
        //
        //     // 添加按压效果
        //     states: State {
        //         name: "pressed"
        //         when: mouseArea.pressed
        //         PropertyChanges { target: background; opacity: 0.7 }
        //     }
        //
        //     MouseArea {
        //         id: mouseArea
        //         anchors.fill: parent
        //         onClicked: toggleClicked()
        //     }
        // }
    }
}