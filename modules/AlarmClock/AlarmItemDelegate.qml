// modules/AlarmClock/AlarmItemDelegate.qml
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12


Item {
    width: ListView.view.width
    height: 60

    signal toggle(bool checked)
    signal remove()

    Rectangle {
        anchors.fill: parent
        color: "#333333"
        radius: 4

        RowLayout {
            anchors.fill: parent
            spacing: 20
            anchors.margins: 10

            Switch {
                checked: model.enabled
                onToggled: toggle(checked)
            }

            Text {
                text: Qt.formatTime(model.time, "hh:mm")
                color: model.enabled ? "white" : "#666666"
                font.pixelSize: 24
                Layout.fillWidth: true
            }

            Button {
                text: "×"
                onClicked: remove()
                contentItem: Text {
                    text: parent.text
                    color: "#FF4444"
                    font.pixelSize: 24
                }
                background: Rectangle { color: "transparent" }
            }
        }
    }
}