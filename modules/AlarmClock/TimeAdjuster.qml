import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

ColumnLayout {
    property string title: ""
    property int minValue: 0
    property int maxValue: 59
    property int step: 1
    property int currentValue: 0

    signal valueChanged(int value)

    spacing: 5

    Label {
        text: title
        font.pixelSize: 16
        color: "#7f8c8d"
        Layout.alignment: Qt.AlignHCenter
    }

    RowLayout {
        Layout.alignment: Qt.AlignHCenter
        spacing: 15

        IconButton {
            iconText: "-"
            onClicked: adjustValue(-step)
        }

        Text {
            text: currentValue.toString().padStart(2, '0')
            font.pixelSize: 32
            color: "#2c3e50"
        }

        IconButton {
            iconText: "+"
            onClicked: adjustValue(step)
        }
    }

    function adjustValue(step) {
        currentValue += step
        currentValue = Math.max(minValue, Math.min(currentValue, maxValue))
        valueChanged(currentValue)
        updateTime()
    }
}
