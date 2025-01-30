import QtQuick 2.12
import QtQuick.Controls 2.12

Item {
    id: dayToggleComponent

    property bool selected: false
    property int dayIndex: 0

    signal toggled(bool checked)

    Rectangle {
        id: toggle
        width: 40
        height: 40
        radius: 20
        color: selected ? parent.parent.primaryColor : "white"
        border.color: selected ? parent.parent.primaryColor : "#bdc3c7"


        Text {
            text: ["一", "二", "三", "四", "五", "六", "日"][dayIndex]
            anchors.centerIn: parent
            font.pixelSize: 16
            color: selected ? "white" : "#7f8c8d"
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                toggle.selected = !toggle.selected
                toggle.toggled(toggle.selected)
            }
        }
    }
}