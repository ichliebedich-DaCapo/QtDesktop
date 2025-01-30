import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12


Button {
    property int dayIndex: 0
    property bool isChecked: false

    signal toggled(bool checked)

    width: 40
    height: 40
    checkable: true
    text: ["一", "二", "三", "四", "五", "六", "日"][dayIndex]

    background: Rectangle {
        color: isChecked ? primaryColor : "#bdc3c7"
        radius: 5
    }

    contentItem: Text {
        text: parent.text
        color: "white"
        font.pixelSize: 16
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    onClicked: {
        isChecked = !isChecked
        toggled(isChecked)
    }
}
