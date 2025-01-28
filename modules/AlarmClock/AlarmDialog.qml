import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Popup {
    id: root
    width: 600
    height: 400
    modal: true
    focus: true
    padding: 20
    x: (parent.width - width)/2
    y: (parent.height - height)/2

    property int selectedHours: hourBox.currentIndex
    property int selectedMinutes: minuteBox.currentIndex
    property string selectedDays: getSelectedDays()
    property alias labelText: labelField.text

    signal accepted()
    signal rejected()

    background: Rectangle {
        color: "#2D2D2D"
        radius: 8
        border.color: "#4D4D4D"
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 15

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 10

            ComboBox {
                id: hourBox
                model: 24
                currentIndex: new Date().getHours()
                delegate: ItemDelegate {
                    width: hourBox.width
                    text: index < 10 ? "0" + index : index.toString()
                }
            }

            Text { text: ":"; color: "white"; font.pixelSize: 24 }

            ComboBox {
                id: minuteBox
                model: 60
                currentIndex: new Date().getMinutes()
                delegate: ItemDelegate {
                    width: minuteBox.width
                    text: index < 10 ? "0" + index : index.toString()
                }
            }
        }

        GridLayout {
            id: daysLayout
            columns: 4
            Layout.alignment: Qt.AlignHCenter

            Repeater {
                model: 7
                CheckBox {
                    text: qsTr(["周一", "周二", "周三", "周四", "周五", "周六", "周日"][index])
                    checked: false
                    contentItem: Text {
                        text: parent.text
                        color: parent.checked ? "#2196F3" : "white"
                    }
                }
            }
        }

        TextField {
            id: labelField
            Layout.fillWidth: true
            placeholderText: qsTr("闹钟标签")
            color: "white"
            background: Rectangle {
                color: "#3D3D3D"
                radius: 4
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignRight
            spacing: 15

            Button {
                text: qsTr("取消")
                onClicked: root.close()
                background: Rectangle {
                    color: "#666666"
                    radius: 4
                }
            }

            Button {
                text: qsTr("确定")
                onClicked: {
                    root.accepted()
                    root.close()
                }
                background: Rectangle {
                    color: "#2196F3"
                    radius: 4
                }
            }
        }
    }

    function getSelectedDays() {
        let days = []
        for (let i = 0; i < 7; i++) {
            if (daysLayout.children[i].checked)
                days.push(i+1)
        }
        return days.join(",")
    }
}